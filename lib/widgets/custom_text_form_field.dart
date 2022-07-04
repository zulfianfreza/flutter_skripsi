import 'package:flutter/material.dart';
import 'package:skripsi/shared/theme.dart';

class CustomTextFormField extends StatelessWidget {
  final String title;
  final String hintText;
  final bool obsecureText;
  final TextEditingController controller;

  const CustomTextFormField({
    required this.title,
    required this.hintText,
    this.obsecureText = false,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: blackTextStyle,
        ),
        SizedBox(height: 6),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: kGreyColor,
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: controller,
            cursorColor: kBlackColor,
            style: blackTextStyle.copyWith(
              fontSize: 14,
            ),
            decoration: InputDecoration.collapsed(
              hintText: hintText,
            ),
            obscureText: obsecureText ? true : false,
          ),
        ),
      ],
    );
  }
}
