import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../widgets/widgets.dart';

class AdminSupportScreen extends StatefulWidget {
  const AdminSupportScreen({super.key});

  @override
  State<AdminSupportScreen> createState() => _AdminSupportScreenState();
}

class _AdminSupportScreenState extends State<AdminSupportScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(title: Text('Admin Support'),),
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: Column(
            spacing: 10.h,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 14.h),
              CustomText(
                text: "If you're facing any issues or have questions, feel free to send a message to our support Us.",
                fontSize: 12.sp,
              ),
              SizedBox(height: 14.h),
              CustomTextField(
                labelText: 'Name*',
                controller: _nameController,
                hintText: "Write your name here",
              ),
              CustomTextField(
                labelText: 'Email*',
                controller: _emailController,
                hintText: "Write your email here",
                keyboardType: TextInputType.emailAddress,
                isEmail: true,
              ),
              CustomTextField(
                maxLines: 8,
                labelText: 'Message*',
                controller: _messageController,
                hintText: "Type your message",
              ),
              SizedBox(height: 24.h),
              CustomButton(
                label: "Submit",
                onPressed: _onSingUp,
              ),
              SizedBox(height: 18.h),
            ],
          ),
        ),
      ),
    );
  }

  void _onSingUp() {
    if (!_globalKey.currentState!.validate()) return;
    showToast('summited');
    Get.back();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}
