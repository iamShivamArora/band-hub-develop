import 'package:band_hub/widgets/app_text.dart';
import 'package:band_hub/widgets/custom_text_field.dart';
import 'package:band_hub/widgets/elevated_btn.dart';
import 'package:band_hub/widgets/helper_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HelperWidget.customAppBar(title: "Forgot password"),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/ic_red_lock.png',
                height: 100,
              ),
              const SizedBox(
                height: 60,
              ),
              Center(
                child: AppText(
                  textAlign: TextAlign.center,
                  text:
                      'Enter your E-mail and we will send\nyou a recovery code.',
                  fontWeight: FontWeight.w400,
                  textSize: 15,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const SimpleTf(
                hint: "Email",
                inputType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 80,
              ),
              ElevatedBtn(
                text: 'Send',
                onTap: () {
                  Get.back();
                },
              ),
              const SizedBox(
                height: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
