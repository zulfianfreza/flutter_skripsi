import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:skripsi/services/label_category.dart';
import 'package:skripsi/shared/theme.dart';

class DataListTile extends StatelessWidget {
  final HealthDataPoint health;
  final String category;
  const DataListTile({
    required this.health,
    required this.category,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LabelCategory labelCategory = LabelCategory();

    String label = "";
    List<String> healthValue = health.value.toString().split('.');
    int value = int.parse(healthValue[0]);

    label = labelCategory.setLabel(value, category, 25);

    return Container(
      padding: EdgeInsets.all(20),
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
      margin: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$value${category == "heartrate" ? " ${health.unitString}" : "%"}',
                style: blackTextStyle.copyWith(
                  fontSize: 16,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 3,
                ),
                margin: EdgeInsets.only(
                  top: 5,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: (label == 'rendah' || label == 'tinggi'
                          ? kRedColor
                          : kGreenColor)
                      .withOpacity(0.1),
                ),
                child: Text(
                  label,
                  style: blackTextStyle.copyWith(
                    color: (label == 'rendah' || label == 'tinggi'
                        ? kRedColor
                        : kGreenColor),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          Text(
            health.dateFrom.toString(),
            style: greyTextStyle,
          ),
        ],
      ),
    );
  }
}
