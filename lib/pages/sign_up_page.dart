import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:skripsi/cubit/auth_cubit.dart';
import 'package:skripsi/shared/theme.dart';
import 'package:skripsi/widgets/custom_text_form_field.dart';
import 'package:skripsi/widgets/loading_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

bool isLoading = false;
int age = 17;
int height = 150;
int weight = 50;
String gender = 'Laki-laki';

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController =
        TextEditingController(text: 'julianreza@gmail.com');
    final TextEditingController passwordController =
        TextEditingController(text: 'julianreza');
    final TextEditingController nameController =
        TextEditingController(text: 'Julian Reza');

    Widget header() {
      return Container(
        padding: EdgeInsets.all(defaultMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daftar',
              style: blackTextStyle.copyWith(
                fontSize: 24,
                fontWeight: medium,
              ),
            ),
            Text(
              'Daftar untuk memantau tanda-tanda vital kesehatanmu.',
              style: greyTextStyle,
            ),
          ],
        ),
      );
    }

    Widget signInButton() {
      return BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/main', (route) => false);
          } else if (state is AuthFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: kRedColor,
                content: Text(
                  state.error,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return LoadingButton();
          }
          return GestureDetector(
            onTap: () {
              context.read<AuthCubit>().signUp(
                    email: emailController.text,
                    password: passwordController.text,
                    name: nameController.text,
                    gender: gender,
                    age: age,
                    height: height,
                    weight: weight,
                  );
            },
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: kPrimaryColor,
              ),
              width: double.infinity,
              child: Center(
                child: Text(
                  'Daftar',
                  style: blackTextStyle.copyWith(
                    color: kWhiteColor,
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    Widget form() {
      return Container(
        margin: EdgeInsets.only(
          right: defaultMargin,
          left: defaultMargin,
        ),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextFormField(
              title: "Nama",
              hintText: "Nama",
              controller: nameController,
            ),
            SizedBox(height: 20),
            CustomTextFormField(
              title: "Email",
              hintText: "Email",
              controller: emailController,
            ),
            SizedBox(height: 20),
            CustomTextFormField(
              title: "Password",
              hintText: "Password",
              controller: passwordController,
            ),
            SizedBox(height: 20),
            Text(
              'Jenis Kelamin',
              style: blackTextStyle,
            ),
            SizedBox(height: 6),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      gender = 'Laki-laki';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary:
                        (gender == 'Laki-laki') ? kPrimaryColor : kWhiteColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: (gender == 'Laki-laki')
                            ? kPrimaryColor
                            : kGreyColor,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Laki-laki',
                      style: (gender == 'Laki-laki')
                          ? whiteTextStyle
                          : blackTextStyle,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      gender = 'Perempuan';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary:
                        (gender == 'Perempuan') ? kPrimaryColor : kWhiteColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: (gender == 'Perempuan')
                            ? kPrimaryColor
                            : kGreyColor,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Perempuan',
                      style: (gender == 'Perempuan')
                          ? whiteTextStyle
                          : blackTextStyle,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Umur',
                  style: blackTextStyle,
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    NumberPicker(
                      itemCount: 1,
                      minValue: 0,
                      maxValue: 160,
                      itemWidth: 75,
                      value: age,
                      onChanged: (value) => {
                        setState(
                          () => {age = value},
                        ),
                      },
                      textStyle: blackTextStyle,
                      selectedTextStyle: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 16,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: kGreyColor,
                          width: 1,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'thn',
                      style: blackTextStyle.copyWith(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tinggi Badan',
                  style: blackTextStyle,
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    NumberPicker(
                      itemCount: 1,
                      minValue: 0,
                      maxValue: 220,
                      itemWidth: 75,
                      value: height,
                      onChanged: (value) => {
                        setState(
                          () => {height = value},
                        ),
                      },
                      textStyle: blackTextStyle,
                      selectedTextStyle: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 16,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: kGreyColor,
                          width: 1,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'cm',
                      style: blackTextStyle.copyWith(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Berat Badan',
                  style: blackTextStyle,
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    NumberPicker(
                      itemCount: 1,
                      minValue: 0,
                      maxValue: 200,
                      itemWidth: 75,
                      value: weight,
                      onChanged: (value) => {
                        setState(
                          () => {weight = value},
                        ),
                      },
                      textStyle: blackTextStyle,
                      selectedTextStyle: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 16,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: kGreyColor,
                          width: 1,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'kg',
                      style: blackTextStyle.copyWith(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            isLoading ? LoadingButton() : signInButton(),
          ],
        ),
      );
    }

    Widget signUp() {
      return Container(
        margin: EdgeInsets.all(defaultMargin),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sudah punya akun?',
                style: greyTextStyle,
              ),
              Text(' '),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/sign-in');
                },
                child: Text(
                  'Masuk',
                  style: primaryTextStyle,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: ListView(
        children: [
          header(),
          form(),
          signUp(),
        ],
      ),
    );
  }
}
