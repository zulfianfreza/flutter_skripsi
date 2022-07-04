import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skripsi/cubit/heart_rate_cubit.dart';
import 'package:skripsi/services/health_service.dart';
import 'package:skripsi/shared/theme.dart';
import 'package:skripsi/widgets/data_list_tile.dart';

class HeartRatePage extends StatefulWidget {
  const HeartRatePage({Key? key}) : super(key: key);

  @override
  State<HeartRatePage> createState() => _HeartRatePageState();
}

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTH_NOT_GRANTED,
  DATA_ADDED,
  DATA_NOT_ADDED,
  STEPS_READY,
}

class _HeartRatePageState extends State<HeartRatePage> {
  List<HealthDataPoint> _healthDataList = [];
  List<int> valueList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;
  String formattedDate = DateFormat("EEEE, d MMMM yyyy").format(DateTime.now());
  HealthDataPoint? firstHealthData;
  final types = [
    HealthDataType.HEART_RATE,
    // HealthDataType.BLOOD_OXYGEN,
  ];
  late Future<List<HealthDataPoint>> _heartRateList;

  // create a HealthFactory for use in the app
  HealthFactory health = HealthFactory();

  @override
  void initState() {
    fetchData();
    syncDataPeriodic();
    super.initState();
  }

  /// Fetch data points from the health plugin and show them in the app.
  void fetchData() async {
    setState(() => _state = AppState.FETCHING_DATA);
    // get data within the last 24 hours
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(
      hours: now.hour,
      minutes: now.minute,
      seconds: now.second,
      milliseconds: now.millisecond,
      microseconds: now.microsecond,
    ));

    _healthDataList = await HealthService().fetchData(now, yesterday, types);

    _healthDataList.map((e) => valueList.add(getValue(e.value))).toList();

    _healthDataList.sort((a, b) {
      var aDate = a.dateFrom;
      var bDate = b.dateFrom;
      return bDate.compareTo(aDate);
    });

    if (_healthDataList.isNotEmpty) {
      firstHealthData = _healthDataList.first;
    }

    _healthDataList.map((e) => valueList.add(getValue(e.value))).toList();

    setState(() {
      _state = _healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
    });
  }

  void syncData() async {
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: 30));
    context
        .read<HeartRateCubit>()
        .getHeartRate(now: now, yesterday: yesterday, types: types);
  }

  syncDataPeriodic() {
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: 30));
    Timer.periodic(Duration(milliseconds: 1000), (timer) {
      context
          .read<HeartRateCubit>()
          .getHeartRate(now: now, yesterday: yesterday, types: types);
    });
  }

  getValue(HealthValue healthValue) {
    List<String> value = healthValue.toString().split('.');
    return int.parse(value[0]);
  }

  Widget _contentFetchingData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(
            strokeWidth: 5,
            color: kPrimaryColor,
          ),
        ),
        Text(
          'Fetching data...',
          style: blackTextStyle.copyWith(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _contentDataReady() {
    return BlocBuilder<HeartRateCubit, HeartRateState>(
      builder: (context, state) {
        if (state is HeartRateSuccess) {
          return ListView(
            children: [
              Container(
                margin: EdgeInsets.only(
                  right: defaultMargin,
                  left: defaultMargin,
                  bottom: defaultMargin,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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

  Widget _contentNoData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/copy-2872259-2389470.png',
          height: 100,
        ),
        SizedBox(height: 16),
        Text(
          'Data Kosong.',
          style: blackTextStyle.copyWith(
            fontSize: 22,
            fontWeight: semiBold,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Data denyut jantung mu hari ini masih kosong.',
          style: greyTextStyle.copyWith(fontSize: 16),
        ),
      ],
    );
  }

  Widget _contentNotFetched() {
    return Column(
      children: [
        Text('Press the download button to fetch data.'),
        Text('Press the plus button to insert some random data.'),
        Text('Press the walking button to get total step count.'),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  Widget _authorizationNotGranted() {
    return Text('Authorization not given. '
        'For Android please check your OAUTH2 client ID is correct in Google Developer Console. '
        'For iOS check your permissions in Apple Health.');
  }

  Widget header() {
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
                        offset: Offset(3, 3), // changes position of shadow
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
                  Navigator.pushNamed(context, '/heart-rate-information');
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
                        offset: Offset(3, 3), // changes position of shadow
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
                onTap: syncData,
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
                        offset: Offset(3, 3), // changes position of shadow
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
  }

  Widget today() {
    double average =
        valueList.fold(0, (avg, element) => avg + element / valueList.length);
    int avg = average.round();

    final lastHealthData = {
      'typeString': firstHealthData?.typeString,
      'value': firstHealthData?.value,
      'unitString': firstHealthData?.unitString,
      'dateFrom': firstHealthData?.dateFrom,
    };

    List<String>? firstValueString =
        firstHealthData?.value.toString().split('.');
    int firstValue =
        _healthDataList.isEmpty ? 0 : int.parse(firstValueString![0]);

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
            formattedDate,
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
                      '${valueList.isEmpty ? 0 : valueList.reduce(min)} BPM',
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
                      '$firstValue BPM',
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
                      '${valueList.isEmpty ? 0 : valueList.reduce(max)} BPM',
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
  }

  Widget _content() {
    if (_state == AppState.DATA_READY) {
      return _contentDataReady();
    } else if (_state == AppState.NO_DATA) {
      return _contentNoData();
    } else if (_state == AppState.FETCHING_DATA) {
      return _contentFetchingData();
    } else if (_state == AppState.AUTH_NOT_GRANTED) {
      return _authorizationNotGranted();
    }

    return _contentNotFetched();
  }

  Widget contentTitle() {
    return Container(
      margin: EdgeInsets.only(
        top: defaultMargin,
        left: defaultMargin,
        right: defaultMargin,
        bottom: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Data Terbaru',
            style: blackTextStyle.copyWith(
              fontSize: 18,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/all-heart-rate');
            },
            child: Text(
              'Lihat Semua',
              style: greyTextStyle.copyWith(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _state == AppState.FETCHING_DATA
          ? Center(child: _contentFetchingData())
          : SafeArea(
              child: Column(
                children: [
                  header(),
                  today(),
                  contentTitle(),
                  Expanded(
                    child: _content(),
                  ),
                ],
              ),
            ),
    );
  }
}
