import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
// xiaoma imports
import 'package:xiaoma/auth/auth.dart';
import 'package:xiaoma/constants/constants.dart';
import 'package:xiaoma/dashboard/screens/dashboard_screen.dart';
import 'package:xiaoma/mixins/mixins.dart';
import 'package:xiaoma/themes/themes.dart';
import 'package:xiaoma/utils/utils.dart';
import 'package:xiaoma/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const routeName = "/login-screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with ValidationMixins {
  // stores
  final LoginScreenStore _loginScreenStore = locator<LoginScreenStore>();
  // keys
  final _formKey = GlobalKey<FormState>();
  // utils

  // controllers
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: XiamaColors.white,
      body: Container(
        padding: const EdgeInsets.only(
          left: XiamaConst.XIAMA_SCREEN_PADDING,
          right: XiamaConst.XIAMA_SCREEN_PADDING,
        ),
        constraints: BoxConstraints(
          minHeight: _size.height,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: _size.height * .1,
              ),
              Observer(
                builder: (context) {
                  return Text(
                    _loginScreenStore.phoneNumberIsValid
                        ? "Welcome back!"
                        : "Welcome",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              const SizedBox(
                height: XiamaConst.XIAMA_SIZEBOX_PADDING_XML,
              ),
              Center(
                child: Image.asset(
                  XiamaConst.AUTH_VALIDATE_IMAGE,
                ),
              ),
              const SizedBox(
                height: XiamaConst.XIAMA_SIZEBOX_PADDING_XML,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Phone Number",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: XiamaConst.XIAMA_SIZEBOX_PADDING_MD,
                    ),
                    CustomTextFormField(
                      hasPrefixIcon: true,
                      keyboardType: TextInputType.phone,
                      prefixIcon: const Icon(
                        CupertinoIcons.phone,
                        color: XiamaColors.grey3,
                      ),
                      hasPrefixText: true,
                      hintText: "0712345678",
                      onSaved: (newValue) {
                        if (newValue == null || newValue.isEmpty) {
                          return;
                        }
                        _loginScreenStore.phoneNumber = newValue.trim();
                      },
                      validator: validatePhoneNumber,
                    ),
                    const SizedBox(
                      height: XiamaConst.XIAMA_SIZEBOX_PADDING_XL,
                    ),
                    Observer(
                      builder: (_) {
                        return Visibility(
                          visible: _loginScreenStore.phoneNumberIsValid,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Password",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: XiamaConst.XIAMA_SIZEBOX_PADDING_MD,
                              ),
                              CustomTextFormField(
                                hasPrefixIcon: true,
                                showPassword: _loginScreenStore.obscureText,
                                prefixIcon: const Icon(
                                  CupertinoIcons.padlock,
                                  color: XiamaColors.grey3,
                                ),
                                hintText: "Minimum 8 characters",
                                suffixIcon: _loginScreenStore.obscureText
                                    ? IconButton(
                                        onPressed: () {
                                          _loginScreenStore
                                              .handleShowPassword();
                                        },
                                        icon: const Icon(
                                          CupertinoIcons.eye_slash,
                                          color: XiamaColors.grey3,
                                        ),
                                      )
                                    : IconButton(
                                        onPressed: () {
                                          _loginScreenStore
                                              .handleShowPassword();
                                        },
                                        icon: const Icon(
                                          CupertinoIcons.eye,
                                          color: XiamaColors.grey3,
                                        ),
                                      ),
                                onSaved: (newValue) {
                                  if (newValue == null || newValue.isEmpty) {
                                    return;
                                  }
                                  _loginScreenStore.password = newValue.trim();
                                },
                                validator: validatePassword,
                              ),
                              const SizedBox(
                                height: XiamaConst.XIAMA_SIZEBOX_PADDING_MD,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                        ForgotPasswordScreen.routeName);
                                  },
                                  child: const Text("Forgot Password ?"),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: _size.height * .08,
              ),
              Observer(
                builder: (_) {
                  return CustomElevatedButton(
                    onPressed: () async {
                      if (FocusScope.of(context).hasFocus) {
                        FocusScope.of(context).unfocus();
                      }
                      if (_formKey.currentState?.validate() == false) {
                        return;
                      }
                      _formKey.currentState?.save();

                      _loginScreenStore.handleIsAuthenticating(value: true);
                      XiamaLogger.debugPrint(
                          "isAuthentication ${_loginScreenStore.isAuthenticating}");

                      await Future.wait(
                        [
                          Future.delayed(
                            const Duration(seconds: 3),
                            () {
                              _loginScreenStore.handleIsAuthenticating(
                                  value: false);
                              XiamaLogger.debugPrint(
                                  "isAuthentication ${_loginScreenStore.isAuthenticating}");
                            },
                          ),
                        ],
                      );

                      if (_loginScreenStore.phoneNumber != "0717126871") {
                        if (!mounted) return;
                        Navigator.of(context)
                            .pushNamed(RegistrationScreen.routeName);
                        return;
                      }
                      _loginScreenStore.phoneNumberIsValid = true;

                      if (_loginScreenStore.password == null ||
                          _loginScreenStore.password?.isEmpty == true) {
                        return;
                      }

                      if (!mounted) return;

                      if (_loginScreenStore.password != "Solenum10#") {
                        CustomToast.showToast(
                          context: context,
                          message: "Wrong phone number or password",
                          success: false,
                        );
                        return;
                      }

                      Navigator.of(context)
                          .pushNamed(DashboardScreen.routeName);
                      CustomToast.showToast(
                        context: context,
                        message: "Logged in successfully",
                        success: true,
                      );
                      return;
                    },
                    child: _loginScreenStore.isAuthenticating
                        ? MiniWidgets.circularProgressIndicatorOnButton()
                        : const Text(
                            "Login",
                            style: TextStyle(
                              color: XiamaColors.black1,
                            ),
                          ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
