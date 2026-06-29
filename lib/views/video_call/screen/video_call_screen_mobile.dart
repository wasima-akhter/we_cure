/*

part of 'video_call_screen.dart';

class VideoCallScreenMobile extends GetView<VideoCallController> {
  const VideoCallScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: Dimensions.verticalSize * 0.4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // _buildControlButton(
              //   icon: Icons.mark_chat_read_outlined,
              //   onTap: () => Get.toNamed(Routes.inboxScreen),
              //   backgroundColor: Colors.white.withOpacity(0.9),
              // ),
              Obx(
                () => _buildControlButton(
                  icon: controller.isCameraOn.value
                      ? Icons.videocam
                      : Icons.videocam_off,
                  onTap: controller.toggleCamera,
                  backgroundColor: controller.isCameraOn.value
                      ? Colors.white.withOpacity(0.9)
                      : Colors.white.withOpacity(0.3),
                  iconColor: controller.isCameraOn.value
                      ? Colors.black87
                      : Colors.white,
                ),
              ),
              Obx(
                () => _buildControlButton(
                  icon: controller.isMuted.value ? Icons.mic_off : Icons.mic,
                  onTap: controller.toggleMute,
                  backgroundColor: controller.isMuted.value
                      ? Colors.white.withOpacity(0.3)
                      : Colors.white.withOpacity(0.9),
                  iconColor: controller.isMuted.value
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
              // Obx(
              //       () => _buildControlButton(
              //     icon: controller.isCameraFlipped.value
              //         ? Icons.flip_camera_ios
              //         : Icons.flip_camera_android,
              //     onTap: controller.flipCamera,
              //     backgroundColor: Colors.white.withOpacity(0.9),
              //   ),
              // ),
              _buildControlButton(
                icon: Icons.call_end,
                onTap: controller.endCall,
                backgroundColor: Colors.red,
                iconColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          // ── Remote video view (full screen) ──────────────────────────────
          Positioned.fill(
            child: Obx(() {
              // If the camera is off, show ONLY the placeholder overlay
              if (controller.isRemoteCameraOff.value) {
                return _buildRemoteCameraOffOverlay();
              }

              return controller.isRemoteUserJoined.value &&
                      controller.remoteUid != null
                  ? Stack(
                      children: [
                        AgoraVideoView(
                          controller: VideoViewController.remote(
                            rtcEngine: controller.agoraEngine,
                            canvas: VideoCanvas(uid: controller.remoteUid),
                            connection: RtcConnection(
                              channelId: controller.channelName,
                            ),
                          ),
                        ),
                        Obx(
                          () => controller.isRemoteCameraOff.value
                              ? _buildRemoteCameraOffOverlay()
                              : const SizedBox.shrink(),
                        ),
                      ],
                    )
                  : _buildWaitingState();
            }),
          ), // ── Remote mic-off badge ──────────────────────
          Positioned(
            bottom: 160, // ← was 90, which overlapped with local control area
            left: 16,
            child: Obx(
              () => controller.isRemoteMuted.value
                  ? _buildRemoteMutedBadge()
                  : const SizedBox.shrink(),
            ),
          ),

          // ── Local video preview (Picture in Picture) ──────────────────────
          Positioned(
            top: 60,
            right: 16,
            child: Obx(
              () => controller.isLocalUserJoined.value
                  ? _buildLocalPreview()
                  : SizedBox.shrink(),
            ),
          ),
          // Your own mic badge — shift up when remote is also muted
          // Obx(() {
          //   final extraOffset = controller.isRemoteMuted.value ? 36.h : 0.0;
          //   return Positioned(
          //     bottom: 90 + extraOffset,
          //     left: 0,
          //     right: 0,
          //     child: _buildLocalPreview(), // existing centered badge
          //   );
          // }),
          // ── Call duration timer ───────────────────────────────────────────
          Positioned(
            top: 70,
            left: 0,
            right: 0,
            child: Center(
              child: Obx(
                () => controller.isConnected.value
                    ? Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8.w,
                              height: 8.h,
                              decoration: const BoxDecoration(
                                color: Colors.greenAccent,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              controller.callDuration.value,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox.shrink(),
              ),
            ),
          ),

          // ── Connecting indicator ──────────────────────────────────────────
          Positioned(
            top: 100,
            left: 16,
            child: Obx(() {
              if (!controller.isConnected.value) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: CustomColors.primary.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 12.w,
                        height: 12.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.w,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Connecting...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return SizedBox.shrink();
            }),
          ),

          // ── Muted indicator badge ─────────────────────────────────────────
          Positioned(
            bottom: 90,
            left: 0,
            right: 0,
            child: Obx(() {
              if (controller.isMuted.value) {
                return Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.mic_off, color: Colors.redAccent, size: 14),
                        SizedBox(width: 6.w),
                        Text(
                          'Your mic is off', // LOCAL — you muted yourself
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return SizedBox.shrink();
            }),
          ),
          // ── Camera off overlay on local pip ──────────────────────────────
          Positioned(
            top: 60,
            right: 16,
            child: Obx(() {
              if (!controller.isCameraOn.value &&
                  controller.isLocalUserJoined.value) {
                return Container(
                  width: 120.w,
                  height: 160.h,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(Dimensions.radius),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.videocam_off,
                        color: Colors.white54,
                        size: 28.sp,
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'Camera off', // LOCAL — you turned your own camera off
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return SizedBox.shrink();
            }),
          ),
          // ── Remote user left banner ───────────────────────────────────────
          Positioned(
            top: 160,
            left: 0,
            right: 0,
            child: Obx(() {
              final wasJoined = controller.isLocalUserJoined.value;
              final remoteLeft =
                  wasJoined && !controller.isRemoteUserJoined.value;

              if (remoteLeft) {
                return Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      'The other user has left the call',
                      style: TextStyle(color: Colors.white70, fontSize: 13.sp),
                    ),
                  ),
                );
              }
              return SizedBox.shrink();
            }),
          ),
        ],
      ),
    );
  }

  // ── Remote camera-off full-screen overlay ──────────────────────────────
  Widget _buildRemoteCameraOffOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black87,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.videocam_off, color: Colors.white54, size: 52.sp),
            SizedBox(height: 12.h),
            Text(
              "Peer's camera is off", // REMOTE — peer turned their camera off
              style: TextStyle(color: Colors.white54, fontSize: 15.sp),
            ),
          ],
        ),
      ),
    );
  }

  // ── Remote user mic-off badge (bottom-left) ───────────────────────────
  Widget _buildRemoteMutedBadge() {
    return Container(
      margin: EdgeInsets.only(left: 16.w, bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.mic_off, color: Colors.orangeAccent, size: 13.sp),
          SizedBox(width: 5.w),
          Text(
            "Peer's mic is off", // REMOTE — peer muted themselves
            style: TextStyle(color: Colors.white, fontSize: 11.sp),
          ),
        ],
      ),
    );
  }

  // ── Waiting / ringing state (before remote joins) ───────────────────────
  Widget _buildWaitingState() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pulsing avatar placeholder
            Container(
              width: 90.w,
              height: 90.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
                border: Border.all(
                  color: CustomColors.primary.withOpacity(0.6),
                  width: 2,
                ),
              ),
              child: Icon(Icons.person, size: 44.sp, color: Colors.white54),
            ),
            SizedBox(height: 24.h),
            Text(
              'Waiting for other user...',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: 24.w,
              height: 24.h,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: CustomColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Local PiP preview ────────────────────────────────────────────────────
  Widget _buildLocalPreview() {
    return Container(
      width: 120.w,
      height: 160.h,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(Dimensions.radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.radius),
        child: AgoraVideoView(
          controller: VideoViewController(
            rtcEngine: controller.agoraEngine,
            canvas: const VideoCanvas(uid: 0),
          ),
        ),
      ),
    );
  }

  // ── Control button ────────────────────────────────────────────────────────
  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color backgroundColor,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56.w,
        height: 56.h,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: CustomColors.borderColor),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor ?? Colors.black87, size: 28.h),
      ),
    );
  }
}


*/

