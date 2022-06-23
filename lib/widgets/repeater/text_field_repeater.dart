import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../theme/app_colors.dart';

Map dropdownData = {};
Map dropdownIndex = {};
List<Icon> listofIconByIndex = [];

class TextFieldRepeater {
  static List<String> textsList = [];
  static List<Icon> icons = [
    Icon(FontAwesomeIcons.phone, color: AppColors.primary),
    Icon(FontAwesomeIcons.whatsapp, color: Color(0xFF25D366)),
    Icon(FontAwesomeIcons.telegram, color: Color(0xFF229ED9)),
    Icon(FontAwesomeIcons.facebook, color: Color(0xFF4267B2)),
    Icon(FontAwesomeIcons.instagram, color: Color(0xFFE1306C))
  ];
  TextFieldRepeater() {
    // icons = [];
    // icons = iconList;
    // icons.addAll(iconList);
    // for (int i = 0; i < icons.length; i++) {
    //   dropdownData[icons[i]] = '';
    //   dropdownIndex[icons[i]] = i;
    // }
  }

  RepeaterWidgets repeaterWidgets =
      RepeaterWidgets(texts: textsList, icons: icons);

  void addNewAccount() {
    textsList.add(' ');
  }

  void clearAllAccounts() => textsList.clear();

  List get getTexts => textsList;
  Map get getDropdownData => dropdownData;
  String get getPhone => getDropdownData[icons[0]].toString();
  String get getWhatsapp => getDropdownData[icons[1]].toString();
  String get getTelegram => getDropdownData[icons[2]].toString();
  String get getFacebook => getDropdownData[icons[3]].toString();
  String get getInstagram => getDropdownData[icons[4]].toString();

  // get getTexts => textsList;
  // get getIcons => icons;
}

// ignore: must_be_immutable
class RepeaterWidgets extends StatefulWidget {
  List<String> texts = [];
  List<Icon> icons = [];
  RepeaterWidgets({Key key, @required this.texts, @required this.icons})
      : super(key: key);

  @override
  State<RepeaterWidgets> createState() => RrepeaterWidgetsState();
}

class RrepeaterWidgetsState extends State<RepeaterWidgets> {
  static List<String> textsList = [];
  static List<Icon> allIcons = [];
  static List<Icon> availableIcons = [];
  @override
  void initState() {
    textsList = widget.texts;
    allIcons = widget.icons;
    availableIcons = widget.icons;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> textFieldsWidgets = getTextFormFields();
    return Column(
      children: textFieldsWidgets,
    );
  }

  List<Widget> getTextFormFields() {
    List<Widget> textFields = [];
    for (int i = 0; i < textsList.length; i++) {
      Widget newTextField = Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: TextFields(i)),
            const SizedBox(width: 16),
            DropdownWidget(i, availableIcons, allIcons),
            const SizedBox(width: 16),
            _addRemoveButton(i == textsList.length - 1, i),
          ],
        ),
      );
      textFields.add(newTextField);
    }
    return textFields;
  }

  Widget _addRemoveButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          if (textsList.length != allIcons.length) {
            textsList.add('');
          } else {
            // print(index);
            // print(allIcons);
            textsList.removeAt(index);
            dropdownData.remove(dropdownIndex[index]);
            dropdownIndex.remove(index);
            listofIconByIndex.removeAt(index);
          }
          // add new text-fields at the top of all friends textfields
        } else {
          // print(index);
          // print(allIcons);
          // print(dropdownIndex[index]);

          textsList.removeAt(index);
          dropdownData.remove(dropdownIndex[index]);
          dropdownIndex.remove(index);
          listofIconByIndex.removeAt(index);
        }
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color:
              (add) && index + 1 != allIcons.length ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) && index + 1 != allIcons.length ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }
}

class TextFields extends StatefulWidget {
  final int index;
  const TextFields(this.index, {Key key}) : super(key: key);
  @override
  _TextFieldsState createState() => _TextFieldsState();
}

class _TextFieldsState extends State<TextFields> {
  TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _nameController.text = RrepeaterWidgetsState.textsList[widget.index];
    });

    return TextFormField(
      controller: _nameController,
      onChanged: (v) {
        RrepeaterWidgetsState.textsList[widget.index] = v;
        dropdownData[dropdownIndex[widget.index]] = v;
        // dropdownData[DropdownWidgetState.dropdownValue] = v;
      },
      decoration: InputDecoration(
        hintText: 'Enter your Account',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: AppColors.primary,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 2.0,
          ),
        ),
      ),
      validator: (v) {
        if (v.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}

// ignore: must_be_immutable
class DropdownWidget extends StatefulWidget {
  final int index;
  List<Icon> icons;
  List<Icon> availableIcons;
  DropdownWidget(this.index, this.availableIcons, this.icons, {Key key})
      : super(key: key);

  @override
  State<DropdownWidget> createState() => DropdownWidgetState();
}

class DropdownWidgetState extends State<DropdownWidget> {
  Icon dropdownValue;
  // late int index;
  @override
  void initState() {
    super.initState();
    dropdownValue = widget.availableIcons[widget.index];
    listofIconByIndex.add(dropdownValue);
  }

  @override
  Widget build(BuildContext context) {
    dropdownIndex[widget.index] = dropdownValue;
    dropdownValue = listofIconByIndex[widget.index];
    print(dropdownValue);

    return DropdownButton<Icon>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      onChanged: (Icon newValue) {
        setState(() {
          // int firstIndex = widget.availableIcons.indexOf(newValue!);
          // Icon temp = widget.availableIcons[firstIndex];
          // widget.availableIcons[firstIndex] =
          //     widget.availableIcons[widget.index];
          // widget.availableIcons[widget.index] = temp;
          listofIconByIndex[widget.index] = newValue;
          dropdownValue = newValue;
          dropdownIndex[widget.index] = newValue;
        });
      },
      items: widget.availableIcons
          .map((Icon item) => DropdownMenuItem<Icon>(child: item, value: item))
          .toList(),
    );
  }
}
