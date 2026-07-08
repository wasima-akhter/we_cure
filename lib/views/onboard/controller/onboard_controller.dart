import 'package:glady/core/utils/app_storage.dart';
import 'package:glady/core/utils/basic_import.dart';

class OnboardController extends GetxController {
  final PageController pageController = PageController();

  final RxInt currentPage = 0.obs;

  final List<OnboardingItem> onboardingItems = [
    OnboardingItem(
      imagePath: Assets.dummy.amico,
      title: 'Consult Doctors from Home',
      description:
          'Book instant video consultations with qualified doctors anytime, anywhere—no waiting in clinics.',
    ),
    OnboardingItem(
      imagePath: Assets.dummy.pana,
      title: 'Find the Right Specialist',
      description:
          'Choose from a wide range of verified doctors across specialties and schedule a video call in minutes.',
    ),
    OnboardingItem(
      imagePath: Assets.dummy.ddd,
      title: 'Secure & Private Consultations',
      description:
          'Enjoy confidential video calls, get prescriptions online, and manage your health with complete privacy. Get started now!',
    ),
  ];

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value < onboardingItems.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      completeOnboarding();
    }
  }

  // Skip to last page
  void skipToEnd() {
    pageController.animateToPage(
      onboardingItems.length - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  // Complete onboarding and navigate to home/login
  Future<void> completeOnboarding() async {
    // Save onboarding completion status
    // Example: Get.find<StorageService>().setOnboardingCompleted(true);

    // Navigate to next screen (login or home)
    await AppStorage.save(onboardSave: true);
    Get.offAllNamed(Routes.loginScreen); // Update with your route
  }
}

// Onboarding Item Model
class OnboardingItem {
  final String imagePath;
  final String title;
  final String description;

  OnboardingItem({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}
