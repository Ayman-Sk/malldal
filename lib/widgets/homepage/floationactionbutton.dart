// import 'package:dal/models/post_model.dart';
// import 'package:dal/models/user.dart';
// import 'package:dal/providers/post_provider.dart';
// import 'package:dal/providers/seller_provider.dart';
// import 'package:dal/screens/home_page_screen.dart';
// import 'package:dal/theme/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// class FloatingActionButtonWidget extends StatefulWidget {
//   const FloatingActionButtonWidget({
//     Key key,
//   }) : super(key: key);

//   @override
//   _FloatingActionButtonWidgetState createState() =>
//       _FloatingActionButtonWidgetState();
// }

// class _FloatingActionButtonWidgetState
//     extends State<FloatingActionButtonWidget> {
//   final GlobalKey<FormState> _formkey = GlobalKey();
//   TextEditingController titlecontroller = TextEditingController();
//   TextEditingController descriptioncontroller = TextEditingController();
//   TextEditingController pricecontroller = TextEditingController();
//   TextEditingController citiescontroller = TextEditingController();
//   FocusNode desFocusNode;
//   FocusNode priceFocusNode;
//   FocusNode citiesFocusNode;

//   @override
//   void dispose() {
//     titlecontroller.dispose();
//     descriptioncontroller.dispose();
//     pricecontroller.dispose();
//     citiescontroller.dispose();
//     super.dispose();
//   }

//   void onSave() {
//     if (!_formkey.currentState.validate()) {
//       return;
//     }
//     _formkey.currentState.save();
    
//   }
//   @override
//   Widget build(BuildContext context) {
//     // var postProvider = Provider.of<PostProvider>(context, listen: false);
//     var sellerProvider = Provider.of<SellerProvider>(context, listen: false);
//     return FloatingActionButton(
//       backgroundColor: AppColors.accent,


