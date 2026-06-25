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
                  icon: controller.isCameraFlipped.value
                      ? Icons.videocam_off
                      : Icons.videocam,
                  onTap: controller.toggleCamera,
                  backgroundColor: controller.isCameraFlipped.value
                      ? Colors.white.withOpacity(0.3)
                      : Colors.white.withOpacity(0.9),
                  iconColor: controller.isCameraFlipped.value
                      ? Colors.white
                      : Colors.black87,
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
            child: Obx(
              () =>
                  controller.isRemoteUserJoined.value &&
                      controller.remoteUid != null
                  ? AgoraVideoView(
                      controller: VideoViewController.remote(
                        rtcEngine: controller.agoraEngine,
                        canvas: VideoCanvas(uid: controller.remoteUid),
                        connection: RtcConnection(
                          channelId: controller.channelName,
                        ),
                      ),
                    )
                  : _buildWaitingState(),
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
                        Icon(
                          Icons.mic_off,
                          color: Colors.redAccent,
                          size: 14.sp,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Your mic is off',
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
              if (controller.isCameraFlipped.value &&
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
                        'Camera off',
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
