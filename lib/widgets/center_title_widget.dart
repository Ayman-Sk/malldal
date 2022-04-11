import 'package:flutter/material.dart';

class CenterTitleWidget extends StatelessWidget {
  final IconData iconData;
  final String title;
  CenterTitleWidget({@required this.title, @required this.iconData});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            // color: AppColors.primary.withOpacity(0.5),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            title,
            style: TextStyle(
                // color: AppColors.primary.withOpacity(0.5),
                ),
          )
        ],
      ),
    );
  }
}
