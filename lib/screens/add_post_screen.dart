import 'dart:io';
import 'package:card_swiper/card_swiper.dart';
import 'package:dal/data_layer/data_providers/categories_apis.dart';
import 'package:dal/network/end_points.dart';
import 'package:dal/widgets/dropdown_model.dart';
import 'package:dal/business_logic_layer/user_provider.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:dal/utils/utils.dart';
import 'package:dal/widgets/multi_selected_drop_down.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddPostScreen extends StatefulWidget {
  static const routeName = 'AddPostScreen';
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

enum AuthMode { Login, SignUp }

class _AddPostScreenState extends State<AddPostScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey();
  Dio _dio = Dio();
  FocusNode _numberFocusNode;
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  ////genders
  // List<DropDownListModel> _genders = DropDownListModel.getgender();
  // List<DropdownMenuItem<DropDownListModel>> _genderdropDownMenueItems;
  // DropDownListModel _selectedgender;

  //customer city
  // List<DropDownListModel> _cities = DropDownListModel.getcities();
  List<DropdownMenuItem<DropDownListModel>> _citiesdropDownMenueItems;
  // DropDownListModel _selectedcity;

  //categories
  // List<DropDownListModel> _categories = DropDownListModel.getcities();
  List<DropdownMenuItem<DropDownListModel>> _categorydropDownMenueItems;
  // DropDownListModel _selectedcategory;
  CategoriesAPIs catAPI = CategoriesAPIs();

  List<Asset> images = <Asset>[];
  File file;
  bool imageselected = false;
  bool loading = false;

  List<String> categoryList = [];
  List<String> citiesList = [];

  // CustomMultiselectDropDown testt = CustomMultiselectDropDown(
  //   listOFStrings: [],
  //   isCities: false,
  // );
  // List<File> f = [];
  final ImagePicker imgpicker = ImagePicker();
  List<File> files = [];
  List<String> paths = [];
  Future<bool> _submit(
      {String title,
      String body,
      String priceDetails,
      int sellerId,
      List<String> imagesPath,
      List<int> categories,
      List<int> cities}
      //{String name, String email} في حال بدي
      ) async {
    // if (!imageselected) {
    //   Utils.showToast(
    //     message: 'لم تختر صورة بعد',
    //     backgroundColor: AppColors.primary,
    //     textColor: AppColors.background,
    //   );
    // }
    //  else
    {
      setState(() {
        loading = true;
      });

      Map<String, dynamic> data = {
        'title': title,
        'body': body,
        'priceDetails': priceDetails,
        'seller_id': sellerId,
        'images': imagesPath,
        // 'categories': categories,
        // "cities[0]": "1",
        // "cities[1]": "2",
        // 'cities': c
        // 'cities[0]': cities[1].toString()
      };
      for (int i = 0; i < cities.length; i++) {
        data['cities[$i]'] = cities[i] + 1;
      }
      for (int i = 0; i < categories.length; i++) {
        data['categories[$i]'] = categories[i] + 1;
      }
      print("Sent create Product Data");
      print(data);

      return await Provider.of<UserProvider>(context, listen: false)
          .createPostRequest(data);
    }
  }

  Future<void> getCategories(
      //{String name, String email} في حال بدي
      ) async {
    final response = await _dio.get(EndPoints.getAllCategories(1, 30));
    // if (response == null) {
    //   setState(() {
    //     loading = true;
    //   });
    // }
    if (response.statusCode == 200) {
      setState(() {
        List categories = response.data['data']['data'];
        categories.forEach((element) {
          categoryList.add(element['title']);
        });
        _categorydropDownMenueItems =
            DropDownListModel.buildDropDownMenuItemFromData(
                response.data, false);
        // _selectedcategory = _categorydropDownMenueItems[0].value;
      });
    } else {
      setState(() {
        _categorydropDownMenueItems = null;
      });
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
    if (response.statusCode == 200) {
      setState(() {
        List cities = response.data['data']['data'];
        cities.forEach((element) {
          citiesList.add(element['cityName']);
        });
        _citiesdropDownMenueItems =
            DropDownListModel.buildDropDownMenuItemFromData(
                response.data, true);
        // _selectedcity = _citiesdropDownMenueItems[0].value;
      });
    } else {
      setState(() {
        _citiesdropDownMenueItems = null;
        print(_citiesdropDownMenueItems);
      });
    }
  }

  // CategoriesRepositoryImp _catRepo = CategoriesRepositoryImp();
  // CategoriesRepositoryImp _catRepo = CategoriesRepositoryImp();

  // Future fetchCategories() async {
  //   var result = await _catRepo.getAllCategories();
  //   var jsonData = json.decode(result.body);

  //   setState(() {
  //     data = jsonData;
  //   });
  //   return jsonData;
  // }

  List<int> listOfCities = [];
  List<int> listOfCategories = [];
  @override
  void initState() {
    // _genderdropDownMenueItems =
    //     DropDownListModel.buildDropDownMenuItem(_genders);
    // _selectedgender = _genderdropDownMenueItems[0].value;

    // _citiesdropDownMenueItems =
    //     DropDownListModel.buildDropDownMenuItem(_cities);
    // _selectedcity = _citiesdropDownMenueItems[0].value;

    // _categorydropDownMenueItems =
    //     DropDownListModel.buildDropDownMenuItem(_categories);
    // _selectedcity = _categorydropDownMenueItems[0].value;

    getCategories();
    getCities();
    print(categoryList);
    // testt.listOFStrings = categoryList;
    // _categorydropDownMenueItems =
    //     DropDownListModel.buildDropDownMenuItem(_genders);
    // _selectedcategory = _categorydropDownMenueItems[0].value;
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserProvider>(context, listen: false);
    // var postProvider = Provider.of<PostRequestProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context).addProduct,
          // 'إضافة منتج جديد',
        ),
        backgroundColor: AppColors.primary,
      ),
      //endDrawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              buildEditText(
                  title: AppLocalizations.of(context)
                      .enterProductName, //'أدخل اسم المنتج',
                  subTitle: AppLocalizations.of(context).name, //'الاسم',
                  erorrText: AppLocalizations.of(context)
                      .shortName, //'الاسم قصير جدا',
                  editTextController: titleController,
                  isNumber: false),
              buildEditText(
                  title: AppLocalizations.of(context)
                      .enterProductDetails, //,'أدخل تفاصيل المنتج',
                  subTitle: AppLocalizations.of(context).details, //'التفاصيل',
                  erorrText: AppLocalizations.of(context)
                      .shortText, //'النص  قصير جدا',
                  editTextController: bodyController,
                  isNumber: false),
              buildEditText(
                  title: AppLocalizations.of(context)
                      .enterProductPrice, //'أدخل سعر المنتج',
                  subTitle: AppLocalizations.of(context).price, //'السعر',
                  erorrText: AppLocalizations.of(context)
                      .wrongNumber, //'الرقم غير صحيح',
                  editTextController: priceController,
                  isNumber: true),
              buildDropDownList(
                  title: AppLocalizations.of(context)
                      .chooseProductCategory, //'فئة المنتج',
                  listOfItems: categoryList,
                  func: getCategories,
                  items: _categorydropDownMenueItems,
                  isCities: false),
              buildDropDownList(
                  title: AppLocalizations.of(context)
                      .chooseProductCities, //'المدينة:',
                  listOfItems: citiesList,
                  func: getCities,
                  items: _citiesdropDownMenueItems,
                  isCities: true),
              //gender

              ///
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  AppLocalizations.of(context).canAddProductImages,
                  // 'بإمكانك اختيار صور منتجك هنا:',
                  style: TextStyle(
                    // color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),

              ///
              imageselected == true
                  ? Container(
                      height: MediaQuery.of(context).size.height / 2,
                      child: Swiper(
                        loop: false,
                        itemCount: paths.length == 0 ? 1 : paths.length,
                        pagination: const SwiperPagination(),
                        control: const SwiperControl(),
                        indicatorLayout: PageIndicatorLayout.COLOR,
                        autoplay: false,
                        itemBuilder: (context, index) {
                          if (paths.length != 0) {
                            final path = paths[index];
                            return Stack(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 2,
                                  child: Image.file(
                                    File(path),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Positioned(
                                    top: 10,
                                    right: 15,
                                    child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            paths.remove(path);
                                          });
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              10,
                                          color: AppColors.primary,
                                        )))
                              ],
                            );
                          } else {
                            return Container(
                              color: AppColors.accent,
                              height: MediaQuery.of(context).size.height / 2,
                              child: Center(
                                child: CircleAvatar(
                                    radius:
                                        MediaQuery.of(context).size.width / 6,
                                    backgroundColor: Colors.white70,
                                    child: IconButton(
                                      onPressed: () async {
                                        FilePickerResult result =
                                            await FilePicker.platform.pickFiles(
                                          allowMultiple: true,
                                          type: FileType.custom,
                                          allowedExtensions: [
                                            'jpg',
                                            'png',
                                            'jpeg'
                                          ],
                                        );
                                        if (result != null) {
                                          setState(() {
                                            result.paths.forEach((element) {
                                              if (!paths.contains(element)) {
                                                paths.add(element);
                                              }
                                            });
                                            // paths.addAll(result.paths.toList());
                                            imageselected = true;
                                          });
                                          print(paths);
                                        }
                                      },
                                      icon: Icon(Icons.add),
                                      iconSize:
                                          MediaQuery.of(context).size.width /
                                              10,
                                      color: AppColors.primary,
                                    )),
                              ),
                            );
                          }
                        },
                      ),
                    )
                  // Center(
                  //     child: Container(
                  //       padding: EdgeInsets.all(16),
                  //       width: MediaQuery.of(context).size.width,
                  //       // height: 250,
                  //       margin: EdgeInsets.symmetric(
                  //         horizontal: 1.0,
                  //       ),
                  //       child: CircleAvatar(
                  //         maxRadius: 130,
                  //         backgroundColor: AppColors.primary,
                  //         child: CircleAvatar(
                  //           maxRadius: 125,
                  //           backgroundImage: FileImage(File(paths[0])),
                  //         ),
                  //       ),
                  //     ),
                  //   )
                  : Container(
                      color: AppColors.accent,
                      height: MediaQuery.of(context).size.height / 2,
                      child: Center(
                        child: CircleAvatar(
                            radius: MediaQuery.of(context).size.width / 6,
                            backgroundColor: Colors.white70,
                            child: IconButton(
                              onPressed: () async {
                                FilePickerResult result =
                                    await FilePicker.platform.pickFiles(
                                  allowMultiple: true,
                                  type: FileType.custom,
                                  allowedExtensions: ['jpg', 'png', 'jpeg'],
                                );
                                if (result != null) {
                                  setState(() {
                                    result.paths.forEach((element) {
                                      if (!paths.contains(element)) {
                                        paths.add(element);
                                      }
                                    });
                                    // paths.addAll(result.paths.toList());
                                    imageselected = true;
                                  });
                                  print(paths);
                                }
                              },
                              icon: Icon(Icons.add),
                              iconSize: MediaQuery.of(context).size.width / 10,
                              color: AppColors.primary,
                            )),
                      ),
                    ),
              // : Center(
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
              //               icon: Icon(Icons.add,
              //                   color: AppColors.primary, size: 30),
              //               onPressed: () => {}),
              //         ),
              //       ),
              //     ),
              //   ),
              //buttons
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: AppColors.accent),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context).addPhoto,
                      // 'إضافة صورة',
                    ),
                  ),
                  onPressed: () async {
                    FilePickerResult result =
                        await FilePicker.platform.pickFiles(
                      allowMultiple: true,
                      type: FileType.custom,
                      allowedExtensions: ['jpg', 'png', 'jpeg'],
                    );
                    if (result != null) {
                      setState(() {
                        result.paths.forEach((element) {
                          if (!paths.contains(element)) {
                            paths.add(element);
                          }
                        });
                        // paths.addAll(result.paths.toList());
                        imageselected = true;
                      });
                      print(paths);
                    }
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
                            AppLocalizations.of(context).add,
                            // 'إضافة',
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
                        title: titleController.text,
                        body: bodyController.text,
                        priceDetails: priceController.text,
                        sellerId: provider.userId,
                        categories: listOfCategories,
                        cities: listOfCities,
                        imagesPath: paths);
                    if (res) {
                      Utils.showToast(
                        message: AppLocalizations.of(context).productAdded,
                        backgroundColor: AppColors.primary,
                        textColor: Theme.of(context).textTheme.bodyText1.color,
                      );
                      // Navigator.of(context).pushReplacementNamed(
                      //   SellerAccountScreen.routeName,
                      // );
                      Navigator.of(context).pop();
                    } else {
                      Utils.showToast(
                        message: AppLocalizations.of(context).error,
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

  Widget buildDropDownList(
      {String title,
      List<String> listOfItems,
      Function() func,
      List<DropdownMenuItem<DropDownListModel>> items,
      bool isCities}) {
    print('aaaaaaaaaaaaassssssddddddd');
    print(isCities);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(
              // color: AppColors.primary,
              fontSize: 20,
            ),
          ),
        ),
        items == null
            ? TextButton(
                onPressed: () => func, //func()????
                child: Icon(Icons.refresh),
              )
            : CustomMultiselectDropDown(
                listOFStrings: listOfItems,
                selectedList: isCities ? addCityFunction : addCategoryFunction,
              ),
      ],
    );
  }

  void addCityFunction(List<int> listOfItems) {
    listOfCities = listOfItems;
    print('Cities' + listOfCities.toString());
  }

  void addCategoryFunction(List<int> listOfItems) {
    listOfCategories = listOfItems;
    print('Categories' + listOfCategories.toString());
  }

  Widget buildEditText(
      {String title,
      String subTitle,
      String erorrText,
      TextEditingController editTextController,
      bool isNumber}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            // 'أدخل اسم المنتج',
            style: TextStyle(
              // color: AppColors.primary,
              fontSize: 20,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: editTextController,
            keyboardType: isNumber ? TextInputType.number : TextInputType.name,
            decoration: InputDecoration(
              labelText: subTitle,
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
              if (isNumber) {
                if (value == null || value.isEmpty) {
                  return title;
                }
                if (value.length <= 0) return erorrText;
                return null;
              } else {
                if (value == null || value.isEmpty) {
                  return title;
                }
                if (value.length <= 2) return erorrText;
                return null;
              }
            },
            onSaved: (value) {
              // customerProvider.setName(titleController.text);
            },
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_numberFocusNode);
            },
          ),
        ),
      ],
    );
  }

  Future selectImage(BuildContext context) async {
    var customerProvider = Provider.of<UserProvider>(context, listen: false);
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
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

  // openImages() async {
  //   try {
  //     var pickedfiles = await imgpicker.pickMultiImage();
  //     //you can use ImageCourse.camera for Camera capture
  //     if (pickedfiles != null) {
  //       setState(() {
  //         pickedfiles.forEach((element) {
  //           paths.add(element.path);
  //         });
  //         imageselected = true;
  //         print(paths);
  //       });
  //     } else {
  //       print("No image is selected.");
  //     }
  //   } catch (e) {
  //     print("error while picking file.");
  //   }
  // }

  Future<void> openImages() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(
          takePhotoIcon: "chat",
          doneButtonTitle: "Fatto",
        ),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
      print(error);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    images = resultList;
    // images.forEach((element) async {
    //   // final byteData = await element.getByteData();
    //   File f = await getImageFileFromAssets(element);
    //   files.add(f);
    //   paths.add(f.path);
    //   // paths.add("${(await getTemporaryDirectory()).path}/${ele.name}");
    //   // print(await FlutterAbsolutePath.getAbsolutePath(element.identifier));
    //   // paths
    //   //     .add(await FlutterAbsolutePath.getAbsolutePath(element.identifier));
    // });
    // images.forEach((element) async {
    //   File f = await getImageFileFromAssets(element);
    //   files.add(f);
    //   paths.add(f.path);
    // });
    // print(await FlutterAbsolutePath.getAbsolutePath(images[0].identifier));
    setState(() {
      // paths = [];
      images = resultList;
      // images.forEach((element) async {
      //   // final byteData = await element.getByteData();
      //   File f = await getImageFileFromAssets(element);
      //   files.add(f);
      //   paths.add(f.path);
      //   // paths.add("${(await getTemporaryDirectory()).path}/${ele.name}");
      //   // print(await FlutterAbsolutePath.getAbsolutePath(element.identifier));
      //   // paths
      //   //     .add(await FlutterAbsolutePath.getAbsolutePath(element.identifier));
      // });
      // File f = await getImageFileFromAssets(images[0]);
      // files.add(f);
      // paths.add(f.path);
      // _error = error;
    });
    images.forEach((element) async {
      String path = ("${(await getTemporaryDirectory()).path}/${element.name}");
      File file = File(path);
      if (file.existsSync()) {
        files.add(file);
        paths.add(file.path);
      }
    });
    // paths = await getImagePathFromAssets(images);
    print(images);
    print(paths);
    print(files);
  }

  Future<File> getImageFileFromAssets(Asset asset) async {
    final byteData = await asset.getByteData();

    final tempFile =
        File("${(await getTemporaryDirectory()).path}/${asset.name}");
    final file = await tempFile.writeAsBytes(
      byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );

    return file;
  }

  Future<List<String>> getImagePathFromAssets(List<Asset> assets) async {
    // final byteData = await asset.getByteData();
    List<String> paths = [];
    assets.forEach((element) async {
      String path = ("${(await getTemporaryDirectory()).path}/${element.name}");
      File file = File(path);
      if (file.existsSync()) {
        paths.add(file.path);
      }
    });

    return paths;
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
