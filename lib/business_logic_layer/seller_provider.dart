import 'package:dal/data_layer/models/post_with_sellers_model.dart';
import 'package:dal/data_layer/models/user_model.dart';
import 'package:flutter/cupertino.dart';

class SellerProvider with ChangeNotifier {
  int id;
  String name;
  String number;
  String gender = 'ذكر';
  String biography;
  String numbers;
  String contactInfo;
  String imagePath;
  UserMode userMode = UserMode.seller;
  List<PostsWithSellerModel> postsOfSeller = [];
  // PostModel(
  // dataofresponse:
  //       dataofresponse.content[index].seller.user.name:
  //       dataofresponse.content[index].seller.createdAt,
  //       dataofresponse.content[index].title,
  //       dataofresponse.content[index].body,
  //       dataofresponse.content[index].priceDetails,
  //       dataofresponse.content[index].avgRate,

  //     sellerName: '2عمران',
  //     title: 'بوست افتراضي',
  //     body:
  //         'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخرى إضافة إلى زيادة عدد الحروف التى يولدها التطبي إذا كنت تحتاج إلى عدد أكبر من الفقرات يتيح لك مولد النص العربى زيادة عدد الفقرات كما تريد، النص لن يبدو مقسما ولا يحوي أخطاء لغوية، مولد النص العربى مفيد لمصممي المواقع على وجه الخصوص، حيث يحتاج العميل فى كثير من الأحيان أن يطلع على صورة حقيقية لتصميم الموقعومن هنا وجب على المصمم أن يضع نصوصا مؤقتة على التصميم ليظهر للعميل الشكل كاملاً،دور مولد النص العربى أن يوفر على المصمم عناء البحث عن نص بديل لا علاقة له بالموضوع الذى يتحدث عنه التصميم فيظهر بشكل لا يليقهذا النص يمكن أن يتم تركيبه على أي تصميم دون مشكلة فلن يبدو وكأنه نص منسوخ، غير منظم، غير منسق، أو حتى غير مفهوم. لأنه مازال نصاً بديلاً ومؤ',
  //     priceDetails: "5000",
  //     createdAt: DateTime.now().toString(),
  //   ),
  //   PostModel(
  //     sellerName: '2عمران',
  //     title: 'بوست افتراضي',
  //     body:
  //         'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخرى إضافة إلى زيادة عدد الحروف التى يولدها التطبي إذا كنت تحتاج إلى عدد أكبر من الفقرات يتيح لك مولد النص العربى زيادة عدد الفقرات كما تريد، النص لن يبدو مقسما ولا يحوي أخطاء لغوية، مولد النص العربى مفيد لمصممي المواقع على وجه الخصوص، حيث يحتاج العميل فى كثير من الأحيان أن يطلع على صورة حقيقية لتصميم الموقعومن هنا وجب على المصمم أن يضع نصوصا مؤقتة على التصميم ليظهر للعميل الشكل كاملاً،دور مولد النص العربى أن يوفر على المصمم عناء البحث عن نص بديل لا علاقة له بالموضوع الذى يتحدث عنه التصميم فيظهر بشكل لا يليقهذا النص يمكن أن يتم تركيبه على أي تصميم دون مشكلة فلن يبدو وكأنه نص منسوخ، غير منظم، غير منسق، أو حتى غير مفهوم. لأنه مازال نصاً بديلاً ومؤ',
  //     priceDetails: "5000",
  //     createdAt: DateTime.now().toString(),
  //   ),
  //   PostModel(
  //     sellerName: '2عمران',
  //     title: 'بوست افتراضي',
  //     body:
  //         'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخرى إضافة إلى زيادة عدد الحروف التى يولدها التطبي إذا كنت تحتاج إلى عدد أكبر من الفقرات يتيح لك مولد النص العربى زيادة عدد الفقرات كما تريد، النص لن يبدو مقسما ولا يحوي أخطاء لغوية، مولد النص العربى مفيد لمصممي المواقع على وجه الخصوص، حيث يحتاج العميل فى كثير من الأحيان أن يطلع على صورة حقيقية لتصميم الموقعومن هنا وجب على المصمم أن يضع نصوصا مؤقتة على التصميم ليظهر للعميل الشكل كاملاً،دور مولد النص العربى أن يوفر على المصمم عناء البحث عن نص بديل لا علاقة له بالموضوع الذى يتحدث عنه التصميم فيظهر بشكل لا يليقهذا النص يمكن أن يتم تركيبه على أي تصميم دون مشكلة فلن يبدو وكأنه نص منسوخ، غير منظم، غير منسق، أو حتى غير مفهوم. لأنه مازال نصاً بديلاً ومؤ',
  //     priceDetails: "5000",
  //     createdAt: DateTime.now().toString(),
  //   ),
  // ];

