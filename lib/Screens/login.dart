import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../Constants/colors.dart';
import '../services/global_method.dart';
import 'forget_password.dart';
import '../Screens/sign_up.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/LoginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _passwordFocusNode = FocusNode();
  bool _obscureText = true;
  String _emailAddress = '';
  String _password = '';
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalMethod _globalMethods = GlobalMethod();
  bool _isLoading = false;
  bool isChecked = false;

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  // Future<void> _googleSignIn() async {
  //   // Initialize Firebase
  //   await Firebase.initializeApp();
  //   User? user;
  //   final fcmToken = await FirebaseMessaging.instance.getToken();
  //
  //   // The `GoogleAuthProvider` can only be used while running on the web
  //
  //   if (kIsWeb) {
  //     var date = DateTime.now().toString();
  //     var dateparse = DateTime.parse(date);
  //     var formattedDate =
  //         "${dateparse.day}-${dateparse.month}-${dateparse.year}";
  //     GoogleAuthProvider authProvider = GoogleAuthProvider();
  //
  //     try {
  //       final UserCredential userCredential =
  //           await _auth.signInWithPopup(authProvider);
  //
  //       user = userCredential.user;
  //
  //       final _uid = user?.uid;
  //       // user!.updateProfile(photoURL: url, displayName: _fullName);
  //       // user.reload();
  //       await FirebaseFirestore.instance.collection('users').doc(_uid).set({
  //         'id': _uid,
  //         'name': user!.displayName,
  //         'email': user.email,
  //         'joinedAt': formattedDate,
  //         'createdAt': Timestamp.now(),
  //         'status': 'Unblocked',
  //         'token': fcmToken
  //       });
  //     } catch (e) {
  //       if (kDebugMode) {
  //         print(e);
  //       }
  //     }
  //   } else {
  //     signInWithGoogle();
  //   }
  // }

  void signInWithGoogle() async {
    var date = DateTime.now().toString();
    final fcmToken = await FirebaseMessaging.instance.getToken(
        vapidKey:
            "BGplB3TIm1kE1-qczahHlEa4Cn0Qa4iIjuZw1693FbHtGiy1xlsTZQKC2L5lg6UD8w3fRtNwW68UWCV3_igagKc");
    var dateparse = DateTime.parse(date);
    var formattedDate = "${dateparse.day}-${dateparse.month}-${dateparse.year}";

    try {
      context.loaderOverlay.show();

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);

      final User? user = _auth.currentUser;
      final _uid = user?.uid;
      // user!.updateProfile(photoURL: url, displayName: _fullName);
      // user.reload();
      await FirebaseFirestore.instance.collection('users').doc(_uid).set({
        'id': _uid,
        'name': googleUser!.displayName,
        'email': googleUser.email,
        'joinedAt': formattedDate,
        'createdAt': Timestamp.now(),
        'status': 'Unblocked',
        'token': fcmToken
      });
    } catch (e) {
      print(e);
    } finally {
      if (mounted) {
        context.loaderOverlay.hide();
        Navigator.canPop(context) ? Navigator.pop(context) : null;
      }
    }
  }

  void _submitForm() async {
    final fcmToken = await FirebaseMessaging.instance.getToken(
        vapidKey:
            "BGplB3TIm1kE1-qczahHlEa4Cn0Qa4iIjuZw1693FbHtGiy1xlsTZQKC2L5lg6UD8w3fRtNwW68UWCV3_igagKc");
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();
      try {
        await _auth
            .signInWithEmailAndPassword(
                email: _emailAddress.toLowerCase().trim(),
                password: _password.trim())
            .then((value) async {
          String uid = FirebaseAuth.instance.currentUser!.uid;
          final docSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .get();
          String? token = await docSnapshot.get('token');
          if (token != null) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .update({
              'token': fcmToken,
            }).then((value) {
              print('token updated $fcmToken');
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              }
            }).catchError((error) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            });
          }
        });
      } catch (error) {
        if (mounted) {
          _globalMethods.authErrorHandle(error.toString(), context);
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.grey;
      }
      return Colors.grey;
    }

    return Scaffold(
      body: LoaderOverlay(
        child: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          'images/sabji_taja_logo.png',
                          width: 120,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Sign in to your account',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        // const SizedBox(
                        //   height: 50,
                        // ),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                            text: 'Email',
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
                                      TextFormField(
                                        style: TextStyle(
                                            color: ColorsConsts.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18),
                                        cursorColor: ColorsConsts.black,
                                        key: const ValueKey('email'),
                                        validator: (value) {
                                          if (value!.isEmpty ||
                                              !value.contains('@')) {
                                            return 'Please enter a valid email address !';
                                          }

                                          return null;
                                        },
                                        textInputAction: TextInputAction.next,
                                        onEditingComplete: () =>
                                            FocusScope.of(context).requestFocus(
                                                _passwordFocusNode),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8.0)),
                                            borderSide: BorderSide(
                                                color:
                                                    ColorsConsts.AppMainColor),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color:
                                                    ColorsConsts.AppMainColor,
                                                width: 1.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color:
                                                    ColorsConsts.AppMainColor,
                                                width: 1.0),
                                          ),
                                          filled: true,
                                          hintText: 'email address',
                                          hintStyle: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                        ),
                                        onSaved: (value) {
                                          _emailAddress = value!;
                                        },
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                            text: 'Password',
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
                                      TextFormField(
                                        style: TextStyle(
                                            color: ColorsConsts.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18),
                                        cursorColor: ColorsConsts.black,
                                        key: const ValueKey('Password'),
                                        validator: (value) {
                                          if (value!.isEmpty ||
                                              value.length < 7) {
                                            return 'Please enter a valid 8 digit Password !';
                                          }
                                          return null;
                                        },
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        focusNode: _passwordFocusNode,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8.0)),
                                            borderSide: BorderSide(
                                                color:
                                                    ColorsConsts.AppMainColor),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color:
                                                    ColorsConsts.AppMainColor,
                                                width: 1.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color:
                                                    ColorsConsts.AppMainColor,
                                                width: 1.0),
                                          ),
                                          filled: true,
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          hintText: 'password',
                                          hintStyle: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                          suffixIcon: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _obscureText = !_obscureText;
                                              });
                                            },
                                            child: _obscureText
                                                ? Icon(
                                                    Icons.visibility,
                                                    color: ColorsConsts
                                                        .AppMainColor,
                                                  )
                                                : Icon(
                                                    Icons.visibility_off,
                                                    color: ColorsConsts
                                                        .AppMainColor,
                                                  ),
                                          ),
                                        ),
                                        onSaved: (value) {
                                          _password = value!;
                                        },
                                        obscureText: _obscureText,
                                        onEditingComplete: _submitForm,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: Checkbox(
                                                fillColor: MaterialStateProperty
                                                    .resolveWith(getColor),
                                                checkColor: Colors.white,
                                                value: isChecked,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    isChecked = value!;
                                                  });
                                                }),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          const Text(
                                            'Keep me logged in',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(context,
                                                ForgetPassword.routeName);
                                          },
                                          child: const Text(
                                            'Forgot password?',
                                            style: TextStyle(
                                              color: Color(0xFF1DAB45),
                                            ),
                                          )),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: _isLoading
                                        ? const CircularProgressIndicator()
                                        : ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                  ColorsConsts.AppMainColor,
                                                ),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    side: BorderSide(
                                                        color: ColorsConsts
                                                            .AppMainColor),
                                                  ),
                                                )),
                                            onPressed: _submitForm,
                                            child: const Padding(
                                              padding: EdgeInsets.only(
                                                  top: 15,
                                                  bottom: 15,
                                                  left: 15,
                                                  right: 15),
                                              child: Text(
                                                'LOGIN',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 14),
                                              ),
                                            )),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),
                            ),
                            const Text(
                              'or continue with',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: signInWithGoogle,
                                  child: Material(
                                    borderRadius: BorderRadius.circular(8),
                                    elevation: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.transparent),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10,
                                            bottom: 10,
                                            left: 20,
                                            right: 20),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset(
                                              'images/google.png',
                                              height: 20,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            const Text(
                                              'Google',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: const Duration(
                                          milliseconds: 500,
                                        ),
                                        backgroundColor:
                                            ColorsConsts.AppMainColor,
                                        content: const Text(
                                          'Facebook Sign In Unavailable!',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Material(
                                    borderRadius: BorderRadius.circular(8),
                                    elevation: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.transparent),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10,
                                            bottom: 10,
                                            left: 20,
                                            right: 20),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset(
                                              'images/facebookicon.png',
                                              height: 20,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            const Text(
                                              'Facebook',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, SignUpScreen.routeName);
                              },
                              child: Align(
                                alignment: Alignment.center,
                                child: RichText(
                                  text: TextSpan(
                                      text: 'Don\'t have an account ?  ',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'Sign Up',
                                          style: TextStyle(
                                              color: ColorsConsts.AppMainColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ]),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            //  Padding(padding: EdgeInsets.only(bottom:MediaQuery.of(context).viewInsets.bottom ))
                            // SizedBox(
                            //   height: MediaQuery.of(context).viewInsets.bottom,
                            // )
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
