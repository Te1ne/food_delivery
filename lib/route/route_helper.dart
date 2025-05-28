import 'package:food_delivery/address/add_address_page.dart';
import 'package:food_delivery/auth/sign_in_page.dart';
import 'package:food_delivery/cart/cart_page.dart';
import 'package:food_delivery/food/popular_food_detail.dart';
import 'package:food_delivery/food/recommended_food_detail.dart';
import 'package:food_delivery/home/home_page.dart';
import 'package:food_delivery/home/main_food_page.dart';
import 'package:food_delivery/models/order_model.dart';
import 'package:food_delivery/splash/splash_page.dart';
import 'package:get/get.dart';

class RouteHelper{
  static const String splashPage = "/splash-page";
  static const String initial = "/";
  static const String popularFood = "/popular-food";
  static const String recommendedFood = "/recommended-food";
  static const String cartPage = "/cart-page";
  static const String signIn = "/sign-in";
  static const String addAddress = "/add-address";
  static const String payment = '/payment';
  static const String orderSuccess = '/order-successful';



  static String getSplashPage()=> '$splashPage';
  static String getInitial()=>'$initial';
  static String getPopularFood(int pageId, String page)=> '$popularFood?pageId=$pageId&page=$page';
  static String getRecommendedFood(int pageId, String page)=> '$recommendedFood?pageId=$pageId&page=$page';
  static String getCartPage()=>'$cartPage';
  static String getSignInPage()=>'$signIn';
  static String getAddressPage()=>'$addAddress';
  static String getPaymentPay()=>'$payment';
  static String getOrderSuccessPage()=>'$orderSuccess';

  static List<GetPage> routes = [
    GetPage(name: splashPage, page: ()=>SplashScreen()),

    GetPage(name: initial, page: (){
      return HomePage();
    }, transition: Transition.fade),

    GetPage(name: signIn, page: (){
      return SignInPage();
    },
    transition: Transition.fade
    ),

    GetPage(name: popularFood, page: (){
      var pageId = Get.parameters['pageId'];
      var page = Get.parameters["page"];
      return PopularFoodDetail(pageId: int.parse(pageId!), page:page!);
    },
          transition: Transition.fadeIn
    ),
    GetPage(name: recommendedFood, page: (){
      var pageId = Get.parameters['pageId'];
      var page = Get.parameters["page"];
      return RecommendedFoodDetail(pageId: int.parse(pageId!), page:page!);
    },
        transition: Transition.fadeIn
    ),

    GetPage(name: cartPage, page: (){
      return CartPage();
    },
      transition: Transition.fadeIn
    ),
    
    GetPage(name: addAddress, page: (){
      return AddAddressPage();
    }),


    //GetPage(name: orderSuccess, page: ()=>)
  ];

}