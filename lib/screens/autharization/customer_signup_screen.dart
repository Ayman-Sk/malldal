import 'dart:io';
import 'package:dal/network/end_points.dart';
import 'package:dal/screens/autharization/login_card_screen.dart';
import 'package:dal/widgets/dropdown_model.dart';
import 'package:dal/business_logic_layer/user_provider.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:dal/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomerSignupScreens extends StatefulWidget {
  static const routeName = 'CustomerSignupScreens';
  @override
  _CustomerSignupScreensState createState() => _CustomerSignupScreensState();
}

enum AuthMode { Login, SignUp }

class _CustomerSignupScreensState extends State<CustomerSignupScreens> {
  final GlobalKey<FormState> _formkey = GlobalKey();
  FocusNode _numberFocusNode;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController phonenumbercontroller = TextEditingController();

  ////genders
  List<DropDownListModel> _genders = DropDownListModel.getgender();
  List<DropdownMenuItem<DropDownListModel>> _genderdropDownMenueItems;
  DropDownListModel _selectedgender;

  //customer city
  List<DropDownListModel> _cities = DropDownListModel.getcities();
  List<DropdownMenuItem<DropDownListModel>> _citiesdropDownMenueItems;
  DropDownListModel _selectedcity;

  File file;
  bool imageselected = false;
  bool loading = false;
  List<String> citiesList = [];
  Dio _dio = Dio();

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('img/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  Future<bool> _submit(String name, String gender, int cityId,
      String phoneNumber, String imagePath) async {
    {
      setState(() {
        loading = true;
      });
      {
        return await Provider.of<UserProvider>(context, listen: false).register(
          name,
          gender,
          cityId,
          imagePath,
          phoneNumber,
        );
      }
    }
  }

  Future<void> getCities(
      //{String name, String email} في حال بدي
      ) async {
    final response = await _dio.get(EndPoints.getAllCities);

    // if (response == null) {
    //   setState(() {
    //     loading = true;
    //   });
    // }
    if (response.statusCode == 200 && response.data != null) {
      setState(() {
        print('citiiiiiies');
        List cities = response.data['data']['data'];
        cities.forEach((element) {
          citiesList.add(element['cityName']);
        });
        _citiesdropDownMenueItems =
            DropDownListModel.buildDropDownMenuItemFromData(
                response.data, true);
        _selectedcity = _citiesdropDownMenueItems[0].value;
      });
    } else {
      setState(() {
        _citiesdropDownMenueItems = null;
        print(_citiesdropDownMenueItems);
      });
    }
  }

  bool waiting = true;

  @override
  void initState() {
    _genderdropDownMenueItems =
        DropDownListModel.buildDropDownMenuItem(_genders);
    _selectedgender = _genderdropDownMenueItems[0].value;

    _citiesdropDownMenueItems =
        DropDownListModel.buildDropDownMenuItem(_cities);
    _selectedcity = _citiesdropDownMenueItems[0].value;

    getImageFileFromAssets('user.jpg').then((value) => file = value);

    getCities().then((value) => waiting = false);
    super.initState();
  }

