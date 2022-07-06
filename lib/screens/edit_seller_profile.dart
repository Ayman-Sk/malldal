import 'dart:io';
import 'package:dal/screens/seller_profile_screen.dart';
import 'package:path/path.dart' as pathLib;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'package:dal/business_logic_layer/seller_provider.dart';
import 'package:dal/widgets/dropdown_model.dart';
import 'package:dal/business_logic_layer/user_provider.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:dal/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/repeater/text_field_repeater.dart';

class EditSellerProfileScreen extends StatefulWidget {
  static const routeName = 'EditSellerProfileScreen';
  final String path;

  const EditSellerProfileScreen({Key key, this.path}) : super(key: key);

  @override
  _EditSellerProfileScreenState createState() =>
      _EditSellerProfileScreenState();
}

// enum AuthMode { Login, SignUp }

class _EditSellerProfileScreenState extends State<EditSellerProfileScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey();
  FocusNode _numberFocusNode;

  TextEditingController namecontroller;
  TextEditingController phonenumbercontroller;
  TextEditingController biocontroller;

  ////genders
  List<DropDownListModel> _genders = DropDownListModel.getgender();
  List<DropdownMenuItem<DropDownListModel>> _genderdropDownMenueItems;
  DropDownListModel _selectedgender;

  //customer city
  // List<DropDownListModel> _cities = DropDownListModel.getcities();
  // List<DropdownMenuItem<DropDownListModel>> _citiesdropDownMenueItems;
  // DropDownListModel _selectedcity;

  File file;
  bool imageselected;
  bool loading = false;
  bool pickImage = false;
  String profileImagePath;

  Future<bool> _submit(
      String name,
      String gender,
      String bio,
      String phoneNumber,
      String imagePath,
      Map<String, List<Map<String, String>>> accountsData
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
      print(name);
      print(gender);
      print(bio);
      print(phoneNumber);

      // imagePath =
      //     '/data/data/com.example.dal/cache/file_picker/IMG_20220603_183254_181.jpg';
      Map<String, dynamic> data = {
        'name': name,
        'gender': gender,
        'bio': bio,
        'profile_image': imagePath,
        'phone': phoneNumber,
      };
      bool res = await Provider.of<UserProvider>(context, listen: false)
          .updateSellerInfo(
        name,
        gender,
        bio,
        imagePath,
        phoneNumber,
        data,
      );
      // bool res2 = await Provider.of<UserProvider>(context, listen: false)
      //     .updateSellerContactinfo(accountsData);
      // return res && res2;
      return res;
    }
    return false;
  }

  List<Icon> icons = [
    Icon(FontAwesomeIcons.phone, color: AppColors.primary),
    Icon(FontAwesomeIcons.whatsapp, color: Color(0xFF25D366)),
    Icon(FontAwesomeIcons.telegram, color: Color(0xFF229ED9)),
    Icon(FontAwesomeIcons.facebook, color: Color(0xFF4267B2)),
    Icon(FontAwesomeIcons.instagram, color: Color(0xFFE1306C))
  ];

  TextFieldRepeater textFieldRepeater;
  @override
  void initState() {
    textFieldRepeater = TextFieldRepeater();
    // textFieldRepeater.clearAllAccounts();
    final userInfo = Provider.of<UserProvider>(context, listen: false);

    imageselected = userInfo.profileImage.isEmpty ? false : true;
    namecontroller = TextEditingController(text: userInfo.userName);
    phonenumbercontroller = TextEditingController(text: userInfo.phoneNumber);
    biocontroller = TextEditingController(text: userInfo.biography);

    _genderdropDownMenueItems =
        DropDownListModel.buildDropDownMenuItem(_genders);
    _selectedgender = userInfo.gender == 'male'
        ? _genderdropDownMenueItems[0].value
        : _genderdropDownMenueItems[1].value;
    file = File(widget.path);

    super.initState();
  }

  @override
  void dispose() {
    namecontroller?.dispose();
    phonenumbercontroller.dispose();
    super.dispose();
  }

  // static List<Icon> icons = [
  //   const Icon(Icons.facebook),
  //   const Icon(Icons.whatsapp),
  //   const Icon(Icons.install_desktop),
  //   const Icon(Icons.telegram)
  // ];

  @override
  Widget build(BuildContext context) {
    // textFieldRepeater = TextFieldRepeater(icons);

    var provider = Provider.of<UserProvider>(context, listen: false);

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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppLocalizations.of(context).contactInfo,
                  // 'معلومات التواصل',
                  style: TextStyle(
                    // color: AppColors.primary,
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: biocontroller,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)
                        .biography, //'السيرة الشخصية',
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
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_numberFocusNode);
                  },
                  validator: (value) {
                    if (value.length > 100) {
                      return AppLocalizations.of(context)
                          .longBio; //'يجب أن تكون السيرة الشخصية مختصرة"';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    provider.setBiography(biocontroller.text);
                  },
                ),
              ),
