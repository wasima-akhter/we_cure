import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:glady/core/api/services/api_request.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/utils/basic_import.dart';
import '../../appointment/model/join_video_call_model.dart';

enum VideoCallState { loading, ready, error }

class VideoCallController extends GetxController {
  // ── Engine (nullable to prevent LateInitializationError) ──────────────────
  RtcEngine? _agoraEngine;
  bool _engineInitialized = false;

  // Expose a safe getter so the view can use it without null checks everywhere
  RtcEngine? get agoraEngine => _agoraEngine;

  // ── Agora credentials ──────────────────────────────────────────────────────
  String _appId = '';
  String channelName = '';
  String _token = '';

  // ── Screen state ───────────────────────────────────────────────────────────
  final Rx<VideoCallState> callState = VideoCallState.loading.obs;
  final RxString errorMessage = ''.obs;

  // ── Local state ────────────────────────────────────────────────────────────
  final RxBool isMuted = false.obs;
  final RxBool isCameraOn = true.obs;
  final RxBool isCameraFlipped = false.obs;
  final RxBool isConnected = false.obs;
  final RxString callDuration = '00:00'.obs;
  final RxBool isLocalUserJoined = false.obs;

  // ── Remote state ───────────────────────────────────────────────────────────
  final RxBool isRemoteUserJoined = false.obs;
  final RxBool isRemoteCameraOff = false.obs;
  final RxBool isRemoteMuted = false.obs;

  int? localUid;
  int? remoteUid;

  // ── Timer ──────────────────────────────────────────────────────────────────
  Timer? _durationTimer;
  int _seconds = 0;

