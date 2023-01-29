import 'package:flutter/material.dart';

Widget textField(
    {String? label,
      Icon? icon,
      TextInputType? type,
      var controller,
      String? Function(String?)? validator,
      Widget? suffixIcon,
      int? line, bool obsecure=false,
      bool read=false,
      double fontSize=14,
    }) {
  return Column(
    children: [
      TextFormField(
        obscureText: obsecure,
        controller: controller,
        keyboardType: type,
        validator: validator,
        maxLines: line,
        readOnly: read,
        style: TextStyle(
          fontSize: fontSize,
        ),
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          prefixIcon: icon,
          labelText: label,
          labelStyle: TextStyle(color: Colors.black38,fontSize: 13),
          contentPadding: EdgeInsets.only(top: 30),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.black12,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.green,
            ),
          ),
          fillColor: Colors.green,
        ),
      ),
      SizedBox(
        height: 10,
      ),
    ],
  );
}