//       onPressed: () {
//         // postProvider.setNameOfCreator();
//         // postProvider.setTypeOfCreator(
//         //     sellerProvider.userMode == UserMode.seller ? 'بائع' : 'زبون');
//         showModalBottomSheet(
//           context: context,
//           builder: (context) {
//             return SingleChildScrollView(
//               child: Form(
//                 key: _formkey,
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Center(
//                         child: Text(
//                           "شاركنا منتجاتك",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 20,
//                             color: AppColors.accent,
//                           ),
//                         ),
//                       ),
//                     ),
//                     //عنوان المنتج
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Directionality(
//                         textDirection: TextDirection.rtl,
//                         child: TextFormField(
//                           controller: titlecontroller,
//                           keyboardType: TextInputType.name,
//                           decoration: InputDecoration(
//                             labelText: 'عنوان المنتج',
//                             labelStyle: TextStyle(color: AppColors.primary),
//                             fillColor: Colors.white,
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10.0),
//                               borderSide: BorderSide(
//                                 color: AppColors.primary,
//                               ),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10.0),
//                               borderSide: BorderSide(
//                                 color: AppColors.primary,
//                                 width: 2.0,
//                               ),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'أدخل عنوان مناسب';
//                             }
//                             return null;
//                           },
//                           onSaved: (value) {
//                             // newPost.title = titlecontroller.text;
//                             // postProvider.setTitleOfPost(titlecontroller.text);
//                           },
//                           onFieldSubmitted: (_) {
//                             FocusScope.of(context).requestFocus(desFocusNode);
//                             // FocusScope.of(context).requestFocus(FocusNode());
//                           },
//                         ),
//                       ),
//                     ),

//                     ///وصف المنتج
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Directionality(
//                         textDirection: TextDirection.rtl,
//                         child: TextFormField(
//                           controller: descriptioncontroller,
//                           keyboardType: TextInputType.name,
//                           decoration: InputDecoration(
//                             labelText: 'وصف المنتج',
//                             labelStyle: TextStyle(color: AppColors.primary),
//                             fillColor: Colors.white,
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10.0),
//                               borderSide: BorderSide(
//                                 color: AppColors.primary,
//                               ),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10.0),
//                               borderSide: BorderSide(
//                                 color: AppColors.primary,
//                                 width: 2.0,
//                               ),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value.length > 100) {
//                               return 'يجب أن يكون الوصف مختصر"';
//                             }
//                             return null;
//                           },
//                           onSaved: (value) {
//                             // newPost.body = descriptioncontroller.text;
//                             // postProvider
//                             //     .setBodyOfPost(descriptioncontroller.text);
//                           },
//                           focusNode: desFocusNode,
//                           onFieldSubmitted: (_) {
//                             FocusScope.of(context).requestFocus(priceFocusNode);

//                             // FocusScope.of(context).requestFocus(FocusNode());
//                           },
//                         ),
//                       ),
//                     ),

//                     /////سعر المنتج
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Directionality(
//                         textDirection: TextDirection.rtl,
//                         child: TextFormField(
//                           controller: pricecontroller,
//                           keyboardType: TextInputType.number,
//                           decoration: InputDecoration(
//                             labelText: 'سعر المنتج',
//                             labelStyle: TextStyle(color: AppColors.primary),
//                             fillColor: Colors.white,
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10.0),
//                               borderSide: BorderSide(
//                                 color: AppColors.primary,
//                               ),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10.0),
//                               borderSide: BorderSide(
//                                 color: AppColors.primary,
//                                 width: 2.0,
//                               ),
//                             ),
//                           ),
//                           focusNode: priceFocusNode,
//                           onFieldSubmitted: (_) {
//                             FocusScope.of(context)
//                                 .requestFocus(citiesFocusNode);
//                           },
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'أدخل السعر ';
//                             }
//                             return null;
//                           },
//                           onSaved: (value) {
//                             // newPost.priceDetail = int.tryParse(pricecontroller.text);
//                             // postProvider.setPriceDetailOfPost(
//                             //     int.tryParse(pricecontroller.text));
//                           },
//                         ),
//                       ),
//                     ),
//                     ////citiescontroller
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Directionality(
//                         textDirection: TextDirection.rtl,
//                         child: TextFormField(
//                           controller: citiescontroller,
//                           keyboardType: TextInputType.name,
//                           decoration: InputDecoration(
//                             labelText: 'المدن الحالية',
//                             labelStyle: TextStyle(color: AppColors.primary),
//                             fillColor: Colors.white,
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10.0),
//                               borderSide: BorderSide(
//                                 color: AppColors.primary,
//                               ),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10.0),
//                               borderSide: BorderSide(
//                                 color: AppColors.primary,
//                                 width: 2.0,
//                               ),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value.length > 100) {
//                               return 'يجب أن يكون النص مختصر';
//                             }
//                             return null;
//                           },
//                           onSaved: (value) {
//                             // newPost.cities =citiescontroller.text;
//                             // postProvider.setCitiesOfPost(citiescontroller.text);
//                           },
//                           focusNode: citiesFocusNode,
//                         ),
//                       ),
//                     ),

//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: ElevatedButton(
//                         style:
//                             ElevatedButton.styleFrom(primary: AppColors.accent),
//                         child: Center(
//                           // child: loading
//                           //     ? CircularProgressIndicator(
//                           //         valueColor: AlwaysStoppedAnimation<Color>(
//                           //           AppColors.primary,
//                           //         ),
//                           //       )
//                           //     :
//                           child: Text(
//                             'إنشاء المنشور',
//                           ),
//                         ),
//                         onPressed: () {
//                           onSave();
//                           sellerProvider.addNewPostToSellerPosts(
//                             Post(
//                               nameofCreator: sellerProvider.getNameOfSeller,
//                               typeOfCreator: sellerProvider.userMode == UserMode.seller ? 'بائع' : 'زبون',
//                               title: titlecontroller.text,
//                               body: descriptioncontroller.text,
//                               priceDetail: int.tryParse(pricecontroller.text),
//                               cities: citiescontroller.text,
//                               avgRate: 0,
//                             ),
//                           );
//                           sellerProvider.printSeller();
//                           showToast(context);
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );

//         ///
//       },
//       child: Center(
//         child: Icon(
//           Icons.add,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }

// void showToast(BuildContext context) {
//   Fluttertoast.showToast(
//       msg: "تم إنشاء المنشور",
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 2,
//       backgroundColor: AppColors.primary,
//       textColor: AppColors.background,
//       fontSize: 16.0);
//   Navigator.of(context).pushReplacementNamed(HomePageScreen.routeName);
// }
