import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/controllers/cart_controller.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:get/get.dart';

import '../utils/colors.dart';
import '../widgets/big_text.dart';
import '../widgets/small_text.dart';

class OrderSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Success Icon
            Container(
              width: Dimensions.height45*3,
              height: Dimensions.height45*3,
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: Dimensions.height45*2,
              ),
            ),

            SizedBox(height: Dimensions.height45),

            BigText(
              text: "Thanh toán thành công!",
              size: Dimensions.font26,
              color: AppColors.mainColor,
            ),

            SizedBox(height: Dimensions.height20),

            SmallText(
              text: "Đơn hàng của bạn đã được xử lý thành công",
              color: Colors.grey,
            ),
            SmallText(
              text: "Chúng tôi sẽ liên hệ với bạn sớm nhất",
              color: Colors.grey,
            ),

            SizedBox(height: Dimensions.height45*2),

            // Về trang chủ button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width20*2),
              child: Container(
                width: double.maxFinite,
                height: Dimensions.height20*3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  color: AppColors.mainColor,
                ),
                child: TextButton(
                  onPressed: () {
                    Get.find<CartController>().clear();
                    Get.offAllNamed('/');
                  },
                  child: BigText(
                    text: "Về trang chủ",
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            SizedBox(height: Dimensions.height20),

            // Đặt hàng tiếp button
            TextButton(
              onPressed: () {
                Get.find<CartController>().clear();
                Get.offAllNamed('/');
              },
              child: SmallText(
                text: "Tiếp tục mua sắm",
                color: AppColors.mainColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}