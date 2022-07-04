import 'package:flutter/material.dart';
import 'package:skripsi/shared/theme.dart';

class HeartRateInformationPage extends StatelessWidget {
  const HeartRateInformationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget header() {
      return Container(
        margin: EdgeInsets.all(defaultMargin),
        width: double.infinity,
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Color(0xffefefef),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.chevron_left,
                  size: 21,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Tentang Detak Jantung',
              style: blackTextStyle.copyWith(
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    Widget columnItem(String value, bool isTitle) {
      return Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              value,
              style: blackTextStyle.copyWith(
                fontSize: 16,
                fontWeight: isTitle ? bold : reguler,
              ),
            ),
          ),
        ],
      );
    }

    Widget content() {
      return Container(
        margin: EdgeInsets.only(
          right: defaultMargin,
          left: defaultMargin,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/4a5661c4-shutterstock_116229451.jpg',
            ),
            SizedBox(
              height: defaultMargin,
            ),
            Text(
              'Detak Jantung',
              style: blackTextStyle.copyWith(
                fontSize: 18,
                fontWeight: bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Jantung merupakan organ vital pada tubuh manusia. Fungsi jantung adalah memompa darah ke seluruh tubuh, sehingga berbagai organ dan sistem tubuh Anda bisa bekerja sebagaimana mestinya.\n\nSelain tekanan darah, salah satu indikator penting dari kesehatan jantung adalah detak jantung. Detak jantung adalah berapa kali jantung Anda berdenyut dalam satu menit. Adapun detak jantung seseorang dipengaruhi oleh berbagai faktor, seperti usia, ukuran tubuh, kondisi jantung, cuaca atau temperatur udara, aktivitas fisik, emosi, dan obat-obatan tertentu.',
              style: blackTextStyle.copyWith(
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: defaultMargin,
            ),
            Text(
              'Tabel Detak Jantung Berdasarkan Usia',
              style: blackTextStyle.copyWith(
                fontSize: 18,
                fontWeight: bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Table(
                border: TableBorder.all(
                  color: Colors.black,
                  style: BorderStyle.solid,
                  width: 1,
                ),
                children: [
                  TableRow(
                    children: [
                      columnItem('Usia', true),
                      columnItem('Normal (bpm)', true),
                    ],
                  ),
                  TableRow(
                    children: [
                      columnItem('< 1', false),
                      columnItem('80 - 150', false),
                    ],
                  ),
                  TableRow(
                    children: [
                      columnItem('1 - 2', false),
                      columnItem('80 - 130', false),
                    ],
                  ),
                  TableRow(
                    children: [
                      columnItem('3 - 4', false),
                      columnItem('80 - 120', false),
                    ],
                  ),
                  TableRow(
                    children: [
                      columnItem('5 - 6', false),
                      columnItem('75 - 115', false),
                    ],
                  ),
                  TableRow(
                    children: [
                      columnItem('7 - 9', false),
                      columnItem('70 - 110', false),
                    ],
                  ),
                  TableRow(
                    children: [
                      columnItem('> 10', false),
                      columnItem('60 - 100', false),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: defaultMargin,
            ),
            Divider(),
          ],
        ),
      );
    }

    Widget disclaimer() {
      return Container(
        margin: EdgeInsets.all(defaultMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning,
                  size: 16,
                  color: kRedColor,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Disclaimer',
                  style: blackTextStyle.copyWith(
                    fontSize: 18,
                    fontWeight: bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Harap diingat bahwa pemantauan detak jantung hanya untuk kebugaran dan kesehatan, bukan untuk diagnosis atau perawatan kondisi medis apapun. Jika Anda memiliki kekhawatiran tentang jantung Anda, pastikan untuk berkonsultasi dengan profesional medis.',
              style: blackTextStyle.copyWith(
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: kWhiteColor,
      body: ListView(
        children: [
          header(),
          content(),
          disclaimer(),
        ],
      ),
    );
  }
}