  //set
  void setNameOfSeller(String value) {
    name = value;
    notifyListeners();
  }

  void setNumberOfSeller(String value) {
    number = value;
    notifyListeners();
  }

  void setGenderOfSeller(String value) {
    gender = value;
    notifyListeners();
  }

  void setBiographyOfSeller(String value) {
    biography = value;
    notifyListeners();
  }

  void setNumbersOfSeller(String value) {
    numbers = value;
    notifyListeners();
  }

  void setContactInfoOfSeller(String value) {
    contactInfo = value;
    notifyListeners();
  }

  void setImageOfSeller(String value) {
    imagePath = value;
    notifyListeners();
  }

  void addNewPostToSellerPosts(PostsWithSellerModel post) {
    postsOfSeller.add(post);
    notifyListeners();
  }

  //get
  String get getNameOfSeller => name;
  String get getNumberOfSeller => number;
  String get getGenderOfSeller => gender;
  String get getBiographyOfSeller => biography;
  String get getNumbersOfSeller => numbers;
  String get getContactInfoOfSeller => contactInfo;
  String get getImagePathOfSeller => imagePath;
  String get getUserMode => 'Seller';
  // String get cityOfSeller =>

  List<PostsWithSellerModel> get getPostsOfSeller => postsOfSeller;

  // User user;
  // void setUser() {
  //   user = User(
  //     name: getNameOfSeller,
  //     phoneNumber: getNumberOfSeller,
  //     gender: getGenderOfSeller,
  //     biography: getBiographyOfSeller,
  //     numbers: getNumbersOfSeller,
  //     contactInfo: getContactInfoOfSeller,
  //     image: getImagePathOfSeller,
  //     userMode: userMode,
  //     posts: getPostsOfSeller,
  //   );
  // }

  // void printSeller() {
  //   print(
  //     'User {Name : ${user.name}\nPhoneNumber : ${user.phoneNumber}\nGender : ${user.gender}\nBiography : ${user.biography}\nMore Numbers : ${user.numbers}\nContact Info : ${user.contactInfo}\nImage : ${user.image}\nMode : $userMode}}',
  //   );
  //   //print('Post Number in user is ${user.post.length}');
  //   print('Post Number of seller  is ${postsOfSeller.length}');
  // }
  // Future<bool> updateSellerInfo(
  //   String name,
  //   String gender,
  //   String imagePath,
  //   String phoneNumber,
  // ) async {
  //   try {
  //     print('seeeeend iddddd');
  //     print(id);
  //     dynamic response = await DioHelper.updateUserData(
  //       url: EndPoints.updateSellerByID(id),
  //       isFormData: true,
  //       lang: 'en',
  //       data: {
  //         'name': name,
  //         'gender': gender,
  //         'profile_image': imagePath,
  //         'phone': phoneNumber,
  //       },
  //     );
  //     print(id);
  //     print('\nResponse : ${response.data}\n');
  //     if (response.data['data'] != null) {
  //       int userId = response.data['data'][0]['id'];
  //       print('\nuser Id : $userId\n');
  //       CachHelper.saveData(key: 'userId', value: userId);
  //       return true;
  //     } else {
  //       print('***\nError In Update\n***');
  //       return false;
  //     }
  //   } catch (e) {
  //     print('register error is $e');
  //     return Future.value(false);
  //   }
  // }
}
