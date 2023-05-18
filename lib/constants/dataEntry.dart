import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app/constants/constantsText.dart';
import 'package:shop_app/constants/style.dart';

Padding fillField(
    IconData? icone, TextEditingController controller, TextInputType texttype) {
  return Padding(
    padding: EdgeInsets.only(left: 10.w, right: 10.w),
    child: TextFormField(
      keyboardType: texttype,
      controller: controller,
      style: title1,
      decoration: InputDecoration(
          fillColor: Colors.white.withOpacity(0.2),
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              width: 0.1,
            ),
          ),
          suffixIcon: Icon(
            icone,
            color: Colors.white,
            size: 25,
          ),
          enabledBorder: border,
          border: border),
    ),
  );
}

Padding fieldType(String text) {
  return Padding(
    padding: EdgeInsets.only(left: 20.w, bottom: 6.h),
    child: Container(
      alignment: Alignment.topLeft,
      child: Text(
        text + ":",
        style: title1,
      ),
    ),
  );
}

Padding email(TextEditingController control) {
  return Padding(
    padding: EdgeInsets.only(left: 10.w, right: 10.w),
    child: TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: control,
      style: title1,
      validator: (value) {
        if (value!.isEmpty) {
          return (Constants.provideemail);
        }
        if (!RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value)) {
          return (Constants.validemail);
        }
        return null;
      },
      onSaved: (value) {
        control.text = value!;
        // _userRepository.updateName(emailcontroller.text);
      },
      decoration: InputDecoration(
          fillColor: Colors.white.withOpacity(0.2),
          filled: true,
          suffixIconColor: Colors.white,
          focusedBorder: border,
          suffixIcon: Icon(
            Icons.mail_outline,
            color: Colors.white,
            size: 30,
          ),
          enabledBorder: border,
          border: border),
    ),
  );
}
