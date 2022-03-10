import 'package:dal/business_logic_layer/user_provider.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:dal/widgets/center_title_widget.dart';
import 'package:dal/widgets/myDrawer.dart';
import 'package:dal/widgets/post_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SellerPostScreen extends StatefulWidget {
  static const routeName = 'SellerPostScreen';

  @override
  State<SellerPostScreen> createState() => _SellerPostScreenState();
}

class _SellerPostScreenState extends State<SellerPostScreen> {
  // bool isRequest = false;
  @override
  Widget build(BuildContext context) {
    var sellerProvider = Provider.of<UserProvider>(context, listen: false);
    final isRequest = ModalRoute.of(context).settings.arguments as bool;
    sellerProvider.getSellerPossts(isRequest);
    Future<bool> _myData = sellerProvider.getSellerPossts(isRequest);
    return Scaffold(
      // backgroundColor: AppColors.background,
      drawer: MyDrawer(),
      appBar: AppBar(
          backgroundColor: AppColors.primary,
          leading: IconButton(
              onPressed: Navigator.of(context).pop,
              icon: Icon(Icons.arrow_back_sharp))),
      body: FutureBuilder(
        future: sellerProvider.getSellerPossts(isRequest),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            );
          else if (snapshot.hasData) {
            // print('000000000000000000000');
            // print(sellerProvider.posts[0]);
            print(snapshot.data);
            if (snapshot.data == false) {
              return Center(
                child: IconButton(
                  icon: Icon(
                    Icons.restart_alt_outlined,
                    size: MediaQuery.of(context).size.width / 10,
                    color: AppColors.primary,
                  ),
                  onPressed: () {
                    setState(() {
                      _myData = sellerProvider.getSellerPossts(isRequest);
                    });
                  },
                ),
              );
            }
            return ListView.builder(
              itemCount: isRequest
                  ? sellerProvider.postRequest.length
                  : sellerProvider.posts.length,
              itemBuilder: (context, index) {
                var item = isRequest
                    ? sellerProvider.postRequest[index]
                    : sellerProvider.posts[index];

                List<String> paths = [];
                item.postImages.forEach((element) {
                  paths.add('http://malldal.com/dal/' + element['url']);
                });
                return PostItem(
                  postId: item.id,
                  nameOfSeller: item.seller.user.name,
                  createdAt: item.seller.createdAt,
                  title: item.title,
                  body: item.body,
                  priceDetails: item.priceDetails,
                  avgRate: item.avgRate,
                  ownerUser: item.seller,
                  price: item.priceDetails,
                  paths: paths,
                );
              },
            );
          } else if (snapshot.hasError) {
            return CenterTitleWidget(
              title: 'حصل خطأ في التحميل',
              iconData: Icons.error,
            );
          }
          return Container();
        },
      ),

      // ListView.builder(
      //   itemCount:
      //       sellerProvider.posts == null ? 0 : sellerProvider.posts.length,
      //   itemBuilder: (context, index) {
      //     var item = sellerProvider.posts[index];
      //     return PostItem(
      //       postId: item.id,
      //       nameOfSeller: item.seller.user.name,
      //       createdAt: item.seller.createdAt,
      //       title: item.title,
      //       body: item.body,
      //       priceDetails: item.priceDetails,
      //       avgRate: item.avgRate,
      //     );
      //   },
      // ),
    );
  }
}
