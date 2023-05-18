import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/constants/constantsText.dart';
import 'package:shop_app/constants/dataEntry.dart';
import 'package:shop_app/constants/style.dart';
import 'package:shop_app/models/exception.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/login.dart';
import 'package:shop_app/screens/products_screen.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController confirmpasswordcontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  bool seeText1 = true;
  bool seeText2 = true;
  bool error = false;
  String text = "text";
  void _showerror(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Error"),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("OKAY"))
              ],
            ));
  }

  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _isLoading = false;
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false)
          .signUp(emailcontroller.text, passwordcontroller.text);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ProductsScreen()));
    } on HttpException catch (e) {
      var err = 'authentication failed';
      if (e.toString().contains('EMAIL_EXIST')) {
        err = 'this email exists';
      } else if (e.toString().contains('INVALID_EMAIL')) {
        err = 'Not valid email';
      } else if (e.toString().contains('WEAK_PASSWORD')) {
        err = 'password is weak';
      } else if (e.toString().contains('EMAIL_NOT_FOUND')) {
        err = 'this email not found';
      } else if (e.toString().contains('INVALID_PASSWORD')) {
        err = 'Wrong password';
      }
      _showerror(err);
    } catch (e) {
      var err = 'authentication failed';
      _showerror(err);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 46.h,
              ),
              Center(
                  child: Text(
                Constants.startjourney,
                textAlign: TextAlign.center,
                style: style,
              )),
              SizedBox(
                height: 30.h,
              ),
              fieldType(Constants.name),
              fillField(Icons.person, namecontroller, TextInputType.name),
              SizedBox(
                height: 10.h,
              ),
              fieldType(Constants.phone),
              fillField(Icons.phone, phonecontroller, TextInputType.phone),
              SizedBox(
                height: 10.h,
              ),
              fieldType(Constants.email),
              fillField(
                  Icons.mail, emailcontroller, TextInputType.emailAddress),
              SizedBox(
                height: 10.h,
              ),
              fieldType(Constants.password),
              password(),
              SizedBox(
                height: 10.h,
              ),
              fieldType(Constants.confirmpassword),
              confirmpassword(),
              SizedBox(
                height: 15.h,
              ),
              Center(
                  // ignore: deprecated_member_use
                  child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  padding: MaterialStateProperty.all(
                    EdgeInsets.only(
                        top: 8.h, left: 25.h, bottom: 8.h, right: 25.h),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    Colors.white,
                  ),
                ),
                onPressed: () async {
                  if (passwordcontroller.text ==
                      confirmpasswordcontroller.text) {
                    _submit();
                  } else {
                    error = true;
                    text = Constants.passwordsSame;
                  }
                },
                child: Text(
                  Constants.signUp,
                  style: TextStyle(fontSize: 20.sp, color: primary),
                ),
              )),
              SizedBox(
                height: 5.h,
              ),
              error
                  ? Container(
                      child: Text(
                        text,
                        style: TextStyle(color: Colors.white, fontSize: 16.sp),
                      ),
                    )
                  : Container(),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Constants.alreadyhaveAccount,
                      style: title1,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                      child: Text(
                        Constants.login,
                        style: title2,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding password() {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: passwordcontroller,
        obscureText: seeText1,
        style: title1,
        decoration: InputDecoration(
          fillColor: Colors.white.withOpacity(0.2),
          filled: true,
          focusedBorder: border,
          suffixIcon: seeText1
              ? IconButton(
                  onPressed: () {
                    seeText1 = false;
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.visibility_off,
                    color: Colors.white,
                    size: 25,
                  ),
                  // color: Theme.of(context).primaryColor,
                )
              : IconButton(
                  onPressed: () {
                    seeText1 = true;
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.visibility,
                    color: Colors.white,
                    size: 25,
                  ),
                  // color: Theme.of(context).primaryColor,
                ),
          enabledBorder: border,
          border: border,
        ),
      ),
    );
  }

  Padding confirmpassword() {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: confirmpasswordcontroller,
        obscureText: seeText2,
        style: title1,
        decoration: InputDecoration(
            fillColor: Colors.white.withOpacity(0.2),
            filled: true,
            focusedBorder: border,
            suffixIcon: seeText2
                ? IconButton(
                    onPressed: () {
                      seeText2 = false;
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.visibility_off,
                      color: Colors.white,
                      size: 25,
                    ),
                    // color: Theme.of(context).primaryColor,
                  )
                : IconButton(
                    onPressed: () {
                      seeText2 = true;
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.visibility,
                      color: Colors.white,
                      size: 25,
                    ),
                    // color: Theme.of(context).primaryColor,
                  ),
            enabledBorder: border,
            border: border),
      ),
    );
  }
}
