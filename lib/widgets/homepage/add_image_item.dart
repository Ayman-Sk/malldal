import 'package:dal/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AddImageItem extends StatelessWidget {
  final String imgUrl;
  AddImageItem(this.imgUrl);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, right: 5, left: 5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: AppColors.primary.withOpacity(0.1), width: 1),
            ),
            height: 400,
            // child: Image.network(
            //     'http://dal.chi-team.com/api/adds?page%5Bsize%5D=1&page%5Bnumber%5D=1'),
            child: ClipRRect(child: Placeholder()),
          ),
        ),
      ),
    );
  }
}