  // ── Route args ─────────────────────────────────────────────────────────────
  String? appointmentId;
  String? userId;

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args is String) {
      appointmentId = args;
    } else if (args is Map) {
      appointmentId = args['appointmentId']?.toString();
      userId = args['userId']?.toString();
    }

    if (appointmentId == null || appointmentId!.isEmpty) {
      _setError('Appointment ID is missing');
      return;
    }

    _loadAndInitialize(appointmentId!);
  }

  @override
  void onClose() {
    _durationTimer?.cancel();
    _disposeAgora(); // fire-and-forget; safe because of null/flag guards
    super.onClose();
  }

  // ── Initialization ─────────────────────────────────────────────────────────

  Future<void> _loadAndInitialize(String appointmentId) async {
    callState.value = VideoCallState.loading;

    try {
      final result = await getVideoCallInfo(appointmentId);
      _appId = result.data.appId;
      channelName = result.data.channel;
      _token = result.data.token;

      await _initializeAgora();

      // callState is set to ready inside onJoinChannelSuccess
    } catch (e) {
      debugPrint('[VideoCall] _loadAndInitialize error: $e');
      _setError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> _initializeAgora() async {
    await _requestPermissions();

    _agoraEngine = createAgoraRtcEngine();

    await _agoraEngine!.initialize(RtcEngineContext(appId: _appId));

    _engineInitialized = true;

    _setupEventHandlers();

    await _agoraEngine!.enableVideo();

    await _joinChannel();
  }

  Future<void> _requestPermissions() async {
    final statuses = await [Permission.camera, Permission.microphone].request();
    if (statuses[Permission.camera] != PermissionStatus.granted ||
        statuses[Permission.microphone] != PermissionStatus.granted) {
      // Not throwing here — Agora itself will surface the issue if perms are missing.
      CustomSnackBar.error('Camera and microphone permission required');
    }
  }

  // ── Agora event handlers ───────────────────────────────────────────────────

  void _setupEventHandlers() {
    _agoraEngine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint(
            '[AgoraLog] onJoinChannelSuccess | UID: ${connection.localUid}',
          );
          localUid = connection.localUid;
          isLocalUserJoined.value = true;
          isConnected.value = true;
          callState.value = VideoCallState.ready; // ← screen is now live
          _startDurationTimer();
        },

        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint('[AgoraLog] onUserJoined | remoteUid: $remoteUid');
          this.remoteUid = remoteUid;
          isRemoteUserJoined.value = true;
          // Camera/audio state will be confirmed by subsequent state events
        },

        onUserOffline:
            (
              RtcConnection connection,
              int remoteUid,
              UserOfflineReasonType reason,
            ) {
              debugPrint(
                '[AgoraLog] onUserOffline | remoteUid: $remoteUid | reason: $reason',
              );
              this.remoteUid = null;
              isRemoteUserJoined.value = false;
              isRemoteCameraOff.value = true;
              isRemoteMuted.value = true;
            },

        onFirstRemoteVideoDecoded:
            (
              RtcConnection connection,
              int uid,
              int width,
              int height,
              int elapsed,
            ) {
              debugPrint(
                '[AgoraLog] onFirstRemoteVideoDecoded | UID: $uid | ${width}x$height',
              );
              remoteUid = uid;
              isRemoteUserJoined.value = true;
              isRemoteCameraOff.value = false;
            },

        onUserMuteVideo: (RtcConnection connection, int uid, bool muted) {
          debugPrint('[AgoraLog] onUserMuteVideo | UID: $uid | muted: $muted');
          if (uid != remoteUid) return;
          // muted=true  → peer turned camera OFF  → isRemoteCameraOff = true
          // muted=false → peer turned camera ON   → isRemoteCameraOff = false
          isRemoteCameraOff.value = muted;
        },

        onRemoteVideoStateChanged: (connection, uid, state, reason, elapsed) {
          debugPrint(
            '[AgoraLog] onRemoteVideoStateChanged | UID: $uid | state: $state | reason: $reason',
          );

          // Reason is the most precise signal — check it first
          if (reason ==
                  RemoteVideoStateReason.remoteVideoStateReasonRemoteMuted ||
              reason ==
                  RemoteVideoStateReason.remoteVideoStateReasonLocalMuted) {
            isRemoteCameraOff.value = true;
            return;
          }
          if (reason ==
                  RemoteVideoStateReason.remoteVideoStateReasonRemoteUnmuted ||
              reason ==
                  RemoteVideoStateReason.remoteVideoStateReasonLocalUnmuted) {
            isRemoteCameraOff.value = false;
            return;
          }

          // Fallback: use stream state
          switch (state) {
            case RemoteVideoState.remoteVideoStateDecoding:
              isRemoteCameraOff.value = false;
              break;
            case RemoteVideoState.remoteVideoStateStopped:
            case RemoteVideoState.remoteVideoStateFailed:
            case RemoteVideoState.remoteVideoStateStarting:
              isRemoteCameraOff.value = true;
              break;
            case RemoteVideoState.remoteVideoStateFrozen:
              // Network lag — don't change camera-off state; just let it freeze
              break;
            default:
              break;
          }
        },

        onRemoteAudioStateChanged:
            (
              RtcConnection connection,
              int uid,
              RemoteAudioState state,
              RemoteAudioStateReason reason,
              int elapsed,
            ) {
              debugPrint(
                '[AgoraLog] onRemoteAudioStateChanged | UID: $uid | state: $state | reason: $reason',
              );

              if (state == RemoteAudioState.remoteAudioStateStopped ||
                  state == RemoteAudioState.remoteAudioStateFailed ||
                  reason ==
                      RemoteAudioStateReason.remoteAudioReasonRemoteMuted) {
                isRemoteMuted.value = true;
              } else if (state == RemoteAudioState.remoteAudioStateDecoding ||
                  reason ==
                      RemoteAudioStateReason.remoteAudioReasonRemoteUnmuted) {
                isRemoteMuted.value = false;
              }
            },

        onError: (ErrorCodeType err, String msg) {
          debugPrint('[AgoraLog] Error | code: $err | msg: $msg');
        },
      ),
    );
  }

  // ── Channel ────────────────────────────────────────────────────────────────

  Future<void> _joinChannel() async {
    await _agoraEngine!.joinChannel(
      token: _token,
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileCommunication,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
      ),
    );
  }

  Future<void> _leaveChannel() async {
    if (!_engineInitialized || _agoraEngine == null) return;
    try {
      await _agoraEngine!.leaveChannel();
      isLocalUserJoined.value = false;
      isRemoteUserJoined.value = false;
      isConnected.value = false;
    } catch (e) {
      debugPrint('[VideoCall] _leaveChannel error: $e');
    }
  }

  Future<void> _disposeAgora() async {
    if (!_engineInitialized || _agoraEngine == null) return;
    try {
      await _agoraEngine!.leaveChannel();
      await _agoraEngine!.release();
      _agoraEngine = null;
      _engineInitialized = false;
    } catch (e) {
      debugPrint('[VideoCall] _disposeAgora error: $e');
    }
  }

  // ── Timer ──────────────────────────────────────────────────────────────────

  void _startDurationTimer() {
    _durationTimer?.cancel();

    _seconds = 0;
    callDuration.value = '00:00';

    _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _seconds++;

      final m = (_seconds ~/ 60).toString().padLeft(2, '0');
      final s = (_seconds % 60).toString().padLeft(2, '0');

      callDuration.value = '$m:$s';
    });
  }

  // ── Controls ───────────────────────────────────────────────────────────────

  Future<void> toggleCamera() async {
    if (_agoraEngine == null) return;
    isCameraOn.toggle();
    try {
      await _agoraEngine!.muteLocalVideoStream(!isCameraOn.value);
      debugPrint('[Agora] Local camera ${isCameraOn.value ? "ON" : "OFF"}');
    } catch (e) {
      isCameraOn.toggle(); // roll back
      debugPrint('[VideoCall] toggleCamera error: $e');
    }
  }

  Future<void> toggleMute() async {
    if (_agoraEngine == null) return;
    isMuted.toggle();
    try {
      await _agoraEngine!.muteLocalAudioStream(isMuted.value);
    } catch (e) {
      isMuted.toggle(); // roll back
      debugPrint('[VideoCall] toggleMute error: $e');
    }
  }

  Future<void> flipCamera() async {
    if (_agoraEngine == null) return;
    try {
      await _agoraEngine!.switchCamera();
      isCameraFlipped.toggle();
    } catch (e) {
      debugPrint('[VideoCall] flipCamera error: $e');
    }
  }

  Future<void> endCall() async {
    _durationTimer?.cancel();
    await _leaveChannel();
    Get.back();
  }

  // ── Error helper ───────────────────────────────────────────────────────────

  void _setError(String message) {
    errorMessage.value = message;
    callState.value = VideoCallState.error;
    CustomSnackBar.error(message);
    // Give the snackbar a moment to show, then close the screen
    Future.delayed(const Duration(seconds: 2), Get.back);
  }

  // ── API ────────────────────────────────────────────────────────────────────

  Future<JoinVideoCallModel> getVideoCallInfo(String id) async {
    return ApiRequest().get(
      fromJson: JoinVideoCallModel.fromJson,
      endPoint: '/appointments/$id/video/token',
      isLoading: isRemoteUserJoined,
    );
  }
}
