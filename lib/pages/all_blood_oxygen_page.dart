import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skripsi/shared/theme.dart';
import 'package:skripsi/widgets/data_list_tile.dart';

class AllBloodOxygenPage extends StatefulWidget {
  const AllBloodOxygenPage({Key? key}) : super(key: key);

  @override
  State<AllBloodOxygenPage> createState() => _AllBloodOxygenPageState();
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

class _AllBloodOxygenPageState extends State<AllBloodOxygenPage> {
  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;
  List<int> valueList = [];

  // create a HealthFactory for use in the app
  HealthFactory health = HealthFactory();

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  /// Fetch data points from the health plugin and show them in the app.
  Future fetchData() async {
    setState(() => _state = AppState.FETCHING_DATA);

    // define the types to get
    final types = [
      // HealthDataType.HEART_RATE,
      HealthDataType.BLOOD_OXYGEN,
    ];

    // with coresponsing permissions
    final permissions = [
      // HealthDataAccess.READ,
      HealthDataAccess.READ,
    ];

    // get data within the last 24 hours
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: 30));
    // requesting access to the data types before reading them
    // note that strictly speaking, the [permissions] are not
    // needed, since we only want READ access.
    bool requested =
        await health.requestAuthorization(types, permissions: permissions);
    debugPrint(requested.toString());

    // If we are trying to read Step Count, Workout, Sleep or other data that requires
    // the ACTIVITY_RECOGNITION permission, we need to request the permission first.
    // This requires a special request authorization call.
    //
    // The location permission is requested for Workouts using the Distance information.
    await Permission.activityRecognition.request();
    await Permission.location.request();

    if (requested) {
      try {
        // fetch health data
        List<HealthDataPoint> healthData =
            await health.getHealthDataFromTypes(yesterday, now, types);
        // save all the new data points (only the first 100)
        _healthDataList.addAll((healthData.length < 100)
            ? healthData
            : healthData.sublist(0, 100));
        _healthDataList.sort((a, b) {
          var aDate = a.dateFrom;
          var bDate = b.dateFrom;
          return bDate.compareTo(aDate);
        });

        healthData.map((e) => valueList.add(getValue(e.value))).toList();
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }

      // filter out duplicates
      _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

      // print the results
      _healthDataList.forEach((x) => print(x));

      // update the UI to display the results
      setState(() {
        _state =
            _healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
      });
    } else {
      print("Authorization not granted");
      setState(() => _state = AppState.DATA_NOT_FETCHED);
    }
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
    double average =
        valueList.fold(0, (avg, element) => avg + element / valueList.length);
    int avg = average.round();
    // return ListView.builder(
    //   itemCount: _healthDataList.length,
    //   itemBuilder: (_, index) {
    //     HealthDataPoint p = _healthDataList[index];
    //     return ListTile(
    //       title: Text("${p.typeString}: ${p.value}"),
    //       trailing: Text('${p.unitString}'),
    //       subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
    //     );
    //   },
    // );
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
                'Semua Data Saturasi Oksigen',
                style: blackTextStyle.copyWith(
                  fontSize: 18,
                ),
              ),
              Column(
                children: _healthDataList
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
                'Saturasi Oksigen',
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
