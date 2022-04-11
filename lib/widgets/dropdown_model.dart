import 'package:flutter/material.dart';

class DropDownListModel {
  String name;
  int id;
  bool isEmpty = false;
  DropDownListModel(this.id, this.name);

  static List<DropdownMenuItem<DropDownListModel>> buildDropDownMenuItem(
      List items) {
    List<DropdownMenuItem<DropDownListModel>> i = [];
    for (DropDownListModel element in items) {
      i.add(DropdownMenuItem(
        value: element,
        child: Center(
          child: Text(element.name),
        ),
      ));
    }
    return i;
  }

  static List<DropdownMenuItem<DropDownListModel>>
      buildDropDownMenuItemFromData(Map<String, dynamic> data, bool isCities) {
    List citiesList = data['data']['data'];
    List items = [];
    citiesList.forEach((element) {
      int counter = 0;
      isCities
          ? items.add(DropDownListModel(counter, element['cityName']))
          : items.add(DropDownListModel(counter, element['title']));
    });
    print('iteeeeeeeeemsss');
    print(items[0].id);
    List<DropdownMenuItem<DropDownListModel>> i = [];
    for (DropDownListModel element in items) {
      i.add(DropdownMenuItem(
        value: element,
        child: Center(
          child: Text(element.name),
        ),
      ));
    }
    return i;
  }

  static List<DropDownListModel> getcities() {
    return <DropDownListModel>[
      DropDownListModel(0, "دمشق"),
      DropDownListModel(1, "ريف دمشق"),
      DropDownListModel(2, "حلب"),
      DropDownListModel(3, "طرطوس"),
      DropDownListModel(4, "اللاذقية"),
      DropDownListModel(5, "حمص"),
      DropDownListModel(6, "حماه"),
      DropDownListModel(7, "درعا"),
      DropDownListModel(8, "السويداء"),
      DropDownListModel(9, "القنيطرة"),
      DropDownListModel(10, "الرقة"),
      DropDownListModel(11, "دير الزور"),
      DropDownListModel(12, "الحسكة"),
      DropDownListModel(13, "ادلب"),
    ];
  }

  // List<DropDownListModel> setCitiesList(Map<String, dynamic> data) {
  //   List citiesList = data['data']['data'];
  //   citiesList.forEach((element) {
  //     int count=0;
  //     DropDownListModel(count,element['cityName']);
  //   })
  // }

  static List<DropDownListModel> getgender() {
    return <DropDownListModel>[
      DropDownListModel(0, "male"),
      DropDownListModel(1, "female"),
    ];
  }
}