part of 'video_call_screen.dart';

class VideoCallScreenMobile extends GetView<VideoCallController> {
  const VideoCallScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: Dimensions.verticalSize * 0.4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Obx(
                () => _buildControlButton(
                  icon: controller.isCameraOn.value
                      ? Icons.videocam
                      : Icons.videocam_off,
                  onTap: controller.toggleCamera,
                  backgroundColor: controller.isCameraOn.value
                      ? Colors.white.withOpacity(0.9)
                      : Colors.white.withOpacity(0.3),
                  iconColor: controller.isCameraOn.value
                      ? Colors.black87
                      : Colors.white,
                ),
              ),
              Obx(
                () => _buildControlButton(
                  icon: controller.isMuted.value ? Icons.mic_off : Icons.mic,
                  onTap: controller.toggleMute,
                  backgroundColor: controller.isMuted.value
                      ? Colors.white.withOpacity(0.3)
                      : Colors.white.withOpacity(0.9),
                  iconColor: controller.isMuted.value
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
              _buildControlButton(
                icon: Icons.call_end,
                onTap: controller.endCall,
                backgroundColor: Colors.red,
                iconColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
      // ── Root: gate everything behind callState ──────────────────────────
      body: Obx(() {
        switch (controller.callState.value) {
          case VideoCallState.loading:
            return _buildLoadingState();

          case VideoCallState.error:
            return _buildErrorState(controller.errorMessage.value);

          case VideoCallState.ready:
            // Engine is guaranteed non-null here — safe to use !
            return _buildCallBody(controller.agoraEngine!);
        }
      }),
    );
  }

  // ── Loading screen (waiting for token + Agora init) ──────────────────────
  Widget _buildLoadingState() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: CustomColors.primary),
            SizedBox(height: 20.h),
            Text(
              'Preparing call...',
              style: TextStyle(color: Colors.white70, fontSize: 15.sp),
            ),
          ],
        ),
      ),
    );
  }

  // ── Error screen (API failed, outside time window, etc.) ─────────────────
  Widget _buildErrorState(String message) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.redAccent, size: 52.sp),
              SizedBox(height: 16.h),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 15.sp),
              ),
              SizedBox(height: 24.h),
              TextButton(
                onPressed: Get.back,
                child: Text(
                  'Go Back',
                  style: TextStyle(
                    color: CustomColors.primary,
                    fontSize: 15.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Main call body (only rendered when engine is ready) ──────────────────
  Widget _buildCallBody(RtcEngine engine) {
    return Stack(
      children: [
        // ── Remote video / placeholder (full screen) ──────────────────────
        Positioned.fill(
          child: Obx(() {
            if (controller.isRemoteCameraOff.value) {
              return _buildRemoteCameraOffOverlay();
            }

            if (controller.isRemoteUserJoined.value &&
                controller.remoteUid != null) {
              return AgoraVideoView(
                controller: VideoViewController.remote(
                  rtcEngine: engine,
                  canvas: VideoCanvas(uid: controller.remoteUid),
                  connection: RtcConnection(channelId: controller.channelName),
                ),
              );
            }

            return _buildWaitingState();
          }),
        ),

        // ── Remote mic-off badge (bottom-left) ────────────────────────────
        Positioned(
          bottom: 160,
          left: 16,
          child: Obx(
            () => controller.isRemoteMuted.value
                ? _buildRemoteMutedBadge()
                : const SizedBox.shrink(),
          ),
        ),

        // ── Local PiP preview (top-right) ─────────────────────────────────
        Positioned(
          top: 60,
          right: 16,
          child: Obx(() {
            if (!controller.isLocalUserJoined.value) {
              return const SizedBox.shrink();
            }
            // If local camera is off — show dark placeholder instead of video
            if (!controller.isCameraOn.value) {
              return _buildLocalCameraOffPip();
            }
            return _buildLocalPreview(engine);
          }),
        ),

        // ── Call duration timer (top-center) ──────────────────────────────
        Positioned(
          top: 70,
          left: 0,
          right: 0,
          child: Center(
            child: Obx(
              () => controller.isConnected.value
                  ? Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.h,
                            decoration: const BoxDecoration(
                              color: Colors.greenAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            controller.callDuration.value,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ),

        // ── Connecting indicator (shown before channel join) ───────────────
        Positioned(
          top: 100,
          left: 16,
          child: Obx(() {
            if (controller.isConnected.value) return const SizedBox.shrink();
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: CustomColors.primary.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 12.w,
                    height: 12.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.w,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Connecting...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),

        // ── Local mic-off badge (bottom-center) ───────────────────────────
        Positioned(
          bottom: 90,
          left: 0,
          right: 0,
          child: Obx(() {
            if (!controller.isMuted.value) return const SizedBox.shrink();
            return Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.mic_off,
                      color: Colors.redAccent,
                      size: 14,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'Your mic is off',
                      style: TextStyle(color: Colors.white, fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),

        // ── Remote user left banner ────────────────────────────────────────
        Positioned(
          top: 160,
          left: 0,
          right: 0,
          child: Obx(() {
            final remoteLeft =
                controller.isLocalUserJoined.value &&
                !controller.isRemoteUserJoined.value;
            if (!remoteLeft) return const SizedBox.shrink();
            return Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'The other user has left the call',
                  style: TextStyle(color: Colors.white70, fontSize: 13.sp),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ── Remote camera-off full-screen overlay ─────────────────────────────────
  Widget _buildRemoteCameraOffOverlay() {
    return Container(
      color: Colors.black87,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.videocam_off, color: Colors.white54, size: 52.sp),
          SizedBox(height: 12.h),
          Text(
            "Peer's camera is off",
            style: TextStyle(color: Colors.white54, fontSize: 15.sp),
          ),
        ],
      ),
    );
  }

  // ── Remote user mic-off badge ─────────────────────────────────────────────
  Widget _buildRemoteMutedBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.mic_off, color: Colors.orangeAccent, size: 13.sp),
          SizedBox(width: 5.w),
          Text(
            "Peer's mic is off",
            style: TextStyle(color: Colors.white, fontSize: 11.sp),
          ),
        ],
      ),
    );
  }

  // ── Waiting / ringing state ───────────────────────────────────────────────
  Widget _buildWaitingState() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90.w,
              height: 90.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
                border: Border.all(
                  color: CustomColors.primary.withOpacity(0.6),
                  width: 2,
                ),
              ),
              child: Icon(Icons.person, size: 44.sp, color: Colors.white54),
            ),
            SizedBox(height: 24.h),
            Text(
              'Waiting for other user...',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: 24.w,
              height: 24.h,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: CustomColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Local PiP — live video feed ───────────────────────────────────────────
  Widget _buildLocalPreview(RtcEngine engine) {
    return Container(
      width: 120.w,
      height: 160.h,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(Dimensions.radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.radius),
        child: AgoraVideoView(
          controller: VideoViewController(
            rtcEngine: engine,
            canvas: const VideoCanvas(uid: 0),
          ),
        ),
      ),
    );
  }

  // ── Local PiP — camera-off dark placeholder ───────────────────────────────
  Widget _buildLocalCameraOffPip() {
    return Container(
      width: 120.w,
      height: 160.h,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(Dimensions.radius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.videocam_off, color: Colors.white54, size: 28.sp),
          SizedBox(height: 6.h),
          Text(
            'Camera off',
            style: TextStyle(color: Colors.white54, fontSize: 10.sp),
          ),
        ],
      ),
    );
  }

  // ── Control button ────────────────────────────────────────────────────────
  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color backgroundColor,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56.w,
        height: 56.h,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: CustomColors.borderColor),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor ?? Colors.black87, size: 28.h),
      ),
    );
  }
}
