import 'package:flutter/material.dart';
import 'package:planishor/login_signup/otpverification.dart';
import 'package:planishor/login_signup/signin.dart';
import 'package:email_auth/email_auth.dart';
import 'package:planishor/widgets/spinner.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String name = '';
  final GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, String> _authData = {
    'name': '',
    'email': '',
    'password': '',
    'confirm': ''
  };

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    EmailAuth.sessionName = "Planishor";
    var res = await EmailAuth.sendOtp(receiverMail: _authData['email']);

    if (res) {
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
                    builder: (context) => OtpVerification(_authData),
                  ),
                );
              },
            ),
          }),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // resizeToAvoidBottomInset: false, // this avoids the overflow error
        /////////////////////////////////AppBar/////////////////////////////////////////////
        /////////////////////////////////AppBar/////////////////////////////////////////////
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('Sign Up'),
        ),

        body: Container(
          padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                /////////////////////////////////Welcome text/////////////////////////////////////////////
                /////////////////////////////////Welcome text/////////////////////////////////////////////
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Hello,',
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
                      onTap: () {},
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Text('|'),
                    SizedBox(width: 5),
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
                                      builder: (context) => SignIn(),
                                    ),
                                  );
                                },
                              ),
                            }),
                          ),
                        );
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                /////////////////////////////////Input Fields/////////////////////////////////////////////
                /////////////////////////////////Input Fields/////////////////////////////////////////////
                SizedBox(height: 20),

                TextFormField(
                  //Name
                  autofocus: true,
                  cursorColor: Colors.green,
                  cursorHeight: 30,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.grey,
                    ),
                    labelText: 'Enter Name',
                    labelStyle: TextStyle(color: Colors.green),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'invalid email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['name'] = value;
                  },
                ),

                SizedBox(height: 10),

                TextFormField(
                  //Email
                  autofocus: true,
                  cursorColor: Colors.green,
                  cursorHeight: 30,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.grey,
                    ),
                    labelText: 'Enter Email',
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

                SizedBox(height: 10),

                TextFormField(
                  //Password
                  autofocus: true,
                  cursorColor: Colors.green,
                  cursorHeight: 30,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.grey,
                    ),
                    labelText: 'Enter Password',
                    labelStyle: TextStyle(color: Colors.green),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  obscureText: true,
                  // controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length <= 5) {
                      return 'password should be at least of 6 digits';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _authData['password'] = value;
                  },
                ),

                SizedBox(height: 10),

                TextFormField(
                  //Confirm Password
                  autofocus: true,
                  cursorColor: Colors.green,
                  cursorHeight: 30,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.confirmation_num_sharp,
                      color: Colors.grey,
                    ),
                    labelText: 'Confirm Password',
                    labelStyle: TextStyle(color: Colors.green),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value != _authData['password']) {
                      return "confirm password didn't match";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['confirm'] = value;
                  },
                ),

                SizedBox(height: 50),

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
                      'Verify Email Id',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
