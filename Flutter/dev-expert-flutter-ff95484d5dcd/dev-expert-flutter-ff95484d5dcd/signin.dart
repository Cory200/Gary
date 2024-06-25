import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planishor/login_signup/forgetpassword.dart';
import 'package:planishor/widgets/spinner.dart';
import 'package:provider/provider.dart';
import 'package:planishor/bottomnavigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:planishor/login_signup/signup.dart';
import 'package:planishor/models/authentication.dart';

import 'package:planishor/library/globals.dart' as globals;

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool valuefirst = false;
  /////////////////////////////////Sign In functionality/////////////////////////////////////////////
  /////////////////////////////////Sign In functionality/////////////////////////////////////////////
  final GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, String> _authData = {'email': '', 'password': ''};
  String activeUserEmailId = '';

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occured'),
        content: Text(msg),
        actions: <Widget>[
          // ignore: deprecated_member_use
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    bool flag = false;
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    try {
      await Provider.of<Authentication>(context, listen: false)
          .logIn(_authData['email'], _authData['password']);
      globals.activeUserEmail = _authData['email'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs?.setBool("isLoggedIn", true);
      prefs.setString('activeUserEmailId', _authData['email']);
      await FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if (element.data()['user'] == _authData['email'] &&
              element.data()['admin'] == true) {
            flag = true;
          } else {}
        });
      }).then((value) {
        if (flag == true) {
          globals.activeAdmin = true;
        } else {
          globals.activeAdmin = false;
        }
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Spinner({
            Future.delayed(
              const Duration(milliseconds: 1000),
              () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavigation(0),
                  ),
                );
              },
            ),
          }),
        ),
      );
    } catch (error) {
      var errorMessage = 'Authentication Failed. Please try again later.';
      _showErrorDialog(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        /////////////////////////////////AppBar/////////////////////////////////////////////
        /////////////////////////////////AppBar/////////////////////////////////////////////
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('Sign In'),
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(30, 60, 30, 0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                /////////////////////////////////Welcome text/////////////////////////////////////////////
                /////////////////////////////////Welcome text/////////////////////////////////////////////
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Welcome,',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.black,
                    ),
                  ),
                ),

                /////////////////////////////////Sign in - sign up/////////////////////////////////////////////
                /////////////////////////////////Sign in - sign up/////////////////////////////////////////////
                SizedBox(height: 10),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Spinner({
                              Future.delayed(
                                const Duration(milliseconds: 1000),
                                () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignUp(),
                                    ),
                                  );
                                },
                              ),
                            }),
                          ),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Text('|'),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),

                /////////////////////////////////Email & Passwords/////////////////////////////////////////////
                /////////////////////////////////Email & Passwords/////////////////////////////////////////////
                SizedBox(height: 20),
                TextFormField(
                  //Email
                  autofocus: true,
                  cursorColor: Colors.green,
                  cursorHeight: 30,
                  decoration: InputDecoration(
                    labelText: 'EMAIL',
                    labelStyle: TextStyle(color: Colors.green),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'invalid email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                SizedBox(height: 50),
                TextFormField(
                  //Password
                  autofocus: true,
                  cursorColor: Colors.green,
                  cursorHeight: 30,
                  decoration: InputDecoration(
                    labelText: 'PASSWORD',
                    labelStyle: TextStyle(color: Colors.green),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty || value.length <= 5) {
                      return 'invalid password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                SizedBox(height: 50),

                /////////////////////////////////Submit//////////////////////////////////
                /////////////////////////////////Submit//////////////////////////////////
                // SizedBox(height: 5),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: <Widget>[
                //     Checkbox(
                //       checkColor: Colors.white,
                //       activeColor: Colors.green,
                //       value: this.valuefirst,
                //       onChanged: (bool value) {
                //         setState(() {
                //           this.valuefirst = value;
                //         });
                //       },
                //     ),
                //     Text(
                //       'Remember My Password',
                //       style: TextStyle(fontSize: 17.0),
                //     ),
                //   ],
                // ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 0),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    border: Border.all(
                      color: Colors.green,
                      width: 0.8,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    onPressed: () {
                      _submit();
                    },
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                /////////////////////////////////Forget Password//////////////////////////////////
                /////////////////////////////////Forget Password//////////////////////////////////
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Spinner({
                            Future.delayed(
                              const Duration(milliseconds: 1000),
                              () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForgetPassword(),
                                  ),
                                );
                              },
                            ),
                          }),
                        ),
                      );
                    },
                    child: Text(
                      'Forget Password?',
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),

                /////////////////////////////////Sign Up//////////////////////////////////
                /////////////////////////////////Sign Up//////////////////////////////////
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.grey,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Spinner({
                              Future.delayed(
                                const Duration(milliseconds: 1000),
                                () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignUp(),
                                    ),
                                  );
                                },
                              ),
                            }),
                          ),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
