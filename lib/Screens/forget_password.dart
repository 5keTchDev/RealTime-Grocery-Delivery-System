
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import '../Constants/colors.dart';
import '../services/global_method.dart';
import '../widgets/appbarCustom.dart';

class ForgetPassword extends StatefulWidget {
  static const routeName = '/ForgetPassword';

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  String _emailAddress = '';
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalMethod _globalMethods = GlobalMethod();
  bool _isLoading = false;
  void _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();
      try {
        await _auth
            .sendPasswordResetEmail(email: _emailAddress.trim().toLowerCase())
            .then((value) async {
          return await _globalMethods.authSuccessHandle(
            title: 'Email Sent!',
            subtitle:
                'A link to reset password has been sent successfully to email $_emailAddress .'
                'Check your gmail now.',
            context: context,
          );
        });

        Navigator.canPop(context) ? Navigator.pop(context) : null;
      } catch (error) {
        _globalMethods.authErrorHandle(error.toString(), context);

        // print('error occured ${error.message}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBarCustom(
            title: 'Forgot Password',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              RichText(
                text: TextSpan(
                    text: 'Enter your Email',
                    style: TextStyle(
                      fontSize: 14,
                      color: ColorsConsts.AppMainColor,
                      fontWeight: FontWeight.w500,
                    ),
                    children: const [
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ]),
              ),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  style: TextStyle(
                      color: ColorsConsts.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 18),
                  key: const ValueKey('email'),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email address!';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(color: ColorsConsts.AppMainColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorsConsts.AppMainColor,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: ColorsConsts.AppMainColor, width: 1.0),
                    ),
                    filled: true,
                    hintText: 'email address',
                    hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  onSaved: (value) {
                    _emailAddress = value!;
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              _isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.green,
                    )
                  : ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            ColorsConsts.AppMainColor,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side:
                                  BorderSide(color: ColorsConsts.AppMainColor),
                            ),
                          )),
                      onPressed: _submitForm,
                      child: const Text(
                        'Reset',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 17),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
