import 'package:auth__app/core/localization.dart';
import 'package:auth__app/view_model/services/splash_services.dart';
import 'package:flutter/material.dart';
import 'package:auth__app/res/const/app_colors.dart'; // Adjust as per your app's color settings
import 'package:auth__app/views/auth_view/login_view.dart'; // The next screen after splash

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    SplashServices.splashIsLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor, // Assuming primaryColor exists in AppColor
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock,size: 80,color: AppColor.whiteColor,),
            // Image.asset(
            //   'assets/images/logo.png', // Add your logo in assets
            //   height: 150, // Adjust size as needed
            // ),
            const SizedBox(height: 20),
            Text(
             LocalizationService.translate('welcome'), // Customize this text as needed
              style:  TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColor.whiteColor, // White text color for contrast
              ),
            ),
            const SizedBox(height: 10),
            // Optional subtitle
            Text(
              'Loading...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColor.darkGrey, // Assuming darkGrey exists in AppColor
              ),
            ),
          ],
        ),
      ),
    );
  }
}
