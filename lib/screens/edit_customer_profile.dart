import 'dart:io';
import 'package:dal/widgets/dropdown_model.dart';
import 'package:dal/business_logic_layer/user_provider.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:dal/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../network/end_points.dart';

class EditCustomerProfileScreen extends StatefulWidget {
  static const routeName = 'EditCustomerProfileScreen';

  @override
  _EditCustomerProfileScreenState createState() =>
      _EditCustomerProfileScreenState();
}

enum AuthMode { Login, SignUp }

class _EditCustomerProfileScreenState extends State<EditCustomerProfileScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey();
  FocusNode _numberFocusNode;
  Dio _dio = Dio();
  List<String> citiesList = [];
  TextEditingController namecontroller;
  TextEditingController phonenumbercontroller;

  ////genders
  List<DropDownListModel> _genders = DropDownListModel.getgender();
  List<DropdownMenuItem<DropDownListModel>> _genderdropDownMenueItems;
  DropDownListModel _selectedgender;

  //customer city
  // List<DropDownListModel> _cities = DropDownListModel.getcities();
  List<DropdownMenuItem<DropDownListModel>> _citiesdropDownMenueItems;
  DropDownListModel _selectedcity;

  File file;
  bool imageselected = true;
  bool loading = false;
  bool pickImage = false;

  Future<bool> _submit(String name, String gender, String cityId,
      String phoneNumber, String imagePath
      //{String name, String email} في حال بدي
      ) async {
    if (!imageselected) {
      Utils.showToast(
        message: 'لم تختر صورة بعد',
        backgroundColor: AppColors.primary,
        textColor: Theme.of(context).textTheme.bodyText1.color,
      );
    } else {
      setState(() {
        loading = true;
      });
      print('tttttttttttttttttttttttttt');
      print(imagePath);
      // imagePath =
      //     '/data/user/0/com.example.dal/cache/file_picker/IMG_20220204_193454.jpg';
      return await Provider.of<UserProvider>(context, listen: false)
          .updateCustomerInfo(
        name,
        gender,
        cityId,
        imagePath,
        phoneNumber,
      );
    }
    return false;
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

  @override
  void initState() {
    final userInfo = Provider.of<UserProvider>(context, listen: false);

    imageselected = userInfo.profileImage.isEmpty ? false : true;
    namecontroller = TextEditingController(text: userInfo.userName);
    phonenumbercontroller = TextEditingController(text: userInfo.phoneNumber);

    _genderdropDownMenueItems =
        DropDownListModel.buildDropDownMenuItem(_genders);
    _selectedgender = userInfo.gender == 'male'
        ? _genderdropDownMenueItems[0].value
        : _genderdropDownMenueItems[1].value;

    // _citiesdropDownMenueItems =
    // DropDownListModel.buildDropDownMenuItem(_cities);
    // _selectedcity = _citiesdropDownMenueItems[0].value;
    getCities();

    super.initState();
  }

  @override
  void dispose() {
    namecontroller?.dispose();
    phonenumbercontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserProvider>(context, listen: false);
    // var provider = Provider.of<SellerProvider>(context, listen: false);
    // print('cheack data');
    // print(_selectedcity.id);
    // print(_selectedgender.name);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context).editProfile,
          // 'تعديل معلومات الحساب',
        ),
        backgroundColor: AppColors.primary,
      ),
      //endDrawer: MyDrawer(),
      body: SingleChildScrollView(
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
                    labelText: AppLocalizations.of(context).name, //'الاسم',
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
                    provider.setName(namecontroller.text);
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
                    provider.setPhoneNumber(
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
                              provider.setGender(_selectedgender.name);
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
                              provider.setCityId(
                                  (citiesList.indexOf(_selectedcity.name) + 1)
                                      .toString());
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

              imageselected == true //&& file != null
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
                            backgroundColor:
                                Theme.of(context).colorScheme.background,
                            backgroundImage: !pickImage
                                ? NetworkImage(
                                    'http://malldal.com/dal/' +
                                        provider.profileImage,
                                  )
                                : FileImage(file),
                            // child: ImageCache(),
                          ),
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
                          maxRadius: 110,
                          backgroundColor: AppColors.primary.withOpacity(0.2),
                          child: Container(
                            child: IconButton(
                              icon: Icon(Icons.add,
                                  color: AppColors.primary, size: 30),
                              onPressed: () {
                                setState(() {
                                  selectImage(context);
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
              //buttons
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: AppColors.accent),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context).editPhoto,
                      // 'إضافة صورة',
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
                  style: ElevatedButton.styleFrom(primary: AppColors.accent),
                  child: Center(
                    child: loading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          )
                        : Text(AppLocalizations.of(context).saveEdit
                            // 'حفظ التعديلات',
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
                      namecontroller.text,
                      _selectedgender.name,
                      _selectedcity.id == 0 ? '1' : _selectedcity.id.toString(),
                      phonenumbercontroller.text,
                      file == null ? '' : file.path,

                      // provider.userName,
                      // provider.gender,
                      // provider.cityId,
                      // provider.phoneNumber.toString(),
                      // provider.profileImage,
                    );
                    if (res) {
                      Utils.showToast(
                        message: AppLocalizations.of(context)
                            .editSuccessfully, //'تم تعديل المعلومات بنجاح',
                        backgroundColor: AppColors.primary,
                        textColor: Theme.of(context).textTheme.bodyText1.color,
                      );
                      setState(() {
                        loading = false;
                        // pickImage = true;
                        // provider.setProfileImage(file.path);
                      });
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          'MainTabBarViewController', (route) => false);
                    } else {
                      Utils.showToast(
                        message: AppLocalizations.of(context)
                            .editError, //'تعذرت عملية تعديل المعلومات',
                        backgroundColor: AppColors.primary,
                        textColor: Theme.of(context).textTheme.bodyText1.color,
                      );
                      setState(() {
                        loading = false;
                        // pickImage = true;
                        // provider.setProfileImage(file.path);
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
    // var provider = Provider.of<UserProvider>(context, listen: false);
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );
    if (result == null) return;
    final path = result.files.single.path;
    // provider.setProfileImage(path);
    // provider.setPickImageTrue();
    print(Provider.of<UserProvider>(context, listen: false).profileImage);
    setState(() {
      file = File(path);
      imageselected = true;
      pickImage = true;
    });
    //طريقة طارق

    // final ByteData imageData =
    //     await NetworkAssetBundle(Uri.parse(path)).load("");
    // final Uint8List bytes = imageData.buffer.asUint8List();
  }

  // Future pickImage(BuildContext context) async {
  //   var provider =
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