  @override
  void dispose() {
    namecontroller.dispose();
    phonenumbercontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var customerProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context).createAccount,
          // 'إنشاء حساب جديد',
        ),
        backgroundColor: AppColors.primary,
      ),
      //endDrawer: MyDrawer(),
      body: waiting
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AppLocalizations.of(context).enterName,
                        // ' أدخل اسمك:',
                        style: TextStyle(
                          // color: AppColors.primary,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: namecontroller,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context).name, //'الاسم',
                          labelStyle: TextStyle(color: AppColors.primary),
                          fillColor: Colors.white,
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)
                                .enterName; //'أدخل الاسم';
                          }
                          if (value.length <= 2)
                            return AppLocalizations.of(context)
                                .shortName; //'الاسم قصير جدا"';
                          return null;
                        },
                        onSaved: (value) {
                          customerProvider.setName(namecontroller.text);
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_numberFocusNode);
                        },
                      ),
                    ),
                    //number
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AppLocalizations.of(context).enterNumber,
                        // 'أدخل رقمك:',
                        style: TextStyle(
                          // color: AppColors.primary,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: phonenumbercontroller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)
                              .phoneNumber, //'الرقم الشخصي',
                          labelStyle: TextStyle(color: AppColors.primary),
                          fillColor: Colors.white,
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)
                                .enterNumber; //'أدخل الرقم الشخصي';
                          }
                          if (value.length != 10)
                            return AppLocalizations.of(context)
                                .wrongNumber; //'الرقم غير صحيح';
                          return null;
                        },
                        focusNode: _numberFocusNode,
                        onSaved: (value) {
                          customerProvider.setPhoneNumber(
                            phonenumbercontroller.text,
                          );
                        },
                      ),
                    ),
                    //gender
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AppLocalizations.of(context).gender,
                        // 'الجنس:',
                        style: TextStyle(
                          // color: AppColors.primary,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton(
                              underline: Divider(
                                thickness: 2,
                                color: AppColors.primary,
                              ),
                              isExpanded: true,
                              value: _selectedgender,
                              items: _genderdropDownMenueItems,
                              onChanged: (val) {
                                setState(
                                  () {
                                    _selectedgender = val;
                                    customerProvider
                                        .setGender(_selectedgender.name);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    //city
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AppLocalizations.of(context).city,
                        // 'المدينة:',
                        style: TextStyle(
                          // color: AppColors.primary,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton(
                              underline: Divider(
                                thickness: 2,
                                color: AppColors.primary,
                              ),
                              isExpanded: true,
                              value: _selectedcity,
                              items: _citiesdropDownMenueItems,
                              onChanged: (val) {
                                setState(
                                  () {
                                    _selectedcity = val;
                                    customerProvider
                                        .setCityId(_selectedcity.id);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),

                    ///
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        AppLocalizations.of(context).canChooseImage,
                        // 'بإمكانك اختيار صورتك من هنا:',
                        style: TextStyle(
                          // color: AppColors.primary,
                          fontSize: 20,
                        ),
                      ),
                    ),

                    ///
                    imageselected == true
                        ? Center(
                            child: Container(
                              padding: EdgeInsets.all(16),
                              width: MediaQuery.of(context).size.width,
                              // height: 250,
                              margin: EdgeInsets.symmetric(
                                horizontal: 1.0,
                              ),
                              child: CircleAvatar(
                                maxRadius: 130,
                                backgroundColor: AppColors.primary,
                                child: CircleAvatar(
                                  maxRadius: 125,
                                  backgroundImage: FileImage(file),
                                ),
                              ),
                            ),
                          )
                        : file == null
                            ? Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primary,
                                  ),
                                ),
                              )
                            : Center(
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  width: MediaQuery.of(context).size.width,
                                  // height: 250,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 1.0,
                                  ),
                                  child: CircleAvatar(
                                    maxRadius: 130,
                                    backgroundColor: AppColors.primary,
                                    child: CircleAvatar(
                                      maxRadius: 125,
                                      backgroundImage: FileImage(file),
                                    ),
                                  ),
                                ),
                              ),
                    //  Center(
                    //     child: Container(
                    //       padding: EdgeInsets.all(16),
                    //       width: MediaQuery.of(context).size.width,
                    //       // height: 250,
                    //       margin: EdgeInsets.symmetric(
                    //         horizontal: 1.0,
                    //       ),
                    //       child: CircleAvatar(
                    //           maxRadius: 130,
                    //           backgroundColor: AppColors.primary,
                    //           child: Container(
                    //             margin: EdgeInsets.all(10),
                    //             child: ClipRRect(
                    //                 borderRadius:
                    //                     BorderRadius.circular(150),
                    //                 child: Image.asset('img/user.jpg')),
                    //           )
                    //           // CircleAvatar(
                    //           //   maxRadius: 125,
                    //           //   backgroundImage: Image.asset('img/test.jpg'),
                    //           // ),
                    //           ),
                    //     ),
                    //   ),
                    /////////////////////////////////////////
                    //  Center(
                    //     child: Container(
                    //       padding: EdgeInsets.all(16),
                    //       width: MediaQuery.of(context).size.width,
                    //       // height: 250,
                    //       margin: EdgeInsets.symmetric(
                    //         horizontal: 1.0,
                    //       ),
                    //       child: CircleAvatar(
                    //         maxRadius: 110,
                    //         backgroundColor: AppColors.primary.withOpacity(0.2),
                    //         child: Container(
                    //           child: IconButton(
                    //             icon: Icon(Icons.add,
                    //                 color: AppColors.primary, size: 30),
                    //             onPressed: () {
                    //               setState(() {
                    //                 selectImage(context);
                    //               });
                    //             },
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    //buttons
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(primary: AppColors.accent),
                        child: Center(
                          child: Text(
                            // 'إضافة صورة',
                            AppLocalizations.of(context).addPhoto,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            selectImage(context);
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(primary: AppColors.accent),
                        child: Center(
                          child: loading
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primary,
                                  ),
                                )
                              : Text(
                                  // 'تسجيل الدخول',
                                  AppLocalizations.of(context).signup,
                                ),
                        ),
                        onPressed: () async {
                          if (!_formkey.currentState.validate()) {
                            setState(() {
                              loading = false;
                            });
                            return Future.value(false);
                          }
                          _formkey.currentState.save();
                          bool res;
                          res = await _submit(
                            customerProvider.user.name,
                            customerProvider.user.gender,
                            customerProvider.user.cityId,
                            customerProvider.user.phoneNumber.toString(),
                            file == null ? '' : file.path,
                            // AuthMode.SignUp,
                          );
                          if (res) {
                            Utils.showToast(
                              message: AppLocalizations.of(context)
                                  .signedUpSuccessfully, //'تم إنشاء الحساب بنجاح',
                              backgroundColor: AppColors.primary,
                              textColor:
                                  Theme.of(context).textTheme.bodyText1.color,
                            );
                            Navigator.of(context).pushReplacementNamed(
                              LoginCardScreen.routeName,
                            );
                          } else {
                            Utils.showToast(
                              message: AppLocalizations.of(context)
                                  .signedUpError, //'تعذرت عملية إنشاء الحساب',
                              backgroundColor: AppColors.primary,
                              textColor:
                                  Theme.of(context).textTheme.bodyText1.color,
                            );
                            setState(() {
                              loading = false;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future selectImage(BuildContext context) async {
    var customerProvider = Provider.of<UserProvider>(context, listen: false);
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );
    if (result == null) return;
    final path = result.files.single.path;
    customerProvider.setProfileImage(path);
    print(path);
    setState(() {
      file = File(path);
      imageselected = true;
    });
    //طريقة طارق

    // final ByteData imageData =
    //     await NetworkAssetBundle(Uri.parse(path)).load("");
    // final Uint8List bytes = imageData.buffer.asUint8List();
  }

  // Future pickImage(BuildContext context) async {
  //   var customerProvider =
  //       Provider.of<CustomerProvider>(context, listen: false);
  //   final pickedFile = await ImagePicker().pickImage(
  //     source: ImageSource.gallery,
  //     imageQuality: 50,
  //   );
  //   setState(() {
  //     file = pickedFile;
  //   });
  // }
}
