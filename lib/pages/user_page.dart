import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skripsi/cubit/auth_cubit.dart';
import 'package:skripsi/cubit/page_cubit.dart';
import 'package:skripsi/shared/theme.dart';
import 'package:skripsi/widgets/loading_button.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    Widget header() {
      return BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthSuccess) {
            var username = state.user.email.split('@');
            return Container(
              margin: EdgeInsets.symmetric(
                horizontal: defaultMargin,
                vertical: defaultMargin,
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      image: DecorationImage(
                        image: AssetImage(
                          state.user.gender == 'Laki-laki'
                              ? 'assets/Unsplash-Avatars_0005s_0007_emile-guillemot-vfijBqzoQE0-unsplash.png'
                              : 'assets/image_profile.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(80),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.user.name,
                        style: blackTextStyle.copyWith(
                          fontSize: 30,
                        ),
                      ),
                      Text(
                        '@${username[0]}',
                        style: greyTextStyle.copyWith(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return SizedBox();
          }
        },
      );
    }

    Widget userProfileItem(String label, String value) {
      return Container(
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: blackTextStyle.copyWith(
                fontSize: 16,
              ),
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) => widget,
                );
              },
              child: Row(
                children: [
                  Text(
                    value,
                    style: greyTextStyle.copyWith(
                      fontSize: 15,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: kGreyColor.withOpacity(0.7),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget profile() {
      return BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthSuccess) {
            return Container(
              margin: EdgeInsets.only(
                right: defaultMargin,
                left: defaultMargin,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tentang',
                    style: blackTextStyle.copyWith(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: kWhiteColor,
                    ),
                    child: Column(
                      children: [
                        userProfileItem(
                          'Jenis Kelamin',
                          state.user.gender,
                          // GenderBottomSheet(),
                        ),
                        userProfileItem(
                          'Umur',
                          '${state.user.age}',
                          // AgeBottomSheet(),
                        ),
                        userProfileItem(
                          'Tinggi Badan',
                          '${state.user.height}cm',
                          // HeightBottomSheet(),
                        ),
                        userProfileItem(
                          'Berat Badan',
                          '${state.user.weight}kg',
                          // WeightBottomSheet(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return SizedBox();
          }
        },
      );
    }

    Widget logout() {
      return BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: kRedColor,
                content: Text(state.error),
              ),
            );
          } else if (state is AuthInitial) {
            context.read<PageCubit>().setPage(0);
            Navigator.pushNamedAndRemoveUntil(
                context, '/sign-in', (route) => false);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return LoadingButton();
          }
          return GestureDetector(
            onTap: () {
              context.read<AuthCubit>().signOut();
            },
            child: Container(
              margin: EdgeInsets.all(defaultMargin),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: kPrimaryColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icon_logout.png',
                    width: 18,
                    height: 18,
                    color: kWhiteColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Sign Out',
                    style: whiteTextStyle.copyWith(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return ListView(
      children: [
        header(),
        profile(),
        logout(),
      ],
    );
  }
}
