import 'package:flutter/material.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/constants/constantsText.dart';
import 'package:shop_app/constants/dataEntry.dart';
import 'package:shop_app/constants/style.dart';
import 'package:shop_app/models/exception.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/products_screen.dart';
import 'package:shop_app/screens/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

TextEditingController passwordcontroller = TextEditingController();
TextEditingController emailcontroller = TextEditingController();
// AsyncSnapshot<QuerySnapshot>? snapshot;
bool seeText = true;

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false)
          .login(emailcontroller.text, passwordcontroller.text);
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

  final GlobalKey<FormState> _formKey = GlobalKey();
  // UserRepository _userRepository = UserRepository.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: primary),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 40.h,
                ),
                Center(
                  child: Image(image: AssetImage('assets/images/logo.png')),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  Constants.welcome,
                  style: style,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Center(
                    child: Text(
                  Constants.newProducts,
                  textAlign: TextAlign.center,
                  style: style,
                )),
                SizedBox(
                  height: 30.h,
                ),
                fieldType(Constants.email),
                email(emailcontroller),
                SizedBox(
                  height: 20.h,
                ),
                fieldType(Constants.password),
                password(),
                SizedBox(
                  height: 20.h,
                ),
                Center(
                    // ignore: deprecated_member_use
                    child: ElevatedButton(
                      style: ButtonStyle(shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),),
                      padding: MaterialStateProperty.all(EdgeInsets.only(
                      top: 8.h, left: 35.h, bottom: 8.h, right: 35.h),),
                      backgroundColor: MaterialStateProperty.all(Colors.white,),
                      ),
                 
                  onPressed: _submit,
                  child: Text(
                    Constants.login,
                    style: TextStyle(fontSize: 20.sp, color: primary),
                  ),
                )),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Constants.noaccount,
                        style: title1,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUp()));
                        },
                        child: Text(
                          Constants.signUp,
                          style: title2,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
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
        obscureText: seeText,
        style: title1,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return (Constants.prvidepass);
          }
          if (!regex.hasMatch(value)) {
            return (Constants.validpassword);
          }
        },
        onSaved: (value) {
          passwordcontroller.text = value!;
        },
        decoration: InputDecoration(
            fillColor: Colors.white.withOpacity(0.2),
            filled: true,
            focusedBorder: border,
            suffixIcon: seeText
                ? IconButton(
                    onPressed: () {
                      seeText = false;
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.visibility_off,
                      color: Colors.white,
                      size: 30,
                    ),
                    // color: Theme.of(context).primaryColor,
                  )
                : IconButton(
                    onPressed: () {
                      seeText = true;
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.visibility,
                      color: Colors.white,
                      size: 30,
                    ),
                    // color: Theme.of(context).primaryColor,
                  ),
            enabledBorder: border,
            border: border),
      ),
    );
  }
}
