import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:untitled/presentation/screens/login_screen.dart';
import 'package:untitled/presentation/screens/registerForm/pages/page_1.dart';
import 'package:untitled/presentation/screens/registerForm/pages/page_3.dart';
import 'package:untitled/presentation/screens/registerForm/pages/page_4.dart';
import 'package:untitled/presentation/screens/registerForm/pages/page_5.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({Key? key}) : super(key: key);

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  int activeStep = 0; // Step index
  final PageController _pageController = PageController();

  void _nextStep() {
    if (activeStep < 5) {
      setState(() {
        activeStep++;
        debugPrint("Active step changed to: $activeStep");
      });
      _pageController.animateToPage(activeStep,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _prevStep() {
    if (activeStep > 0) {
      setState(() {
        activeStep--;
        debugPrint("Active step changed to: $activeStep");
      });
      _pageController.animateToPage(activeStep,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Form'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              color: Colors.blueGrey[50], // Light background for stepper
              child: EasyStepper(
                activeStep: activeStep,
                stepShape: StepShape.rRectangle,
                stepBorderRadius: 15,
                padding: const EdgeInsets.all(15),
                activeStepBackgroundColor: Colors.blueAccent,
                activeStepTextColor: Colors.black,
                finishedStepBackgroundColor: Colors.green,
                finishedStepTextColor: Colors.black,
                unreachedStepBackgroundColor: Colors.grey[300],
                unreachedStepTextColor: Colors.black,
                steps: const [
                  EasyStep(
                    icon: Icon(Icons.person),
                    title: 'Personal Info',
                  ),
                  EasyStep(
                    icon: Icon(Icons.group),
                    title: 'Team Details',
                  ),
                  EasyStep(
                    icon: Icon(Icons.credit_card),
                    title: 'NRC Details',
                  ),
                  EasyStep(
                    icon: Icon(Icons.assignment),
                    title: 'Certification',
                  ),
                  EasyStep(
                    icon: Icon(Icons.school),
                    title: 'Courses',
                  ),
                  EasyStep(
                    icon: Icon(Icons.check_circle),
                    title: 'Confirm',
                  ),
                ],
                onStepReached: (index) {
                  setState(() {
                    activeStep = index;
                    debugPrint("Step reached: $index");
                  });
                  _pageController.jumpToPage(index);
                },
              )),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                PersonalInfoPage(),
                //buildPage2(context),
                Page3(),
                CertificationDetailsPage(),
                CoursePage(),
                _buildConfirmationPage(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: activeStep == 0 ? null : _prevStep,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Previous'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: activeStep == 5 ? _navigateToLogin : _nextStep,
                  icon:
                      Icon(activeStep == 5 ? Icons.done : Icons.arrow_forward),
                  label: Text(activeStep == 5 ? 'Finish' : 'Next'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    backgroundColor:
                        activeStep == 5 ? Colors.green : Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationPage() {
    const String registrationCode = '123456';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/mtf_logo_1.png',
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 20.0),
            const Text(
              'YOUR COACH LICENSE FORM IS SUCCESSFUL',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Your register code is: $registrationCode',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
