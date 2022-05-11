import 'package:dal/network/local_host.dart';
import 'package:flutter/cupertino.dart';

class EndPoints {
  // static final String baseUrl = 'http://dal.chi-team.com/api';
  static final String baseUrl = 'http://malldal.com/dal/api';

  //refresh Token
  static final String refreshToken = baseUrl + '/auth/refresh';
  //Notification

  static String getNotification(int id) =>
      CachHelper.getData(key: 'userMode') == 'customer'
          ? baseUrl + '/publicNotifications/customers/$id'
          : baseUrl + '/publicNotifications/sellers/$id';

  static String getSellerNotification(int id) =>
      baseUrl + '/publicNotifications/sellers/$id';

  static String getCustomerNotification(int id) =>
      baseUrl + '/publicNotifications/customers/$id';
  // Seller
  // //get
  static final String allSellers = baseUrl + '/sellers';

  static final String getAllSellers = allSellers;

  static final String getallMaleSellers =
      allSellers + '?filter[user.gender]=male';

  static final String getallFemaleSellers =
      allSellers + '?filter[user.gender]=female';

  static String getSellerByName(String name) =>
      allSellers + '?filter[user.name]=$name';

  static String getSellerByID(int id) => allSellers + '/$id';

  static String getSellerContactInfosByName(String name) =>
      allSellers + '?filter[user.name]=$name&include=contact_infos';

  // عم ترجعلي كل السيلرات مع كل بوستاتن
  static final String getAllSellersWithAllThemPosts =
      allSellers + '?include=posts';

  static String getSellerPostsByName(String name) =>
      allSellers + '?filter[user.name]=$name&include=posts';

  static String getSellerPostsByID(int id) => allSellers + '/$id?include=posts';

  static final String getSortedSellersByNames = allSellers + '?sort=user.name';

  static final String getSortedSellersByGenders =
      allSellers + '?sort=user.gender';

  //البائعين الجدد
  static final String getSortedSellersByUdating =
      allSellers + '?sort=updated_at';

  //  //delete *** عم يرجعلي غير مصرح
  static String deleteSellerByID(int id) => allSellers + '/$id';

  //  //update *** عم يرجعلي غير مصرح
  static String updateSellerByID(int id) => allSellers + '/$id';

  //customer
  //  //get
  static final String customers = baseUrl + '/customers';

  static final String getAllCustomers = customers;

  static String getcustomerByID(int id) => customers + '/$id';

  // بجبلي البائعين يلي متابعن الزبون
  static String getFollowedSellersByCustomerByID(int id) =>
      customers + '/$id?include=sellers.user';

  // بجبلي الفئات يلي متابعن الزبون
  static String getFollowedCategoriesByCustomerByID(int id) =>
      customers + '/$id?include=categories';

  // بورجيني البوستات المحفوظة تبع الزبون
  //Working
  static String getFollowedPostsOfCustomerByCustomerID(int id) =>
      customers + '/$id?include=posts';

  // static String addCategoryToUserFavorite(int id) =>
  //     customers + '/$id/categories';

  // static String removeCategoryFromUserFavorite(int id, int categoryId) =>
  //     customers + '/$id/categories/$categoryId/';

  /*
    {
    "status": "true",
    "code": 200,
    "message": "succesfully",
    "messageAr": "تم ",
    "data": [
        {
            "id": 1,
            "profile_image": "null",
            "city_id": 5,
            "user_id": 11,
            "verification": 0,
            "deleted_at": null,
            "created_at": "2021-12-20T21:06:56.000000Z",
            "updated_at": "2021-12-20T21:06:56.000000Z",
            "user_count": 1,
            "user": {
                "name": "Rosanna Wuckert",
                "gender": "male",
                "phone": "6040237363"
            },
            "posts": []
        }
    ]
}
    */

  // POST//متابعة فئة
  //وبدك تعطيه بالبودي
  //  "category_id":"1"
  static String addCategoryToCustomerFavList(int id) =>
      customers + '/$id/categories';

  // DELETE//إلغاء متابعة فئة
  // مابتمرقلو شي ابدا
  static String removeCategoryFromCustomerFavList({
    @required int customerId,
    @required int categoryId,
  }) =>
      customers + '/$customerId/categories/$categoryId';

  // POST//متابعة بائع
  //وبدك تعطيه بالبودي
  //  "seller_id":"1"
  static String addSellerToCustomerFavList(int id) =>
      customers + '/$id/sellers';

  // DELETE//إلغاء متابعة فئة
  // مابتمرقلو شي ابدا
  static String removeSellerFromCustomerFavList({
    @required int customerId,
    @required int sellerId,
  }) =>
      customers + '/$customerId/sellers/$sellerId';

