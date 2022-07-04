import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:skripsi/services/health_service.dart';
import 'package:skripsi/shared/theme.dart';
import 'package:skripsi/widgets/data_list_tile.dart';

class AllHeartRatePage extends StatefulWidget {
  const AllHeartRatePage({Key? key}) : super(key: key);

  @override
  State<AllHeartRatePage> createState() => _AllHeartRatePageState();
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

class _AllHeartRatePageState extends State<AllHeartRatePage> {
  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;
  List<int> valueList = [];

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  /// Fetch data points from the health plugin and show them in the app.
  void fetchData() async {
    setState(() => _state = AppState.FETCHING_DATA);
    // get data within the last 24 hours
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: 30));
    final types = [
      HealthDataType.HEART_RATE,
      // HealthDataType.BLOOD_OXYGEN,
    ];
    _healthDataList = await HealthService().fetchData(now, yesterday, types);

    log(_healthDataList.length.toString());

    _healthDataList.map((e) => valueList.add(getValue(e.value))).toList();

    setState(() {
      _state = _healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
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
        Text('Fetching data...')
      ],
    );
  }

  Widget _contentDataReady() {
    return ListView(
      children: [
        Container(
          margin: EdgeInsets.only(
            left: defaultMargin,
            right: defaultMargin,
            bottom: defaultMargin,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Semua Data Denyut Jantung',
                style: blackTextStyle.copyWith(
                  fontSize: 18,
                ),
              ),
              Column(
                children: _healthDataList
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
  }

  Widget _contentNoData() {
    return Text('No Data to show');
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
                    color: Color(0xfff5f5f5),
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
          GestureDetector(
            onTap: fetchData,
            child: Container(
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Color(0xfff5f5f5),
              ),
              child: Icon(
                Icons.sync,
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
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: Column(
          children: [
            header(),
            Expanded(
              child: _content(),
            ),
          ],
        ),
      ),
    );
  }
}
