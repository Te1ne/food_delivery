import 'package:food_delivery/API/api_client.dart';
import 'package:food_delivery/controllers/auth_controller.dart';
import 'package:food_delivery/controllers/cart_controller.dart';
import 'package:food_delivery/controllers/location_controller.dart';
import 'package:food_delivery/controllers/popular_product_controller.dart';
import 'package:food_delivery/controllers/recommended_product_controller.dart';
import 'package:food_delivery/controllers/user_controller.dart';
import 'package:food_delivery/repository/auth_repo.dart';
import 'package:food_delivery/repository/cart_repo.dart';
import 'package:food_delivery/repository/location_repo.dart';
import 'package:food_delivery/repository/popular_product_repo.dart';
import 'package:food_delivery/repository/recommended_product_repo.dart';
import 'package:food_delivery/repository/user_repo.dart';
import 'package:food_delivery/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> init() async{
  final sharedPreferences = await SharedPreferences.getInstance();

  Get.lazyPut(()=> sharedPreferences);
  //api client
  Get.lazyPut(()=> ApiClient(appBaseUrl:AppConstants.BASE_URL, sharedPreferences: Get.find()));
  Get.lazyPut(()=> AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(()=> UserRepo(apiClient: Get.find()));

  //repos
  Get.lazyPut(()=>PopularProductRepo(apiClient: Get.find()));
  Get.lazyPut(()=>RecommendedProductRepo(apiClient: Get.find()));
  Get.lazyPut(()=>CartRepo(sharedPreferences:Get.find()));
  Get.lazyPut(()=>LocationRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  //controllers
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => UserController(userRepo: Get.find()));
  Get.lazyPut(()=>PopularProductController(popularProductRepo: Get.find()));
  Get.lazyPut(()=>RecommendedProductController(recommendedProductRepo: Get.find()));
  Get.lazyPut(()=>CartController(cartRepo: Get.find()));
  Get.lazyPut(()=>LocationController(locationRepo: Get.find()));
}