import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// App Title
  ///
  /// In en, this message translates to:
  /// **'Dal'**
  String get title;

  /// User Number When Login
  ///
  /// In en, this message translates to:
  /// **'Enter Your Number'**
  String get enterNumber;

  /// Login Button
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get logIn;

  /// Signup Button
  ///
  /// In en, this message translates to:
  /// **'Signup'**
  String get signup;

  /// Guest Login Button
  ///
  /// In en, this message translates to:
  /// **'Login As Guest'**
  String get guest;

  /// No description provided for @personlNumber.
  ///
  /// In en, this message translates to:
  /// **'Personal Number'**
  String get personlNumber;

  /// When Enter Wrong Number
  ///
  /// In en, this message translates to:
  /// **'Enter Valid Number'**
  String get validNumber;

  /// When User Logedin In To App
  ///
  /// In en, this message translates to:
  /// **'You Are Now Registered In The App'**
  String get logedin;

  /// When Login Process Refused
  ///
  /// In en, this message translates to:
  /// **'Unable To Login'**
  String get loginRefused;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'Post Rating '**
  String get rate;

  /// when user want To add review and rate to post in Popup Window
  ///
  /// In en, this message translates to:
  /// **'Your Rating and Feedback'**
  String get rateReview;

  /// When user add new Rate
  ///
  /// In en, this message translates to:
  /// **'New Rate :'**
  String get newRate;

  /// Cancel buttoun in review and rating
  ///
  /// In en, this message translates to:
  /// **'Cancle'**
  String get cancel;

  /// Send button in review and rating
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// when user add review
  ///
  /// In en, this message translates to:
  /// **'Review Has Been Added'**
  String get reviewAdded;

  /// when review is refused
  ///
  /// In en, this message translates to:
  /// **'Review Could Not Be Added'**
  String get reviewRefused;

  /// When User add Post to Favorite :: Click Hert Button
  ///
  /// In en, this message translates to:
  /// **'Has Been Added To Favorite'**
  String get postFavorite;

  /// When User remove Post From Favorite :: Click Heart Buttom
  ///
  /// In en, this message translates to:
  /// **'Has Been Removed From Favorite'**
  String get removePost;

  /// When Error Occurred While Saving The Post
  ///
  /// In en, this message translates to:
  /// **'Something Went Wrong'**
  String get favoriteRefused;

  /// When Guest User Want To Add Post to Favorite
  ///
  /// In en, this message translates to:
  /// **'You Must Be Registered In The Application'**
  String get unregistered;

  /// When Customer want to follow Seller
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get follow;

  /// When Customer User Unfollow Seller User
  ///
  /// In en, this message translates to:
  /// **'Unfollow'**
  String get unfollow;

  /// back Button
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Post Body
  ///
  /// In en, this message translates to:
  /// **'Seller Contact Information'**
  String get sellerContactInfo;

  /// When Gest User Want to see seller contact Info
  ///
  /// In en, this message translates to:
  /// **'You Must Be Logged In To See The Seller Contact Information'**
  String get notAllowedSeeSellerInfo;

  /// Home Page Tab
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homePage;

  /// Favorite Page Tab
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favoritePage;

  /// Category Page Tab
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryPage;

  /// Profile page Tab
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profilePage;

  /// Go to Home PAge From Drawer
  ///
  /// In en, this message translates to:
  /// **'Home Page'**
  String get homePageScreen;

  /// logout
  ///
  /// In en, this message translates to:
  /// **'logout'**
  String get logout;

  /// setting Screen from Drawer
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get setting;

  /// City Filter Element
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// Category Filter Element
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// Buttoun to Delete User Acccount
  ///
  /// In en, this message translates to:
  /// **'Delete My Account'**
  String get deleteAccount;

  /// when user want to edit his profile
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// user profile Account Info
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInfo;

  /// User Name
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// User gender
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// User Gender is male
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// User Gender is female
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// User Account Type
  ///
  /// In en, this message translates to:
  /// **'Account Type'**
  String get accountType;

  /// User Type is Customer
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// User Type is Seller
  ///
  /// In en, this message translates to:
  /// **'Seller'**
  String get seller;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile Information'**
  String get editProfile;

  /// When User Want to input his Name
  ///
  /// In en, this message translates to:
  /// **'Enter Your Name'**
  String get enterName;

  /// When user input short name
  ///
  /// In en, this message translates to:
  /// **'The Name Is Too Short'**
  String get shortName;

  /// when user want to input his phone number
  ///
  /// In en, this message translates to:
  /// **'Enter Your Phone Number'**
  String get enterPhoneNumber;

  /// when user input wrong number
  ///
  /// In en, this message translates to:
  /// **'The Number Is Incorrect'**
  String get wrongNumber;

  /// title when user eant to choose his photo
  ///
  /// In en, this message translates to:
  /// **'You Can Choose Your Photo From Here'**
  String get canChooseImage;

  /// when user want add his photo
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addPhoto;

  /// When user want to add new photo
  ///
  /// In en, this message translates to:
  /// **'Add Another Photo'**
  String get addAnotherPhoto;

  /// When User want to save Edit
  ///
  /// In en, this message translates to:
  /// **'Save Edits'**
  String get saveEdit;

  /// whn response of edit profile screen is true
  ///
  /// In en, this message translates to:
  /// **'The Information Has Been Successfully modified'**
  String get editSuccessfully;

  /// When response of edit profile screen is fasle
  ///
  /// In en, this message translates to:
  /// **'The Information Could Not Be modified'**
  String get editError;

  /// Contacct Information Of Seller
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInfo;

  /// title of introduction Screen
  ///
  /// In en, this message translates to:
  /// **'Simple steps separate you from seeing the latest home-made products or displaying your personal products, all through the Dal Electronic Mall'**
  String get introTitle;

  /// No description provided for @letStart.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Get Started'**
  String get letStart;

  /// Screen Title when user want to signup
  ///
  /// In en, this message translates to:
  /// **'Create A New Account'**
  String get createAccount;

  /// When response of create account screen is true
  ///
  /// In en, this message translates to:
  /// **'Account Successfully Created'**
  String get signedUpSuccessfully;

  /// When response of create account screen is fasle
  ///
  /// In en, this message translates to:
  /// **'Unable To Create Account'**
  String get signedUpError;

  /// Button To see Seller Posts
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get posts;

  /// Button to see seller pending Posts
  ///
  /// In en, this message translates to:
  /// **'Pending Posts'**
  String get pendingPosts;

  /// Button to add new Product
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get addProduct;

  /// seller biography
  ///
  /// In en, this message translates to:
  /// **'Biography'**
  String get biography;

  /// When User add too long Bio
  ///
  /// In en, this message translates to:
  /// **'Biography Should Be Brief'**
  String get longBio;

  /// Title of Add new Post Screen
  ///
  /// In en, this message translates to:
  /// **'Add New Product'**
  String get addNewProduct;

  /// No description provided for @enterProductName.
  ///
  /// In en, this message translates to:
  /// **'Enter The Product Name'**
  String get enterProductName;

  /// when User want to add product details
  ///
  /// In en, this message translates to:
  /// **'Enter Product Details'**
  String get enterProductDetails;

  /// new Product details
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @shortText.
  ///
  /// In en, this message translates to:
  /// **'The Text Is Too Short'**
  String get shortText;

  /// when User want to add Product Price
  ///
  /// In en, this message translates to:
  /// **'Enter Product Price'**
  String get enterProductPrice;

  /// Product Price
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// When user want to add Product Category
  ///
  /// In en, this message translates to:
  /// **'Choose Product Categories'**
  String get chooseProductCategory;

  /// what is the cities where the Ptoduct is served
  ///
  /// In en, this message translates to:
  /// **'Choose Cities Where Your Product Is Served'**
  String get chooseProductCities;

  /// title to choos product images
  ///
  /// In en, this message translates to:
  /// **'You Can Choose Your Product Images From Here'**
  String get canAddProductImages;

  /// To add new Product
  ///
  /// In en, this message translates to:
  /// **'add'**
  String get add;

  /// App Lang
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Phrase Under Logo
  ///
  /// In en, this message translates to:
  /// **'Dal Electronic Mall'**
  String get dalPhrase;

  /// App Theme
  ///
  /// In en, this message translates to:
  /// **'App Theme'**
  String get theme;

  /// error in load Data
  ///
  /// In en, this message translates to:
  /// **'Something Went Wrong'**
  String get error;

  /// When return Empty Posts List
  ///
  /// In en, this message translates to:
  /// **'There Are No Products'**
  String get empty;

  /// When search return Empty List
  ///
  /// In en, this message translates to:
  /// **'There Are No Items With This Name'**
  String get emptyPostsSearch;

  /// When User Add Category to Saved Category
  ///
  /// In en, this message translates to:
  /// **'Category Saved'**
  String get saveCategory;

  /// When User Remove Category From Saved Category
  ///
  /// In en, this message translates to:
  /// **'Category Removed'**
  String get removeCategory;

  /// When User open his account this text will shown on button
  ///
  /// In en, this message translates to:
  /// **'Followed'**
  String get followed;

  /// Empty List for saved Posts
  ///
  /// In en, this message translates to:
  /// **'There Are No Posts Saved'**
  String get emptySavedPosts;

  /// When User want to rate Post
  ///
  /// In en, this message translates to:
  /// **'This Item Is Important'**
  String get importantItem;

  /// When Seller send New Post Requser
  ///
  /// In en, this message translates to:
  /// **' Product added successfully '**
  String get productAdded;

  /// contact number text in Popup Window
  ///
  /// In en, this message translates to:
  /// **'Contact Number'**
  String get contactNumber;

  /// additional Information text in popup Window
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get additionalInformation;

  /// Title of popup filter window
  ///
  /// In en, this message translates to:
  /// **'Choose To Filter Posts'**
  String get filterText;

  /// submit button Text
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// popup window when log out
  ///
  /// In en, this message translates to:
  /// **'Are You Sure You Want To Log Out?'**
  String get areYouSure;

  /// popup window when delete
  ///
  /// In en, this message translates to:
  /// **'Are You Sure You Want To Delete The Account?'**
  String get areYouSureDelete;

  /// When there is no notification
  ///
  /// In en, this message translates to:
  /// **'There are no notificans'**
  String get emptyNotification;

  /// Title of Edit Product Screen
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get editProduct;

  /// Edit User Photo
  ///
  /// In en, this message translates to:
  /// **'Edit Photo'**
  String get editPhoto;

  /// Customer Login
  ///
  /// In en, this message translates to:
  /// **'Login With Facebook'**
  String get loginWithFacebook;

  /// Email
  ///
  /// In en, this message translates to:
  /// **'email'**
  String get email;

  /// No description provided for @loginAsCustomer.
  ///
  /// In en, this message translates to:
  /// **'Login As Customer'**
  String get loginAsCustomer;

  /// No description provided for @loginAsSeller.
  ///
  /// In en, this message translates to:
  /// **'Login As Seller'**
  String get loginAsSeller;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete?'**
  String get delete;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
