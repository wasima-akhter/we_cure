part of 'request_view_screen.dart';

class RequestViewScreenMobile extends StatefulWidget {
  const RequestViewScreenMobile({super.key});

  @override
  State<RequestViewScreenMobile> createState() =>
      _RequestViewScreenMobileState();
}

class _RequestViewScreenMobileState extends State<RequestViewScreenMobile>
    with RouteAware {
  late DoctorHomeController controller;

  @override
  void initState() {
    super.initState();

    controller = Get.find<DoctorHomeController>();

    debugPrint("🟢 RequestViewScreenMobile initState");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    debugPrint("🟡 RequestViewScreenMobile didChangeDependencies");

    final route = ModalRoute.of(context);

    debugPrint("🟡 Current route: $route");

    if (route is PageRoute) {
      debugPrint("🟡 Subscribing RouteAware");

      appRouteObserver.subscribe(this, route);
    } else {
      debugPrint("🔴 Route is not PageRoute");
    }
  }

  @override
  void didPush() {
    debugPrint("🚀 RouteAware didPush fired");

    controller.fetchDashboard();
  }

  @override
  void didPopNext() {
    debugPrint("🔄 RouteAware didPopNext fired");

    debugPrint("🔄 Calling fetchDashboard after returning");

    controller.fetchDashboard();
  }

  @override
  void didPushNext() {
    debugPrint("➡️ RouteAware didPushNext fired (another screen opened)");
  }

  @override
  void didPop() {
    debugPrint("⬅️ RouteAware didPop fired");
  }

  @override
  void dispose() {
    debugPrint("🔴 RequestViewScreenMobile dispose");

    appRouteObserver.unsubscribe(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Appointment Request", isBack: false),
      body: SafeArea(
        child: AppRefreshIndicator(
          onRefresh: () async {
            controller.fetchDashboard();
          },
          child: Obx(() {
            final appointments =
                controller.dashboardModel.value?.data.upcomingAppointments ??
                [];

            if (appointments.isEmpty) {
              return ListView(
                physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                children: [
                  30.verticalSpace,
                  Center(
                    child: TextWidget(
                      'No appointment requests found',
                      color: CustomColors.grayShade,
                      fontSize: Dimensions.titleSmall,
                    ),
                  ),
                ],
              );
            }

            return ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.defaultHorizontalSize,
              ),
              itemCount: appointments.length,
              addRepaintBoundaries: true,
              cacheExtent: 500,
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: Dimensions.heightSize),
                  child: RequestCard(
                    name: appointment.patientName,
                    service: appointment.reasonTitle,
                    time: formatTimeRange(appointment.timeRange),
                    status: DateFormat(
                      "dd MMMM yyyy",
                    ).format(DateTime.parse(appointment.date)),
                    buttonTitle: 'View',
                    cardOnTap: () {
                      Get.toNamed(
                        Routes.appointmentDetailsScreen,
                        arguments: appointment.id,
                      );
                    },
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
