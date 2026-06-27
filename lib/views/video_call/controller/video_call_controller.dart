import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:glady/core/api/services/api_request.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/utils/basic_import.dart';
import '../../appointment/model/join_video_call_model.dart';

class VideoCallController extends GetxController {
  late RtcEngine agoraEngine;

  String _appId = '';
  String channelName = '';
  String _token = '';

  final RxBool isMuted = false.obs;
  final RxBool isCameraFlipped = false.obs;
  final RxBool isConnected = false.obs;
  final RxString callDuration = '00:00'.obs;
  final RxBool isLocalUserJoined = false.obs;
  final RxBool isRemoteUserJoined = false.obs;

  final RxBool isRemoteCameraOff = false.obs;
  final RxBool isRemoteMuted = false.obs;

  int? localUid;
  int? remoteUid;

  Timer? _durationTimer;
  int _seconds = 0;

  //

  String? appointmentId;
  String? userId;
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
      Get.snackbar('Error', 'Appointment ID is missing');
      return;
    }

    _loadAndInitialize(appointmentId!);
  }

  @override
  void onClose() {
    _durationTimer?.cancel();
    _leaveChannel();
    agoraEngine.release();
    super.onClose();
  }

  Future<void> _loadAndInitialize(String appointmentId) async {
    try {
      final result = await getVideoCallInfo(appointmentId);
      _appId = result.data.appId;
      channelName = result.data.channel;
      _token = result.data.token;
      await _initializeAgora();
    } catch (e) {
      print('Error loading video call info: $e');
      CustomSnackBar.error('Failed to load video call info');
    }
  }

  Future<void> _initializeAgora() async {
    try {
      await _requestPermissions();

      agoraEngine = createAgoraRtcEngine();

      // Doc অনুযায়ী শুধু appId দিতে হবে
      await agoraEngine.initialize(RtcEngineContext(appId: _appId));

      _setupEventHandlers();

      await agoraEngine.enableVideo();

      // Doc অনুযায়ী startPreview() নেই
      await _joinChannel();
    } catch (e) {
      print('Error initializing Agora: $e');
      CustomSnackBar.error('Failed to initialize video call');
    }
  }

  Future<void> _requestPermissions() async {
    final statuses = await [Permission.camera, Permission.microphone].request();
    if (statuses[Permission.camera] != PermissionStatus.granted ||
        statuses[Permission.microphone] != PermissionStatus.granted) {
      CustomSnackBar.error('Camera and microphone permission required');
    }
  }

  void _setupEventHandlers() {
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          print('=== onJoinChannelSuccess ===');
          print('Local UID: ${connection.localUid}');
          print('Elapsed: $elapsed');

          localUid = connection.localUid;
          isLocalUserJoined.value = true;
          isConnected.value = true;
          _startDurationTimer();
        },

        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          print('=== onUserJoined ===');
          print('Remote UID: $remoteUid');
          print('Elapsed: $elapsed');

          this.remoteUid = remoteUid;
          isRemoteUserJoined.value = true;
          isRemoteCameraOff.value = false;
        },

        onFirstRemoteVideoDecoded:
            (
              RtcConnection connection,
              int uid,
              int width,
              int height,
              int elapsed,
            ) {
              print('=== onFirstRemoteVideoDecoded ===');
              print('UID: $uid');
              print('Resolution: ${width}x$height');
              print('Elapsed: $elapsed');

              remoteUid = uid;
              isRemoteUserJoined.value = true;
              isRemoteCameraOff.value = false;
            },

        onUserMuteVideo: (RtcConnection connection, int uid, bool muted) {
          print('=== onUserMuteVideo ===');
          print('UID: $uid');
          print('Muted: $muted');

          isRemoteCameraOff.value = muted;
        },

        onUserOffline:
            (
              RtcConnection connection,
              int remoteUid,
              UserOfflineReasonType reason,
            ) {
              print('=== onUserOffline ===');
              print('Remote UID: $remoteUid');
              print('Reason: $reason');

              this.remoteUid = null;
              isRemoteUserJoined.value = false;
              isRemoteCameraOff.value = false;
              isRemoteMuted.value = false;
            },
        onRemoteVideoStateChanged: (connection, uid, state, reason, elapsed) {
          print('Video state: $state, reason: $reason');

          switch (state) {
            case RemoteVideoState.remoteVideoStateStarting:
            case RemoteVideoState.remoteVideoStateDecoding:
            case RemoteVideoState.remoteVideoStateFrozen:
              isRemoteCameraOff.value = false;
              break;

            case RemoteVideoState.remoteVideoStateStopped:
              isRemoteCameraOff.value = true;
              break;

            case RemoteVideoState.remoteVideoStateFailed:
              isRemoteCameraOff.value = true;
              break;
          }
        },

        // onRemoteVideoStateChanged:
        //     (
        //       RtcConnection connection,
        //       int uid,
        //       RemoteVideoState state,
        //       RemoteVideoStateReason reason,
        //       int elapsed,
        //     ) {
        //       print('=== onRemoteVideoStateChanged ===');
        //       print('UID: $uid');
        //       print('State: $state');
        //       print('Reason: $reason');
        //       print('Elapsed: $elapsed');

        //       if (reason ==
        //           RemoteVideoStateReason.remoteVideoStateReasonRemoteMuted) {
        //         isRemoteCameraOff.value = true;
        //         print('Remote camera OFF');
        //       } else if (reason ==
        //           RemoteVideoStateReason.remoteVideoStateReasonRemoteUnmuted) {
        //         isRemoteCameraOff.value = false;
        //         print('Remote camera ON');
        //       }
        //     },
        onRemoteAudioStateChanged:
            (
              RtcConnection connection,
              int uid,
              RemoteAudioState state,
              RemoteAudioStateReason reason,
              int elapsed,
            ) {
              print('=== onRemoteAudioStateChanged ===');
              print('UID: $uid');
              print('State: $state');
              print('Reason: $reason');
              print('Elapsed: $elapsed');

              if (reason ==
                  RemoteAudioStateReason.remoteAudioReasonRemoteMuted) {
                isRemoteMuted.value = true;
                print('Remote microphone MUTED');
              } else if (reason ==
                  RemoteAudioStateReason.remoteAudioReasonRemoteUnmuted) {
                isRemoteMuted.value = false;
                print('Remote microphone UNMUTED');
              }
            },

        onError: (ErrorCodeType err, String msg) {
          print('=== Agora Error ===');
          print('Code: $err');
          print('Message: $msg');
        },
      ),
    );
  }

  Future<void> _joinChannel() async {
    try {
      await agoraEngine.joinChannel(
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
    } catch (e) {
      print('Error joining channel: $e');
    }
  }

  Future<void> _leaveChannel() async {
    try {
      await agoraEngine.leaveChannel();
      isLocalUserJoined.value = false;
      isRemoteUserJoined.value = false;
      isConnected.value = false;
    } catch (e) {
      print('Error leaving channel: $e');
    }
  }

  void _startDurationTimer() {
    _seconds = 0;
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds++;
      final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
      final seconds = (_seconds % 60).toString().padLeft(2, '0');
      callDuration.value = '$minutes:$seconds';
    });
  }

  Future<void> toggleCamera() async {
    try {
      bool isEnabled = !isCameraFlipped.value;
      await agoraEngine.enableLocalVideo(isEnabled);
      isCameraFlipped.value = !isCameraFlipped.value;
    } catch (e) {
      print('Error toggling camera: $e');
    }
  }

  Future<void> toggleMute() async {
    try {
      isMuted.value = !isMuted.value;
      await agoraEngine.muteLocalAudioStream(isMuted.value);
    } catch (e) {
      print('Error toggling mute: $e');
    }
  }

  Future<void> flipCamera() async {
    try {
      await agoraEngine.switchCamera();
      isCameraFlipped.value = !isCameraFlipped.value;
    } catch (e) {
      print('Error flipping camera: $e');
    }
  }

  Future<void> endCall() async {
    try {
      _durationTimer?.cancel();
      await _leaveChannel();
      Get.back();
    } catch (e) {
      print('Error ending call: $e');
    }
  }

  Future<JoinVideoCallModel> getVideoCallInfo(String id) async {
    return ApiRequest().get(
      fromJson: JoinVideoCallModel.fromJson,
      endPoint: '/appointments/$id/video/token',
      isLoading: isRemoteUserJoined,
    );
  }
}
