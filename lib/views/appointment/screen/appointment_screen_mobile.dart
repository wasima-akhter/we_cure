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
        final appointment = appointments[index];

        final startTime = formatTimeToAmPm(
          appointment.appointmentTime,
          date: appointment.appointmentDate.toString(),
        );

        final endTime = formatTimeToAmPm(
          appointment.appointmentEndTime,
          date: appointment.appointmentDate.toString(),
        );

        debugPrint('  startTime -  endTime : $startTime - $endTime   ');

        return AppointmentCard(
          appointmentId: appointment.id,
          doctorName: appointment.doctorName,
          specialization: appointment.specialtyName,
          time: '$startTime - $endTime',
          date: DateFormat(
            'dd MMM yyyy',
          ).format(appointment.appointmentDate.toLocal()),
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
