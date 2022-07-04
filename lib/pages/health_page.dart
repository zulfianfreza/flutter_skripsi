import 'package:flutter/material.dart';
import 'package:skripsi/shared/theme.dart';
import 'package:skripsi/widgets/vital_category_item.dart';

class HealthPage extends StatelessWidget {
  const HealthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget header() {
      return Container(
        margin: EdgeInsets.all(defaultMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tanda - Tanda Vital',
              style: blackTextStyle.copyWith(
                fontSize: 30,
              ),
            ),
            Text(
              'Tanda-tanda vital adalah ukuran statistik berbagai fisiologis yang digunakan untuk membantuk menentukan status kesehatan seseorang, meliputi detak jantung, saturasi oksigen dan tekanan darah.',
              style: greyTextStyle.copyWith(
                fontSize: 16,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      );
    }

    Widget content() {
      return Container(
        margin: EdgeInsets.only(
          right: defaultMargin,
          left: defaultMargin,
        ),
        child: Column(
          children: [
            VitalCategoryItem(
              label: 'Detak Jantung',
              image: 'assets/heart_rate_icon.png',
              route: '/heart-rate',
            ),
            SizedBox(
              height: 10,
            ),
            VitalCategoryItem(
              label: 'Saturasi Oksigen',
              image: 'assets/oxygen_icon.png',
              route: '/blood-oxygen',
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: ListView(
        children: [
          header(),
          content(),
        ],
      ),
    );
  }
}
