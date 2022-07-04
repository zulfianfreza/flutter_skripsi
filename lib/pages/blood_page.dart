import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'package:skripsi/cubit/auth_cubit.dart';
import 'package:skripsi/cubit/blood_oxygen_cubit.dart';
import 'package:skripsi/cubit/heart_rate_cubit.dart';
import 'package:skripsi/models/health_model.dart';
import 'package:skripsi/services/health_service.dart';
import 'package:skripsi/services/label_category.dart';
import 'package:skripsi/services/push_notification_service.dart';
import 'package:skripsi/shared/theme.dart';
import 'package:skripsi/widgets/data_list_tile.dart';

class BloodPage extends StatefulWidget {
  const BloodPage({Key? key}) : super(key: key);

  @override
  State<BloodPage> createState() => _BloodPageState();
}

class _BloodPageState extends State<BloodPage> {
  // final now = DateTime.now();
  final LabelCategory labelCategory = LabelCategory();
  final bloodOxygenType = [
    HealthDataType.BLOOD_OXYGEN,
  ];

  late HealthModel bloodOxygenFromFirebase;
  String label = "";
  syncData(int value, String dateFrom) async {
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: 30));
    context
        .read<BloodOxygenCubit>()
        .getBloodOxygen(now: now, yesterday: yesterday, types: bloodOxygenType);
    bloodOxygenFromFirebase =
        await HealthService().getBloodOxygenFromFirebase();
    updateBloodOxygen(value, dateFrom);
  }

  updateBloodOxygen(int currentValue, String currentDateFrom) async {
    if (bloodOxygenFromFirebase.value == currentValue &&
        bloodOxygenFromFirebase.dateFrom == currentDateFrom) {
      dev.log('Sama');
    } else {
      await HealthService()
          .updateBloodOxygenFromFirebase(currentValue, currentDateFrom);
      label = labelCategory.setLabel(currentValue, 'bloodoxygen', 25);
      if (label == 'rendah') {
        await PushNotificationService().pushNotification(
          'Saturasi Oksigen Rendah',
          'Nilai saturasi oksigen kamu rendah nih :(.',
        );
      }
    }
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
      return BlocBuilder<BloodOxygenCubit, BloodOxygenState>(
        builder: (context, state) {
          if (state is BloodOxygenSuccess) {
            int lastValue = getValueFromString(state.bloodOxygen.first.value);
            String lastDateFrom = state.bloodOxygen.first.dateFrom.toString();
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
                        'Saturasi Oksigen',
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
                              context, '/blood-oxygen-information');
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
      return BlocBuilder<BloodOxygenCubit, BloodOxygenState>(
        builder: (context, state) {
          if (state is BloodOxygenSuccess) {
            List<int> listValue = state.bloodOxygen
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
                              '${listValue.reduce(min)}%',
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
                              '${getValueFromString(state.bloodOxygen.first.value)}%',
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
                              '${listValue.reduce(max)}%',
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
      return BlocBuilder<BloodOxygenCubit, BloodOxygenState>(
        builder: (context, state) {
          if (state is BloodOxygenSuccess) {
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
                        children: state.bloodOxygen
                            .map(
                              (health) => DataListTile(
                                health: health,
                                category: 'bloodoxygen',
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
