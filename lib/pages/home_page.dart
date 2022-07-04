import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/health.dart';
import 'package:skripsi/cubit/auth_cubit.dart';
import 'package:skripsi/cubit/blood_oxygen_cubit.dart';
import 'package:skripsi/cubit/heart_rate_cubit.dart';
import 'package:skripsi/services/label_category.dart';
import 'package:skripsi/shared/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final LabelCategory labelCategory = LabelCategory();

    Widget header() {
      return BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthSuccess) {
            return Container(
              margin: EdgeInsets.all(defaultMargin),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo,\n${state.user.name}',
                        style: blackTextStyle.copyWith(
                          fontSize: 30,
                        ),
                      ),
                      Text(
                        'Bagaimana kesehatanmu hari ini?',
                        style: greyTextStyle.copyWith(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.asset(
                      'assets/Unsplash-Avatars_0005s_0007_emile-guillemot-vfijBqzoQE0-unsplash.png',
                      width: 60,
                      height: 60,
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

    Widget content() {
      return Container(
        margin: EdgeInsets.only(
          left: defaultMargin,
          right: defaultMargin,
          bottom: defaultMargin,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<HeartRateCubit, HeartRateState>(
                  builder: (context, state) {
                    if (state is HeartRateSuccess) {
                      HealthDataPoint heartRateFirst = state.heartRate.first;
                      List<String> heartRateValueOnString =
                          heartRateFirst.value.toString().split('.');
                      int heartRateValue = int.parse(heartRateValueOnString[0]);

                      return Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: kWhiteColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset:
                                    Offset(3, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  color: kRedColor.withOpacity(0.1),
                                  child: Image.asset(
                                    'assets/heart_rate_icon.png',
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Denyut Jantung',
                                style: blackTextStyle.copyWith(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '$heartRateValue bpm',
                                style: blackTextStyle.copyWith(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
                SizedBox(width: 10),
                BlocBuilder<BloodOxygenCubit, BloodOxygenState>(
                  builder: (context, state) {
                    if (state is BloodOxygenSuccess) {
                      HealthDataPoint bloodOxygenFirst =
                          state.bloodOxygen.first;
                      List<String> bloodOxygenValueOnString =
                          bloodOxygenFirst.value.toString().split('.');
                      int bloodOxygenValue =
                          int.parse(bloodOxygenValueOnString[0]);

                      return Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: kWhiteColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset:
                                    Offset(3, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  color: kPrimaryColor.withOpacity(0.1),
                                  child: Image.asset(
                                    'assets/oxygen_icon.png',
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Saturasi Oksigen',
                                style: blackTextStyle.copyWith(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '$bloodOxygenValue%',
                                style: blackTextStyle.copyWith(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget announceItem(String title, String desc, String category,
        {String route = ''}) {
      return Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: category == "heartRate"
              ? kRedColor.withOpacity(0.95)
              : kPrimaryColor.withOpacity(0.95),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              category == 'heartRate'
                  ? 'assets/announcement-3856386-3212574.png'
                  : 'assets/heart-rate-monitor-4869735-4051724.png',
              height: 75,
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: whiteTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: semiBold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    desc,
                    style: whiteTextStyle.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      route != ''
                          ? GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, route);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: kWhiteColor,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Text(
                                  'Lihat',
                                  style: blackTextStyle.copyWith(
                                    fontSize: 16,
                                    fontWeight: semiBold,
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget announce() {
      return Container(
        margin: EdgeInsets.only(
          right: defaultMargin,
          left: defaultMargin,
          bottom: defaultMargin,
        ),
        child: Column(
          children: [
            BlocBuilder<HeartRateCubit, HeartRateState>(
              builder: (context, state) {
                if (state is HeartRateSuccess) {
                  HealthDataPoint heartRateFirst = state.heartRate.first;
                  List<String> heartRateValueOnString =
                      heartRateFirst.value.toString().split('.');
                  int heartRateValue = int.parse(heartRateValueOnString[0]);
                  String heartRateCategory =
                      labelCategory.setLabel(heartRateValue, 'heartrate', 17);
                  return Column(
                    children: [
                      heartRateCategory == "rendah"
                          ? announceItem(
                              'Denyut Jantung Rendah',
                              'Denyut jantung kamu ada dibawah nilai normal nih, yuk baca informasi berikut sebagai penanganan pertama pada kondisi jantungmu.',
                              'heartRate',
                              route: '/low-heart-rate',
                            )
                          : (heartRateCategory == 'tinggi'
                              ? announceItem(
                                  'Denyut Jantung Tinggi',
                                  'Denyut jantung kamu tinggi nih, yuk baca informasi beikut sebagai penanganan pertama pada kondisi jantungmu.',
                                  'heartRate',
                                  route: '/high-heart-rate',
                                )
                              : announceItem(
                                  'Denyut Jantung Normal',
                                  'Denyut Jantung kamu normal nih.',
                                  'heartRate',
                                )),
                    ],
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
            SizedBox(height: 10),
            BlocBuilder<BloodOxygenCubit, BloodOxygenState>(
              builder: (context, state) {
                if (state is BloodOxygenSuccess) {
                  HealthDataPoint bloodOxygenFirst = state.bloodOxygen.first;
                  List<String> bloodOxygenValueOnString =
                      bloodOxygenFirst.value.toString().split('.');
                  int bloodOxygenValue = int.parse(bloodOxygenValueOnString[0]);
                  String bloodOxygenCategory = labelCategory.setLabel(
                      bloodOxygenValue, 'bloodoxygen', 17);
                  return Column(
                    children: [
                      bloodOxygenCategory == "rendah"
                          ? announceItem(
                              'Saturasi Oksigen Rendah',
                              'Nilai saturasi oksigen kamu ada dibawah nilai normal nih, yuk baca informasi berikut sebagai penanganan pertama pada kondisi saturasi oksigen.',
                              'bloodOxygen',
                              route: '/low-blood-oxygen',
                            )
                          : announceItem(
                              'Saturasi Oksigen Normal',
                              'Nilai saturasi oksigen kamu normal nih.',
                              'bloodOxygen',
                            ),
                    ],
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _pullToRefresh,
        child: ListView(
          children: [
            header(),
            content(),
            announce(),
          ],
        ),
      ),
    );
  }

  Future<void> _pullToRefresh() async {
    final heartRateType = [
      HealthDataType.HEART_RATE,
    ];

    final bloodOxygenType = [
      HealthDataType.BLOOD_OXYGEN,
    ];
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: 30));
    context
        .read<HeartRateCubit>()
        .getHeartRate(now: now, yesterday: yesterday, types: heartRateType);
    context
        .read<BloodOxygenCubit>()
        .getBloodOxygen(now: now, yesterday: yesterday, types: bloodOxygenType);
  }
}