  // POST//متابعة بوست
  //وبدك تعطيه بالبودي
  //  "post_id":"1"
  // ////Working
  static String addPostToCustomerFavList({int customerId}) =>
      customers + '/$customerId/posts';

  // DELETE//إلغاء متابعة فئة
  // مابتمرقلو شي ابدا
  static String removePostFromCustomerFavList({
    @required int customerId,
    @required int postId,
  }) =>
      customers + '/$customerId/posts/$postId';

  //create customer DOOONE
  static final String customerSignUp = baseUrl + '/customers';
  static final String userLogin = baseUrl + '/auth';
  // static String saveFcmToken(int id) => baseUrl + '/auth/saveFcm/$id';

  // static String saveSellerFcmToken(int id) =>
  //     baseUrl + '/auth/saveFcm/customers/$id';

  // static String saveCustomerFcmToken(int id) =>
  //     baseUrl + '/auth/saveFcm/sellers/$id';

  static String saveFcmToken(int id) =>
      CachHelper.getData(key: 'userMode') == 'customer'
          ? baseUrl + '/auth/saveFcm/customers/$id'
          : baseUrl + '/auth/saveFcm/sellers/$id';

  // static final String customerLogin = baseUrl + '/auth';
  //update customer *** عم يرجعلي غير مصرح
  //بدك تمرقلو
  // name gender city_id profile_image phone ومو شرط كلن
  static String updateCustomer(int id) => customers + '/$id';

  //delete customer *** عم يرجعلي غير مصرح
  static String deleteCustomer(int id) => customers + '/$id';

  ////////////////////////////////////////////////////////////////// users Done

  //posts
  //  //get
  static final String posts = baseUrl + '/posts';

  /////// DONEEEEEEEEE
  static final String getAllPostsWithSeller = posts + '?include=seller';

  /////// Working
  static String getSinglePostById(int id) => posts + '/$id';

  ////// DONEEEEEEEEE
  static String getPostsByTitle(String name) => posts + '?filter[title]=$name';

//ترجعلي بوستات السيلر الفلاني
  static String getPostsBySellerID(int id, int pageNumber, int pageSize) =>
      posts +
      '?page[number]=$pageNumber&page[size]=$pageSize&filter[seller_id]=$id';

  // جبلي كل البوستات مع التقييمات تبعاتن data =[]
  static String getPostReviewsBySellerID(int id) =>
      posts + '?filter[seller_id]=$id&include=reviews';

  // جبلي كل البوستات مع المنتجات data =[]
  static String getPostProductsBySellerID(int id) =>
      posts + '?filter[seller_id]=$id&include=products';

  // جبلي كل البوستات مع الفئات تبعاتنdata =[]
  static String getPostCategoriesBySellerID(int id) =>
      posts + '?filter[seller_id]=$id&include=categories';

  // data =[]
  static String getPostSellesBySellerID(int id) =>
      posts + '?filter[seller_id]=$id&include=seller';

  //  جبلي كل البوستات مع السيلرات يلي نشرتن ///Working On ...
  static String getPostRequestBySellerID(
          int id, int pageNumber, int pageSize) =>
      baseUrl +
      '/post_requests?page[number]=$pageNumber&page[size]=$pageSize&filter[seller_id]=$id';

  // static String getAllPostsIncudeCategories = posts + '?include=categories';
  static String getAllPostsIncudeCategories(
          int pageNumber, int pageSize, String search) =>
      posts +
      '?page[number]=$pageNumber&filter[title]=$search&include=categories&page[size]=$pageSize';

  // '?page[number]=$pageNumber&include=categories&page[size]=$pageSize';

  static String addPostRequest(int id) => baseUrl + '/post_requests';

  static final String getAllPostsWithAllThemSellers = posts + '?include=seller';
  static final String test = 'http://dal.chi-team.com/api/posts?include=seller';

  static String getPostByID(int id) => posts + '/$id';

  // POST//إضافة بوست الى فئة
  //وبدك تعطيه بالبودي
  //  "category_id":"1"
  static String addPostToCategoryList(int postId) =>
      posts + '/$postId/categories';

  // DELETE//إزالة بوست من فئة
  // مابتمرقلو شي ابدا
  static String removePostFromCategoryList({
    @required int categoryId,
    @required int postId,
  }) =>
      posts + '/$postId/$categoryId';

  //وبتمرقلو
  //title body seller_id priceDetails products[0][title] products[0][descreption] products[0][priceDetails] products[0][image]
  static final String createPost = posts;

  //  Update
  //وبتمرقلو
  //title body seller_id priceDetails products[0][title] products[0][descreption] products[0][priceDetails] products[0][image]
  static String updatePost(int postID) => posts + '/$postID';

  //DELETE
  static String deletePost(int postID) => posts + '/$postID';

