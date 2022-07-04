import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/health.dart';
import 'package:skripsi/cubit/blood_oxygen_cubit.dart';
import 'package:skripsi/cubit/heart_rate_cubit.dart';
import 'package:skripsi/cubit/page_cubit.dart';
import 'package:skripsi/pages/health_page.dart';
import 'package:skripsi/pages/home_page.dart';
import 'package:skripsi/pages/user_page.dart';
import 'package:skripsi/shared/theme.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final heartRateType = [
    HealthDataType.HEART_RATE,
  ];

  final bloodOxygenType = [
    HealthDataType.BLOOD_OXYGEN,
  ];

  List pages = [
    HomePage(),
    HealthPage(),
    UserPage(),
  ];

  @override
  void initState() {
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: 30));
    context
        .read<HeartRateCubit>()
        .getHeartRate(now: now, yesterday: yesterday, types: heartRateType);
    context
        .read<BloodOxygenCubit>()
        .getBloodOxygen(now: now, yesterday: yesterday, types: bloodOxygenType);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PageCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          body: pages[currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            onTap: (value) {
              context.read<PageCubit>().setPage(value);
            },
            currentIndex: currentIndex,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                label: 'Home',
                icon: Column(
                  children: [
                    Image.asset(
                      currentIndex == 0
                          ? 'assets/icon_home_active.png'
                          : 'assets/icon_home.png',
                      color: currentIndex == 0
                          ? kPrimaryColor
                          : Colors.grey.withOpacity(0.7),
                      width: 20,
                      height: 20,
                    ),
                    currentIndex == 0
                        ? Container(
                            width: 4,
                            height: 4,
                            margin: EdgeInsets.only(top: 2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: kPrimaryColor),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
              BottomNavigationBarItem(
                label: 'Kesehatan',
                icon: Column(
                  children: [
                    Image.asset(
                      currentIndex == 1
                          ? 'assets/icon_heart_active.png'
                          : 'assets/icon_heart.png',
                      color: currentIndex == 1
                          ? kPrimaryColor
                          : Colors.grey.withOpacity(0.7),
                      height: 20,
                      width: 20,
                    ),
                    currentIndex == 1
                        ? Container(
                            width: 4,
                            height: 4,
                            margin: EdgeInsets.only(top: 2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: kPrimaryColor),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
              BottomNavigationBarItem(
                label: 'User',
                icon: Column(
                  children: [
                    Image.asset(
                      currentIndex == 2
                          ? 'assets/icon_user_active.png'
                          : 'assets/icon_user.png',
                      color: currentIndex == 2
                          ? kPrimaryColor
                          : Colors.grey.withOpacity(0.7),
                      width: 20,
                      height: 20,
                    ),
                    currentIndex == 2
                        ? Container(
                            width: 4,
                            height: 4,
                            margin: EdgeInsets.only(top: 2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: kPrimaryColor),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
