import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/features/authentication/controllers/signupcontroller.dart';
import 'package:instagram_clone/features/authentication/presentation/screens/loginscreen.dart';
import 'package:instagram_clone/localizations/app_localizations.dart';
import 'package:instagram_clone/utils/constants/imagestrings.dart';
import 'package:instagram_clone/utils/constants/sizes.dart';
import 'package:instagram_clone/utils/helpers/helper_functions.dart';

import '../../../../utils/constants/colors.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});
  final SignUpController _signUpController = Get.put(SignUpController());
  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.defaultSpace),
          child: Container(
            height: AppHelperFunctions.screenHeight(context),
            child: Column(
              children: [
                isDark
                    ? Image.asset(AppImageStrings.whiteInstaLogo)
                    : Image.asset(AppImageStrings.darkInstaLogo),
                SizedBox(
                  height: AppSizes.defaultSpace,
                ),
                Form(
                    key: _signUpController.signupKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _signUpController.nameController,
                          decoration: InputDecoration(
                              prefixIcon: Icon(FontAwesomeIcons.user),
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              labelText: 'Full Name'),
                        ),
                        SizedBox(
                          height: AppSizes.spaceBtwInputFields,
                        ),
                        TextFormField(
                          controller: _signUpController.emailController,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              labelText: 'E-mail'),
                        ),
                        SizedBox(
                          height: AppSizes.spaceBtwInputFields,
                        ),
                        Obx(
                          () => TextFormField(
                            controller: _signUpController.passwordController,
                            onTap: () => _signUpController.tapped.value = true,
                            obscureText: _signUpController.showPassword.value,
                            decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                labelText: 'Password',
                                suffix: _signUpController.tapped.value
                                    ? _signUpController.showPassword.value
                                        ? SizedBox(
                                            height: 12,
                                            child: TextButton(
                                                onPressed: () {
                                                  _signUpController
                                                      .toggleShowHide();
                                                },
                                                child: Text(
                                                  'Show',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                )),
                                          )
                                        : SizedBox(
                                            height: 12,
                                            child: TextButton(
                                                onPressed: () {
                                                  _signUpController
                                                      .toggleShowHide();
                                                },
                                                child: Text(
                                                  'Hide',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                )),
                                          )
                                    : null),
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  height: AppSizes.defaultSpace,
                ),
                SizedBox(
                    width: double.maxFinite,
                    child: OutlinedButton(
                        onPressed: () async {
                          await _signUpController.signUpWithEmailPassword();
                        },
                        child: Text('Sign Up'))),
                SizedBox(height: AppSizes.spaceBtwItems),
                Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: Text(
                        'Already have an account?',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.grey),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: () => Get.to(Loginscreen()),
                        child: Text(
                          AppLocalizations.of(context).login,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.blue),
                        ),
                      ),
                    )
                  ],
                ),
                Spacer(),
              
              
              ],
            ),
          ),
        ),
      )),
    );
  }
}
