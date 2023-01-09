import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/utils/network_service.dart';
import '../models/http_exception.dart';
import '../providers/auth.dart';
import '../utils/theme.dart';

enum AuthMode { signup, login }

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(color: MyTheme.baseColor),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 94.0),
                      child: const Text(
                        'My \n Shop',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          // TO DO: make this color a bit dark
                          color: MyTheme.sec2Color,
                          fontSize: 50,
                          fontFamily: 'MultiDisplay',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: const AuthCard(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  bool _isLoading = false;
  final _passwordController = TextEditingController();
  String errorMessage = '';

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 500),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
        // reverseCurve: Curves.easeInCubic,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInCubic,
        // reverseCurve: Curves.easeInCubic,
      ),
    );

    // _heightAnimation.addListener(() => setState(() {}));
    super.initState();
  }

  void _showNetworkDialog() {
    showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              title: const Text(
                'Network Error',
                style: TextStyle(color: MyTheme.sec2Color),
              ),
              content:
                  const Text("Please check your connection and try again."),
              actions: [
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Okay',
                      style: TextStyle(color: MyTheme.sec2Color, fontSize: 16),
                    ),
                  ),
                )
              ],
            )));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.login) {
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email']!, _authData['password']!);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signup(_authData['email']!, _authData['password']!);
      }
    } on HttpException catch (error) {
      log(error.toString(), name: "Auth Error");
      errorMessage = 'Authentication failed';
      if (error.message.contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use';
      } else if (error.message.contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.message.contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak';
      } else if (error.message.contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email';
      } else if (error.message.contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password';
      }
    } catch (error) {
      log(error.toString(), name: "Auth Error");
      errorMessage = 'Could not authenticate you. Please try again later.';
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final statusCode = ModalRoute.of(context)!.settings.arguments as Auth;
    var networkStatus = Provider.of<NetworkStatus>(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInCubic,
      height: _authMode == AuthMode.signup ? 420 : 300,
      // height: _heightAnimation.value.height,
      constraints:
          BoxConstraints(minHeight: _authMode == AuthMode.signup ? 420 : 300),
      width: deviceSize.width * 0.75,
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                cursorColor: MyTheme.sec2Color,
                decoration: const InputDecoration(
                  labelText: 'E-Mail',
                  labelStyle: TextStyle(color: MyTheme.sec2Color),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: MyTheme.sec2Color),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Invalid email!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['email'] = value!;
                },
              ),
              TextFormField(
                cursorColor: MyTheme.sec2Color,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: MyTheme.sec2Color),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: MyTheme.sec2Color),
                  ),
                ),
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value!.isEmpty || value.length < 5) {
                    return 'Password is too short!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['password'] = value!;
                },
                textInputAction: _authMode == AuthMode.signup
                    ? TextInputAction.next
                    : TextInputAction.done,
              ),
              if (_authMode == AuthMode.signup)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                        enabled: _authMode == AuthMode.signup,
                        cursorColor: MyTheme.sec2Color,
                        decoration: const InputDecoration(
                          labelText: 'Confirm Password',
                          labelStyle: TextStyle(color: MyTheme.sec2Color),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: MyTheme.sec2Color),
                          ),
                        ),
                        obscureText: true,
                        validator: _authMode == AuthMode.signup
                            ? (value) {
                                if (value! != _passwordController.text) {
                                  return 'Passwords do not match!';
                                }
                                return null;
                              }
                            : null,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                  ),
                ),
              const SizedBox(
                height: 20,
              ),
              if (_isLoading)
                const CircularProgressIndicator(color: MyTheme.sec2Color)
              else
                ElevatedButton(
                  child:
                      Text(_authMode == AuthMode.login ? 'Login' : 'Sign up'),
                  onPressed: networkStatus == NetworkStatus.offline
                      ? _showNetworkDialog
                      : _submit,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 8.0,
                    ),
                    backgroundColor: MyTheme.sec2Color,
                  ),
                ),
              TextButton(
                child: Text(
                    '${_authMode == AuthMode.login ? 'Sign up' : 'Login'} instead'),
                onPressed: _switchAuthMode,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 4.0,
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  foregroundColor: MyTheme.sec2Color,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                errorMessage,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
