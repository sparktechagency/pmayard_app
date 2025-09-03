import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';


class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(title:Text("About Us")),
      body:  ListView(
        padding: EdgeInsets.all(sizeH * .02),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: sizeH * .01),
          HtmlWidget('Welcome to Shower Share! \nThese Terms and Conditions ("Terms") govern your use of the Shower Share mobile application ("App") and the services offered through it. By accessing or using the App, you agree to be bound by these Terms. If you do not agree to these Terms, do not use the App. 1. Acceptance of Terms By downloading, installing, or using the Shower Share App, you agree to these Terms, including any future modifications. We reserve the right to update or change these Terms at any time, and your continued use of the App after any changes will constitute your acceptance of the updated Terms. 2. Description of the App Shower Share is a mobile application that allows users to [describe the main function of the app, e.g., "share shower spaces, book available showers, track shower time, etc."]. The app may also provide additional features and services, which may be subject to additional terms and conditions. 3. User Eligibility To use the App, you must be at least [insert age requirement] years old or the legal age of majority in your jurisdiction. By using the App, you represent and warrant that you meet these requirements. 4. User Accounts Account Creation: To access certain features, you may be required to create an account. When you create an account, you agree to provide accurate, current, and complete information and to update it as necessary. Account Security: You are responsible for maintaining the confidentiality of your account login credentials and for all activities that occur under your account. Notify us immediately if you suspect any unauthorized use of your account.',
            textStyle: TextStyle(fontSize: 12.sp,color: Colors.white),
          ),
        ],
      ),
    );
  }
}
