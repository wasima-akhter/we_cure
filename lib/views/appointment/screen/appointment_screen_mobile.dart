part of 'appointment_screen.dart';

class AppointmentScreenMobile extends GetView<AppointmentController> {
  const AppointmentScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final isUser = AppStorage.isUser == 'USER';

    return Scaffold(
      appBar: CommonAppBar(title: "Appointment", isBack: false),

      body: SafeArea(
        child: AppRefreshIndicator(
          onRefresh: () async {
            if (isUser) {
              await controller.fetchUserAppointments();
            } else {
              await controller.fetchDoctorAppointments();
            }
          },
          child: Obx(() {
            return _buildBody(isUser);
          }),
        ),
      ),
    );
  }

  //
  Widget _buildBody(bool isUser) {
    /// ================= USER =================
    if (isUser) {
      if (controller.isUserLoading.value) {
        return loadingView();
      }

      final appointments = controller.userAppointments.value?.data ?? [];

      if (appointments.isEmpty) {
        return emptyScrollable(name: "appointments");
      }

      return _listViewUser(appointments);
    }

    /// ================= DOCTOR =================
    if (controller.isDoctorLoading.value) {
      return loadingView();
    }

    final appointments = controller.doctorAppointments.value?.data ?? [];

    if (appointments.isEmpty) {
      return emptyScrollable(name: "appointments");
    }

    return _listViewDoctor(appointments);
  }

  Widget _listViewUser(List<Appointments> appointments) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.defaultHorizontalSize,
        vertical: Dimensions.verticalSize,
      ),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final userTimezone =
            Get.isRegistered<ProfileController>() &&
                AppStorage.isUser?.toUpperCase() == "USER"
            ? (ProfileController.to.userProfileModel?.data.timezone ??
                  'Africa/Lagos')
            : 'Africa/Lagos';

        final appointment = appointments[index];

        final doctorTimezone = appointment.doctorTimezone ?? 'Africa/Lagos';

        final isSameTimezone = doctorTimezone == userTimezone;

        final startTime = isSameTimezone
            ? formatTimeToAmPm(
                appointment.appointmentTime,
                date: appointment.appointmentDate.toString(),
              )
            : convertAppointmentTime(
                appointmentDate: appointment.appointmentDate,
                time: appointment.appointmentTime,
                doctorTimezone: doctorTimezone,
                userTimezone: userTimezone,
              ).formattedTime;

        final endTime = isSameTimezone
            ? formatTimeToAmPm(
                appointment.appointmentEndTime,
                date: appointment.appointmentDate.toString(),
              )
            : convertAppointmentTime(
                appointmentDate: appointment.appointmentDate,
                time: appointment.appointmentEndTime,
                doctorTimezone: doctorTimezone,
                userTimezone: userTimezone,
              ).formattedTime;

        final displayDate = isSameTimezone
            ? appointment.appointmentDate
            : tz.TZDateTime.from(
                appointment.appointmentDate,
                tz.getLocation(userTimezone),
              );

        debugPrint(
          ' converted startTime -  endTime : $startTime - $endTime   ',
        );
        debugPrint(
          ' original startTime -  endTime : ${appointment.appointmentTime} - ${appointment.appointmentEndTime}   ',
        );

        debugPrint('doctorTimezone,: $doctorTimezone ');
        debugPrint('userTimezone: $userTimezone ');
        debugPrint(
          'userTimezone from profile: ${ProfileController.to.userProfileModel?.data.timezone} ',
        );

        // check the times and date same way (if same timezone or not) if not, convert to user timezone.
        // .

        return AppointmentCard(
          appointmentId: appointment.id,
          doctorName: appointment.doctorName,
          specialization: appointment.specialtyName,
          time: '$startTime - $endTime',

          // date: DateFormat(
          //   'dd MMM yyyy',
          // ).format(appointment.appointmentDate.toLocal()),
          date: DateFormat('dd MMM yyyy').format(displayDate),

          status: appointment.status.toLowerCase() ?? '',
          onPressed: () => controller.handleAppointmentAction(appointment),
        );
      },
    );
  }

  Widget _listViewDoctor(List<DoctorAppointments> appointments) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.defaultHorizontalSize,
        vertical: Dimensions.verticalSize,
      ),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];

        final startTime = formatTimeToAmPm(
          appointment.appointmentTime,
          date: appointment.appointmentDate.toString(),
        );

        final endTime = formatTimeToAmPm(
          appointment.appointmentEndTime,
          date: appointment.appointmentDate.toString(),
        );

        debugPrint(' appointmentDate - : ${appointment.appointmentDate}   ');
        debugPrint('  startTime -  endTime : $startTime - $endTime   ');
        debugPrint(
          '  appointmentTime -  appointmentEndTime : ${appointment.appointmentTime} - ${appointment.appointmentEndTime}   ',
        );

        return AppointmentCard(
          appointmentId: appointment.id,
          doctorName: appointment.patientName,
          specialization: appointment.specialtyName,
          time: '$startTime - $endTime',
          date: formatDateDMY(appointment.appointmentDate),
          status: appointment.status.toLowerCase() ?? '',
          onPressed: () => controller.handleAppointmentAction(appointment),
        );
      },
    );
  }
}
