import 'package:dal/business_logic_layer/user_provider.dart';
import 'package:dal/data_layer/models/seller_model.dart';
import 'package:dal/screens/seller_posts_screen.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CustomerSellerFollower extends StatefulWidget {
  static final routeName = 'CustomerSellerFollower';
  const CustomerSellerFollower({Key key}) : super(key: key);

  @override
  State<CustomerSellerFollower> createState() => _CustomerSellerFollowerState();
}

class _CustomerSellerFollowerState extends State<CustomerSellerFollower> {
  int currentPage = 1;
  int pageNumber = 2;
  List<Seller> displayedSellers = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    Map<String, dynamic> followersData = {};

    Future<bool> getFollowerData({
      bool refreshed = false,
    }) async {
      followersData = await userProvider
          .getFollowedSellersByCustomerID(userProvider.userId);
      print(followersData);
      if (followersData == null) {
        return false;
      } else {
        followersData['data'][0]['sellers'].forEach(
          (element) {
            setState(() {
              if(refreshed)
                {
                  displayedSellers =[];
                  displayedSellers.add(Seller.fromJson(element));
                }
              else{
                displayedSellers.add(Seller.fromJson(element));
              }
            });
          },
        );
        return true;
      }
    }

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(AppLocalizations.of(context).followed),
          backgroundColor: AppColors.primary),
      body: SmartRefresher(
        footer: const ClassicFooter(loadStyle: LoadStyle.ShowWhenLoading),
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropMaterialHeader(
          backgroundColor: AppColors.primary,
        ),
        onRefresh: () async {
          var widget = await getFollowerData(refreshed: true);
          if (widget != null) {
            userProvider.index = -1;
            setState(() {
              currentPage++;
            });
            _refreshController.refreshCompleted();
          } else {
            _refreshController.refreshFailed();
          }
        },
        onLoading: () {
          var widget = getFollowerData();
          print(widget.toString());
          if (widget == null) {
            print('no data under');
            _refreshController.loadNoData();
          }
          if (widget != null) {
            setState(() {
              currentPage++;
            });
            _refreshController.loadComplete();
          }
        },
        child: ListView.builder(
            itemCount: displayedSellers.length,
            itemBuilder: (_, index) {
              return GestureDetector(
                child: listViewItem(displayedSellers[index], context),
                onTap: () => Navigator.of(context)
                    .pushNamed(SellerPostScreen.routeName, arguments: {
                  'userId': displayedSellers[index].id,
                  'isRequest': false
                }),
              );
            }),
      ),
    );
  }
}

Widget listViewItem(Seller seller, BuildContext context) {
  return ListTile(
    leading: CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.background,
      backgroundImage:
          NetworkImage('http://malldal.com/dal/' + seller.profileImage),
    ),
    //TODO
    //wait alissar to add name
    title: Text(seller.bio),
  );
}
