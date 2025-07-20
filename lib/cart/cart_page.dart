import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/base/no_data_page.dart';
import 'package:food_delivery/controllers/auth_controller.dart';
import 'package:food_delivery/controllers/cart_controller.dart';
import 'package:food_delivery/controllers/location_controller.dart';
import 'package:food_delivery/controllers/popular_product_controller.dart';
import 'package:food_delivery/controllers/recommended_product_controller.dart';
import 'package:food_delivery/controllers/user_controller.dart';
import 'package:food_delivery/home/main_food_page.dart';
import 'package:food_delivery/route/route_helper.dart';
import 'package:food_delivery/utils/app_constants.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widgets/app_icon.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:food_delivery/widgets/small_text.dart';
import 'package:get/get.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TextEditingController _discountController = TextEditingController();
  bool _isDiscountApplied = false;
  double _discountPercent = 0.0;
  String _discountMessage = '';

  void _applyDiscount() {
    String discountCode = _discountController.text.trim().toLowerCase();

    if (discountCode == 'food') {
      setState(() {
        _isDiscountApplied = true;
        _discountPercent = 0.10; // 10%
        _discountMessage = 'Mã giảm giá đã được áp dụng! Giảm 10%';
      });

      Get.snackbar(
          "Thành công",
          "Mã giảm giá đã được áp dụng!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2)
      );
    } else {
      setState(() {
        _isDiscountApplied = false;
        _discountPercent = 0.0;
        _discountMessage = 'Mã giảm giá không hợp lệ';
      });

      Get.snackbar(
          "Lỗi",
          "Mã giảm giá không hợp lệ!",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 2)
      );
    }
  }

  void _removeDiscount() {
    setState(() {
      _isDiscountApplied = false;
      _discountPercent = 0.0;
      _discountMessage = '';
      _discountController.clear();
    });
  }

  double _calculateFinalAmount(double originalAmount) {
    if (_isDiscountApplied) {
      return originalAmount * (1 - _discountPercent);
    }
    return originalAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Positioned(
                top: Dimensions.height20*3,
                left: Dimensions.width20,
                right: Dimensions.width20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppIcon(icon: Icons.arrow_back_ios,
                      iconColor: Colors.white,
                      backgroundColor: AppColors.mainColor,
                      iconSize: Dimensions.iconSize24,
                    ),
                    SizedBox(width: Dimensions.width20*5,),
                    GestureDetector(
                      onTap: (){
                        Get.toNamed(RouteHelper.getInitial());
                      },
                      child: AppIcon(icon: Icons.home_outlined,
                        iconColor: Colors.white,
                        backgroundColor: AppColors.mainColor,
                        iconSize: Dimensions.iconSize24,
                      ),
                    ),
                    AppIcon(icon: Icons.shopping_cart,
                      iconColor: Colors.white,
                      backgroundColor: AppColors.mainColor,
                      iconSize: Dimensions.iconSize24,
                    ),
                  ],
                )),
            GetBuilder<CartController>(builder: (_cartController){
              return _cartController.getItems.length>0?Positioned(
                  top: Dimensions.height20*5,
                  left: Dimensions.width20,
                  right: Dimensions.width20,
                  bottom: 0,
                  child: Container(
                    margin: EdgeInsets.only(top: Dimensions.height15),
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: GetBuilder<CartController>(builder: (cartController){
                        var _cartList = cartController.getItems;
                        return ListView.builder(
                            itemCount: _cartList.length,
                            itemBuilder: (_, index){
                              return Container(
                                width: double.maxFinite,
                                height: Dimensions.height20*5,
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        var cartProduct = _cartList[index].product!;

                                        var popularIndex = Get.find<PopularProductController>()
                                            .popularProductList
                                            .indexOf(_cartList[index].product!);
                                        if (popularIndex >= 0) {
                                          Get.toNamed(RouteHelper.getPopularFood(popularIndex, "cartpage"));
                                        } else {
                                          var recommendedIndex = Get.find<RecommendedProductController>()
                                              .recommendedProductList
                                              .indexOf(_cartList[index].product!);
                                          if (recommendedIndex < 0) {
                                            Get.snackbar("History Product", "Product review is not available for history product",
                                                backgroundColor: AppColors.mainColor,
                                                colorText: Colors.white
                                            );
                                          }
                                          else{
                                            Get.toNamed(RouteHelper.getRecommendedFood(recommendedIndex, "cartpage"));
                                          }
                                        }
                                      },
                                      child:
                                      Container(
                                        width: Dimensions.height20*5,
                                        height: Dimensions.height20*5,
                                        margin: EdgeInsets.only(bottom: Dimensions.height10),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  AppConstants.BASE_URL+AppConstants.UPLOAD_URL+cartController.getItems[index].img!
                                              )
                                          ),
                                          borderRadius: BorderRadius.circular(Dimensions.radius20),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: Dimensions.width10,),
                                    Expanded(child: Container(
                                      height: Dimensions.height20*5,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          BigText(text: cartController.getItems[index].name!, color: Colors.black54,),
                                          SmallText(text: "Spicy"),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              BigText(text: cartController.getItems[index].price.toString(), color: Colors.redAccent,),
                                              Container(
                                                padding: EdgeInsets.only(top: Dimensions.height10, bottom: Dimensions.height10, left: Dimensions.width10, right: Dimensions.width10),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                                                    color: Colors.white
                                                ),
                                                child: Row(
                                                  children: [
                                                    GestureDetector(
                                                        onTap: (){
                                                          cartController.addItem(_cartList[index].product!, -1);
                                                        },
                                                        child: Icon(Icons.remove, color: AppColors.signColor,)),
                                                    SizedBox(width: Dimensions.width10,),
                                                    BigText(text: _cartList[index].quantity.toString()),
                                                    SizedBox(width: Dimensions.width10,),
                                                    GestureDetector(
                                                        onTap: (){
                                                          cartController.addItem(_cartList[index].product!, 1);
                                                        },
                                                        child: Icon(Icons.add, color: AppColors.signColor,))
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ))
                                  ],
                                ),
                              );
                            });
                      }),
                    ),
                  )):NoDataPage(text: "Your cart is empty!",);
            })
          ],
        ),
        bottomNavigationBar: GetBuilder<CartController>(builder: (cartController){
          double originalAmount = cartController.totalAmount.toDouble();
          double finalAmount = _calculateFinalAmount(originalAmount);

          return Container(
            padding: EdgeInsets.only(top: Dimensions.height15, bottom: Dimensions.height15, left: Dimensions.width20, right: Dimensions.width20),
            decoration: BoxDecoration(
                color: AppColors.buttonBackgroundColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.radius20*2),
                    topRight: Radius.circular(Dimensions.radius20*2)
                )
            ),
            child: cartController.getItems.length>0?
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Discount Code Section
                  Container(
                    margin: EdgeInsets.only(bottom: Dimensions.height10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 40,
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(Dimensions.radius15),
                              border: Border.all(
                                color: _isDiscountApplied ? Colors.green : Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            child: TextField(
                              controller: _discountController,
                              enabled: !_isDiscountApplied,
                              style: TextStyle(fontSize: Dimensions.font16),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Nhập mã giảm giá",
                                hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: Dimensions.font16),
                                contentPadding: EdgeInsets.symmetric(vertical: 8),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: Dimensions.width10),
                        GestureDetector(
                          onTap: _isDiscountApplied ? _removeDiscount : _applyDiscount,
                          child: Container(
                            height: 40,
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.width15),
                            decoration: BoxDecoration(
                              color: _isDiscountApplied ? Colors.red : AppColors.mainColor,
                              borderRadius: BorderRadius.circular(Dimensions.radius15),
                            ),
                            child: Center(
                              child: Text(
                                _isDiscountApplied ? "Hủy" : "Áp dụng",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Dimensions.font16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Discount Message
                  if (_discountMessage.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(bottom: Dimensions.height10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _discountMessage,
                          style: TextStyle(
                            color: _isDiscountApplied ? Colors.green : Colors.red,
                            fontSize: Dimensions.font16,
                          ),
                        ),
                      ),
                    ),

                  // Price and Checkout Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.width15, vertical: Dimensions.height10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radius20),
                            color: Colors.white
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_isDiscountApplied) ...[
                              Row(
                                children: [
                                  Text(
                                    "Tổng: \$ ${originalAmount.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: Dimensions.font16,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "(-${(_discountPercent * 100).toInt()}%)",
                                    style: TextStyle(color: Colors.green, fontSize: Dimensions.font16),
                                  ),
                                ],
                              ),
                              SizedBox(height: 2),
                            ],
                            BigText(
                              text: "\$ ${finalAmount.toStringAsFixed(2)}",
                              color: _isDiscountApplied ? Colors.green : Colors.black,
                              size: Dimensions.font20,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          if(Get.find<AuthController>().userLoggedIn()){
                            if(Get.find<LocationController>().addressList.isEmpty){
                              Get.toNamed(RouteHelper.getAddressPage());
                            }
                            else{
                              int totalAmount = (finalAmount.toInt()*25000);
                              String orderCode = (100 + (DateTime.now().millisecondsSinceEpoch % 900)).toString();
                              String addInfo = "THANH TOAN DON HANG $orderCode";
                              Get.toNamed('/payment', parameters: {
                                'amount': totalAmount.toString(),
                                'info': addInfo,
                              });
                              cartController.addToHistory();
                            }
                          }
                          else{
                            Get.toNamed(RouteHelper.getSignInPage());
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.width20, vertical: Dimensions.height15),
                          child: BigText(text: "Check out", color: Colors.white, size: Dimensions.font16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radius20),
                              color: AppColors.mainColor
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ):Container(),
          );
        },)
    );
  }

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }
}