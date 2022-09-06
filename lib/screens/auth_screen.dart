import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/http_exception.dart';
import '../providers/auth.dart';

enum AuthMode { Signup, Login }

Color baseColor = const Color.fromARGB(255, 174, 253, 177);
Color secColor = const Color.fromARGB(255, 99, 255, 105);
Color sec2Color = const Color.fromARGB(255, 50, 128, 52);

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
            decoration: BoxDecoration(color: baseColor),
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
                      child: Text(
                        'My Shop',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          // TO DO: make this color a bit dark
                          color: sec2Color,
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

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  bool _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: ((ctx) => AlertDialog(
              title: const Text('An Error Occurred!'),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('Okay'))
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
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email']!, _authData['password']!);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signup(_authData['email']!, _authData['password']!);
      }
    } on HttpException catch (error) {
      String errorMessage = 'Authentication failed';
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
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final statusCode = ModalRoute.of(context)!.settings.arguments as Auth;
    return Container(
      height: _authMode == AuthMode.Signup ? 320 : 260,
      constraints:
          BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
      width: deviceSize.width * 0.75,
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                cursorColor: sec2Color,
                decoration: InputDecoration(
                  labelText: 'E-Mail',
                  labelStyle: TextStyle(color: sec2Color),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: sec2Color),
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
                cursorColor: sec2Color,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: sec2Color),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: sec2Color),
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
              ),
              if (_authMode == AuthMode.Signup)
                TextFormField(
                  enabled: _authMode == AuthMode.Signup,
                  cursorColor: sec2Color,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    labelStyle: TextStyle(color: sec2Color),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: sec2Color),
                    ),
                  ),
                  obscureText: true,
                  validator: _authMode == AuthMode.Signup
                      ? (value) {
                          if (value! != _passwordController.text) {
                            return 'Passwords do not match!';
                          }
                          return null;
                        }
                      : null,
                ),
              const SizedBox(
                height: 20,
              ),
              if (_isLoading)
                CircularProgressIndicator(color: sec2Color)
              else
                ElevatedButton(
                  child:
                      Text(_authMode == AuthMode.Login ? 'Login' : 'Sign up'),
                  onPressed: _submit,
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 8.0),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(sec2Color),
                  ),
                ),
              TextButton(
                child: Text(
                    '${_authMode == AuthMode.Login ? 'Sign up' : 'Login'} instead'),
                onPressed: _switchAuthMode,
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  foregroundColor: MaterialStateProperty.all<Color>(sec2Color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
