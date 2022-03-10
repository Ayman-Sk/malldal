import 'package:dal/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomMultiselectDropDown extends StatefulWidget {
  final Function(List<int>) selectedList;
  final List<String> listOFStrings;

  CustomMultiselectDropDown(
      {@required this.listOFStrings, @required this.selectedList});

  @override
  createState() {
    return new _CustomMultiselectDropDownState();
  }
}

class _CustomMultiselectDropDownState extends State<CustomMultiselectDropDown> {
  List<String> listOFSelectedItem = [];
  List<int> listOfIdsSelectedItem = [];
  String selectedText = "";
  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<PostRequestProvider>(context);
    // provider.cities = [1, 2, 3];
    // print(provider.cities);
    // print(widget.listOfItems);

    // var size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: ExpansionTile(
        iconColor: Colors.grey,
        title: Text(
          listOFSelectedItem.isEmpty ? "اختر" : joinString(listOFSelectedItem),
          style: TextStyle(
            color: AppColors.accent,
            fontWeight: FontWeight.w400,
            fontSize: 15.0,
          ),
        ),
        children: <Widget>[
          new ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.listOFStrings.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.only(bottom: 8.0),
                child: _ViewItem(
                    item: widget.listOFStrings[index],
                    selected: (val) {
                      selectedText = val;
                      print(val);
                      if (listOFSelectedItem.contains(val)) {
                        listOFSelectedItem.remove(val);
                        listOfIdsSelectedItem
                            .remove(widget.listOFStrings.indexOf(val));
                      } else {
                        listOFSelectedItem.add(val);
                        listOfIdsSelectedItem
                            .add(widget.listOFStrings.indexOf(val));
                      }
                      widget.selectedList(listOfIdsSelectedItem);
                      setState(() {});
                    },
                    itemSelected: listOFSelectedItem
                        .contains(widget.listOFStrings[index])),
              );
            },
          ),
        ],
      ),
    );
  }

  String joinString(List<String> temp) {
    return temp.join('/ ');
  }
}

// ignore: must_be_immutable
class _ViewItem extends StatelessWidget {
  String item;
  bool itemSelected;
  final Function(String) selected;

  _ViewItem(
      {@required this.item,
      @required this.itemSelected,
      @required this.selected});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding:
          EdgeInsets.only(left: size.width * .032, right: size.width * .098),
      child: Row(
        children: [
          SizedBox(
            height: 24.0,
            width: 24.0,
            child: Checkbox(
              value: itemSelected,
              onChanged: (val) {
                selected(item);
              },
              activeColor: AppColors.primary,
            ),
          ),
          SizedBox(
            width: size.width * .025,
          ),
          Text(
            item,
            // style: GoogleFonts.poppins(
            //   textStyle: TextStyle(
            //     color: PrimeDentalColors.grey,
            //     fontWeight: FontWeight.w400,
            //     fontSize: 17.0,
            //   ),
            // ),
          ),
        ],
      ),
    );
  }
}
