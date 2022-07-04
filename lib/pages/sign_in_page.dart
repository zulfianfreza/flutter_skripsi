import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skripsi/cubit/auth_cubit.dart';
import 'package:skripsi/shared/theme.dart';
import 'package:skripsi/widgets/custom_text_form_field.dart';
import 'package:skripsi/widgets/loading_button.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

bool isLoading = false;

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController =
        TextEditingController(text: 'julianreza@gmail.com');
    final TextEditingController passwordController =
        TextEditingController(text: 'julianreza');

    Widget header() {
      return Container(
        padding: EdgeInsets.all(defaultMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Masuk',
              style: blackTextStyle.copyWith(
                fontSize: 24,
                fontWeight: medium,
              ),
            ),
            Text(
              'Masuk untuk memantau tanda-tanda vital kesehatanmu.',
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
              context.read<AuthCubit>().signIn(
                    email: emailController.text,
                    password: passwordController.text,
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
                  'Masuk',
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
              title: "Email",
              hintText: "Email",
              controller: emailController,
            ),
            SizedBox(height: 20),
            CustomTextFormField(
              title: "Password",
              hintText: "Password",
              controller: passwordController,
              obsecureText: true,
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
                'Belum punya akun?',
                style: greyTextStyle,
              ),
              Text(' '),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/sign-up');
                },
                child: Text(
                  'Daftar',
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