  ////////////////////////////////////////////////////////////////// posts Done

  //  categorys
  static final String categorys = baseUrl + '/categorys';

  /// DOOOONE
  static String getAllCategories(int pageNumber, int pageSize) =>
      categorys + '?page[number]=$pageNumber&page[size]=$pageSize';

  static String getCategoryByName(String name) =>
      categorys + '?filter[title]=$name';

  static String getCategoryByID(int catID) => categorys + '/$catID';

  // static String getPostsByCategoryId(int catId) =>
  //     categorys + '/$catId?include=posts';

  static String getPostsByCategoryId(int catId, int pageNumber, int pageSize) =>
      posts + '/category/$catId?page[number]=$pageNumber&page[size]=$pageSize';

  static String getPostsByCategoryIdAndCityID(
          int categoryId, int cityId, int pageNumber, int pageSize) =>
      posts +
      '/category/$categoryId/city/$cityId?page[number]=$pageNumber&page[size]=$pageSize';

  ////////////////////////////////////////////////////////////////// categorys Done

  // Cities

  static final String getAllCities = baseUrl + '/cities';

  ///////////////////////////////////////////////////////////////////

  //reviews

  static final String reviews = baseUrl + '/reviews';

  // جبلي تقييمات بوست حسب رقمو
  static String getAllReviewsOfSinglePostByID(int postID) =>
      reviews + '?filter[post_id]=$postID';

  // جبلي تقييمات هاد الزبون
  static String getAllReviewsDoneByCustomerFromHisID(int postID) =>
      reviews + '?filter[customer_id]=$postID';

  static String getOneReviewByID(int revID) => reviews + '/$revID';

  //POST
  //المفروض وقت اعمل تقييم لبوست مرقلو رقم البوست وملاحظات عالبوست
  //{
  //     "rate":"3",
  //      "notes":"vsjdkl",
  //       "post_id":"1",
  //       "customer_id":"3"
  // }
  static final String createReview = reviews;

  //POST
  //Form Data : rate notes post_id customer_id
  static String updateReviewByID(int revID) => reviews + '/$revID';

  static String deleteReviewByID(int revID) => reviews + '/$revID';

  ////////////////////////////////////////////////////////////////// categorys Done

  //  adds
  static final String adds = baseUrl + '/adds';

  // جبلي كل الاعلانات
  static String getAllAdds(int pageSize, int pageNumber) =>
      adds + '?page[size]=$pageSize&page[number]=$pageNumber';

  // جبلي الاعلانات حسب الاهمية المختارة
  static String getAddsByImportantID(int addID) =>
      adds + '?filter[important]=$addID';

  // جبلي اعلان عن طريق رقمو
  static String getAddByID(int addID) => adds + '/$addID';

  //POST
  // تعيين اعلان ك مهم عن طريق رقمو
  static String makeOneAddImportantByItsID(int addID) =>
      adds + '/$addID/important';

  ////////////////////////////////////////////////////////////////// Adds Done

  //  contact_infos
  static final String contactInfos = baseUrl + '/contact_infos';

  // جبلي كل معلومات التواصل
  static final String getAllContactInfos = contactInfos;

  static String getSellerContactInfo(int id) => contactInfos + "/$id/byseller";

  // جبلي كل معلومات تواصل هادالبائع
  static String getAllContactInfoOfSellerByID(int sellerId) =>
      contactInfos + '?filter[seller_id]=$sellerId';

  /// ؟؟؟؟؟؟
  static String getAllContactInfoOfSellerByTypeID(int sellerId) =>
      contactInfos + '?filter[type]=$sellerId';

  // شو بستفيد اذا بمرقلو contact_info ك رقم هون شو برجعلي ؟؟؟
  static String getContactInfosOfSellerBySellerID({
    @required int sellerId,
    @required int contactinfoID,
  }) =>
      contactInfos + '/$contactinfoID?filter[seller_id]=$sellerId';

  //POST
  // {
  //   "type":"title",
  //   "info":"this is my contact information",
  //   "seller_id":"1"
  // }
  // create contact Info For Seller
  static final String createContactInfosForSeller = contactInfos;

  //POST
  //UPDATE CONTACT
  // {
  //   "type":"title1",
  //   "info":"this is my contact information",
  //   "seller_id":"1",
  //   "__methode":"put"
  // }
  static String updateSingleContactInfoByItsID(int contactInfosID) =>
      contactInfos + '/$contactInfosID';

  //DELETE
  static String deleteSingleContactInfoByItsID(int contactInfosID) =>
      contactInfos + '/$contactInfosID';

////////////////////////////////////////////////////////////////// contact_infos Done
// static final String T = 'http://dal.chi-team.com/api';
}