//////////////////////////////////////////////////////////////////////////////////////////dropdownData////
              ///
              ///
              ///
              ///
              textFieldRepeater.getTexts.isEmpty
                  ? ElevatedButton(
                      onPressed: () {
                        setState(() {
                          textFieldRepeater.addNewAccount();
                        });
                      },
                      child: Text('Add Accounts'),
                      style:
                          ElevatedButton.styleFrom(primary: AppColors.primary),
                    )
                  : textFieldRepeater.repeaterWidgets,
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
                            backgroundColor:
                                Theme.of(context).colorScheme.background,
                            backgroundImage: FileImage(file),
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
                        : Text(
                            AppLocalizations.of(context).saveEdit,
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
                    print('RRRRREPEEATERRRR');
                    print(textFieldRepeater.getDropdownData);
                    // Map data = textFieldRepeater.getDropdownData;
                    // String phone = data[icons[0]].toString();
                    // String whatsapp = data[icons[1]].toString();
                    // String telegram = data[icons[2]].toString();
                    // String facebook = data[icons[3]].toString();
                    // String instagram = data[icons[4]].toString();
                    print('Phone : ' + textFieldRepeater.getPhone);
                    print('Whatsapp : ' + textFieldRepeater.getWhatsapp);
                    print('telegram : ' + textFieldRepeater.getTelegram);
                    print('facebook : ' + textFieldRepeater.getFacebook);
                    print('instagram : ' + textFieldRepeater.getInstagram);
                    // Dio dio = Dio();
                    Map<String, List<Map<String, String>>> contactInfoData =
                        getAccountsMap(
                      textFieldRepeater.getPhone,
                      textFieldRepeater.getWhatsapp,
                      textFieldRepeater.getTelegram,
                      textFieldRepeater.getFacebook,
                      textFieldRepeater.getInstagram,
                      provider.userId,
                    );
                    // var accountsRes;
                    // print(contactInfoData);
                    // accountsRes = await dio.post(EndPoints.contactInfos,
                    //     options: Options(
                    //       headers: {
                    //         'Authorization':
                    //             'Bearer' + CachHelper.getData(key: 'token'),
                    //         'Content-Type': 'application/json',
                    //         'Accept': 'application/json',
                    //       },
                    //     ),
                    //     data: contactInfoData);
                    // print('accountsRes');
                    // print(accountsRes);
                    bool res;
                    res = await _submit(
                        namecontroller.text,
                        _selectedgender.name,
                        biocontroller.text,
                        phonenumbercontroller.text,
                        // provider.userName,
                        // provider.gender,
                        // // provider.cityIdOfCustomer,
                        // provider.biography,
                        // provider.phoneNumber.toString(),
                        file.path,
                        contactInfoData);
                    if (res) {
                      Utils.showToast(
                        message: AppLocalizations.of(context)
                            .editSuccessfully, //'تم تعديل المعلومات بنجاح',
                        backgroundColor: AppColors.primary,
                        textColor: Theme.of(context).textTheme.bodyText1.color,
                      );
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

  Map<String, List<Map<String, String>>> getAccountsMap(
      String phone,
      String whatsapp,
      String telegram,
      String facebook,
      String instagram,
      String sellerId) {
    Map<String, List<Map<String, String>>> data = {};
    List<Map<String, String>> listOfAccounts = [];
    if (phone != 'null') {
      listOfAccounts.add({
        'contact_info_type_id': '1',
        'info': phone,
        'seller_id': sellerId.toString(),
      });
    }
    if (whatsapp != 'null') {
      listOfAccounts.add({
        'contact_info_type_id': '2',
        'info': whatsapp,
        'seller_id': sellerId.toString(),
      });
    }
    if (telegram != 'null') {
      listOfAccounts.add({
        'contact_info_type_id': '3',
        'info': telegram,
        'seller_id': sellerId.toString(),
      });
    }
    if (facebook != 'null') {
      listOfAccounts.add({
        'contact_info_type_id': '4',
        'info': facebook,
        'seller_id': sellerId.toString(),
      });
    }
    if (instagram != 'null') {
      listOfAccounts.add({
        'contact_info_type_id': '5',
        'info': instagram,
        'seller_id': sellerId.toString(),
      });
    }
    data['contactinfos'] = listOfAccounts;
    return data;
  }

  Future selectImage(BuildContext context) async {
    // var provider = Provider.of<SellerProvider>(context, listen: false);
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );
    if (result == null) return;
    final path = result.files.single.path;
    // provider.setImageOfSeller(path);
    print('bllllllla');
    print(Provider.of<SellerProvider>(context, listen: false)
        .getImagePathOfSeller);
    setState(() {
      // provider.setImageOfSeller(path);
      file = File(path);
      print('pathhhhhh');
      print(path);
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
  //       Provider.of<SellerProvider>(context, listen: false);
  //   final pickedFile = await ImagePicker().pickImage(
  //     source: ImageSource.gallery,
  //     imageQuality: 50,
  //   );
  //   setState(() {
  //     file = pickedFile;
  //   });
  // }
}
