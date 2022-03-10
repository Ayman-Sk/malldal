import 'package:dal/theme/app_colors.dart';
import 'package:flutter/material.dart';

class FloatingActionButtonWidget extends StatefulWidget {
  const FloatingActionButtonWidget({
    Key key,
  }) : super(key: key);

  @override
  _FloatingActionButtonWidgetState createState() =>
      _FloatingActionButtonWidgetState();
}

class _FloatingActionButtonWidgetState
    extends State<FloatingActionButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      child: FittedBox(
        child: FloatingActionButton(
          
          elevation: 0,
          backgroundColor: AppColors.primary,
          onPressed: () {},
          // child: Center(
          //   child: Icon(
          //     Icons.add,
          //     color: Colors.white,
          //   ),
          // ),
          //
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              side: BorderSide(color: Colors.white, width: 3)),
        ),
      ),
    );
  }
}
