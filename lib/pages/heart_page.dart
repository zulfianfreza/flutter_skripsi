import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'package:skripsi/cubit/auth_cubit.dart';
import 'package:skripsi/cubit/heart_rate_cubit.dart';
import 'package:skripsi/models/health_model.dart';
import 'package:skripsi/services/health_service.dart';
import 'package:skripsi/services/label_category.dart';
import 'package:skripsi/services/push_notification_service.dart';
import 'package:skripsi/shared/theme.dart';
import 'package:skripsi/widgets/data_list_tile.dart';

class HeartPage extends StatefulWidget {
  const HeartPage({Key? key}) : super(key: key);

  @override
  State<HeartPage> createState() => _HeartPageState();
}

class _HeartPageState extends State<HeartPage> {
  // final now = DateTime.now();
  final LabelCategory labelCategory = LabelCategory();
  final heartRateType = [
    HealthDataType.HEART_RATE,
  ];

  late HealthModel heartRateFromFirebase;
  String label = "";

  syncData(int value, String dateFrom) async {
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: 30));
    context
        .read<HeartRateCubit>()
        .getHeartRate(now: now, yesterday: yesterday, types: heartRateType);
    heartRateFromFirebase = await HealthService().getHeartRateFromFirebase();
    updateHeartRate(value, dateFrom);
  }

  updateHeartRate(int currentValue, String currentDateFrom) async {
    if (heartRateFromFirebase.value == currentValue &&
        heartRateFromFirebase.dateFrom == currentDateFrom) {
      dev.log('Sama');
    } else {
      await HealthService()
          .updateHeartRateFromFirebase(currentValue, currentDateFrom);
      label = labelCategory.setLabel(currentValue, 'heartrate', 25);
      if (label == 'rendah') {
        await PushNotificationService().pushNotification(
          'Denyut Jantung Rendah',
          'Denyut jantung kamu dibawah nilai normal nih :(.',
        );
      } else if (label == 'tinggi') {
        await PushNotificationService().pushNotification(
          'Denyut Jantung Tinggi',
          'Denyut jantung kamu tinggi nih.',
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String todayFormatted =
        DateFormat("EEEE, d MMMM yyyy").format(DateTime.now());

    getValueFromString(HealthValue healthValue) {
      List<String> value = healthValue.toString().split('.');
      return int.parse(value[0]);
    }

    Widget header() {
      return BlocBuilder<HeartRateCubit, HeartRateState>(
        builder: (context, state) {
          if (state is HeartRateSuccess) {
            int lastValue = getValueFromString(state.heartRate.first.value);
            String lastDateFrom = state.heartRate.first.dateFrom.toString();
            return Container(
              padding: EdgeInsets.all(defaultMargin),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(7),
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
                          child: Icon(
                            Icons.chevron_left,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Denyut Jantung',
                        style: blackTextStyle.copyWith(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, '/heart-rate-information');
                        },
                        child: Container(
                          padding: EdgeInsets.all(7),
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
                          child: Icon(
                            Icons.info_outline,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          syncData(lastValue, lastDateFrom);
                        },
                        child: Container(
                          padding: EdgeInsets.all(7),
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
                          child: Icon(
                            Icons.sync,
                          ),
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

    Widget today() {
      return BlocBuilder<HeartRateCubit, HeartRateState>(
        builder: (context, state) {
          if (state is HeartRateSuccess) {
            List<int> listValue = state.heartRate
                .map((e) => getValueFromString(e.value))
                .toList();

            return Container(
              margin: EdgeInsets.symmetric(
                horizontal: defaultMargin,
              ),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: kWhiteColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(3, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todayFormatted,
                    style: blackTextStyle.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Text(
                              '${listValue.reduce(min)} BPM',
                              style: blackTextStyle.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Minimum',
                              style: greyTextStyle,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Text(
                              '${getValueFromString(state.heartRate.first.value)} BPM',
                              style: blackTextStyle.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Terbaru',
                              style: greyTextStyle,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Text(
                              '${listValue.reduce(max)} BPM',
                              style: blackTextStyle.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Maksimum',
                              style: greyTextStyle,
                            ),
                          ],
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

    Widget history() {
      return BlocBuilder<HeartRateCubit, HeartRateState>(
        builder: (context, state) {
          if (state is HeartRateSuccess) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    right: defaultMargin,
                    left: defaultMargin,
                    bottom: defaultMargin,
                    top: defaultMargin,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Data',
                        style: blackTextStyle.copyWith(
                          fontSize: 20,
                          fontWeight: medium,
                        ),
                      ),
                      Column(
                        children: state.heartRate
                            .map(
                              (health) => DataListTile(
                                health: health,
                                category: 'heartrate',
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return SizedBox();
          }
        },
      );
    }

    Widget content() {
      return Expanded(
        child: ListView(
          children: [
            today(),
            history(),
          ],
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            header(),
            content(),
          ],
        ),
      ),
    );
  }
}
