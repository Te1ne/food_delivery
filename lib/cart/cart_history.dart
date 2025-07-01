import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_delivery/base/no_data_page.dart';
import 'package:food_delivery/controllers/cart_controller.dart';
import 'package:food_delivery/models/cart_model.dart';
import 'package:food_delivery/route/route_helper.dart';
import 'package:food_delivery/utils/app_constants.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widgets/app_icon.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:food_delivery/widgets/small_text.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CartHistory extends StatefulWidget {
  const CartHistory({super.key});

  @override
  State<CartHistory> createState() => _CartHistoryState();
}

class _CartHistoryState extends State<CartHistory> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    var getCartHistoryList = Get.find<CartController>()
        .getCartHistoryList().reversed.toList();

    Map<String, int> cartItemsPerOrder = {};
    for (int i = 0; i < getCartHistoryList.length; i++) {
      if (cartItemsPerOrder.containsKey(getCartHistoryList[i].time)) {
        cartItemsPerOrder.update(getCartHistoryList[i].time!, (value) => ++value);
      } else {
        cartItemsPerOrder.putIfAbsent(getCartHistoryList[i].time!, () => 1);
      }
    }

    List<int> itemsPerOrder = cartItemsPerOrder.values.toList();
    List<String> orderTimes = cartItemsPerOrder.keys.toList();

    // Lọc theo ngày chọn
    List<int> filteredItemsPerOrder = [];
    List<String> filteredOrderTimes = [];

    for (int i = 0; i < orderTimes.length; i++) {
      DateTime parsedDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(orderTimes[i]);
      if (_selectedDate == null ||
          (parsedDate.year == _selectedDate!.year &&
              parsedDate.month == _selectedDate!.month &&
              parsedDate.day == _selectedDate!.day)) {
        filteredItemsPerOrder.add(itemsPerOrder[i]);
        filteredOrderTimes.add(orderTimes[i]);
      }
    }

    Widget timeWidget(String timeString) {
      DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(timeString);
      var outputDate = DateFormat("MM/dd/yyyy hh:mm a").format(parseDate);
      return BigText(text: outputDate);
    }

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: Dimensions.height10 * 10,
            color: AppColors.mainColor,
            width: double.maxFinite,
            padding: EdgeInsets.only(top: Dimensions.height45),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BigText(text: "Cart History", color: Colors.white),
                AppIcon(
                  icon: Icons.shopping_cart_outlined,
                  backgroundColor: AppColors.yellowColor,
                  iconColor: AppColors.mainColor,
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width20, vertical: Dimensions.height10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BigText(text: "Tìm kiếm theo ngày", color: AppColors.mainBlackColor,),
                ElevatedButton.icon(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    }
                  },
                  icon: Icon(Icons.calendar_today),
                  label: Text(_selectedDate != null
                      ? DateFormat('MM/dd/yyyy').format(_selectedDate!)
                      : 'Chọn ngày'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainColor,
                      foregroundColor: Colors.white),
                ),
                if (_selectedDate != null)
                  IconButton(
                    icon: Icon(Icons.clear, color: AppColors.mainColor),
                    onPressed: () {
                      setState(() {
                        _selectedDate = null;
                      });
                    },
                  )
              ],
            ),
          ),
          GetBuilder<CartController>(builder: (_cartController) {
            var cartLength = _cartController.getCartHistoryList();
            return cartLength.length > 0
                ? Expanded(
              child: Container(
                margin: EdgeInsets.only(
                    top: Dimensions.height10,
                    left: Dimensions.width20,
                    right: Dimensions.width20),
                child: MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: ListView.builder(
                    itemCount: filteredItemsPerOrder.length,
                    itemBuilder: (_, i) {
                      int listCounter = 0;
                      return Container(
                        margin:
                        EdgeInsets.only(bottom: Dimensions.height20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            timeWidget(filteredOrderTimes[i]),
                            SizedBox(height: Dimensions.height10),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Wrap(
                                  children: List.generate(
                                      filteredItemsPerOrder[i], (index) {
                                    if (listCounter <
                                        getCartHistoryList.length) {
                                      listCounter++;
                                    }
                                    return index <= 2
                                        ? Container(
                                      height:
                                      Dimensions.height20 * 4,
                                      width:
                                      Dimensions.height20 * 4,
                                      margin: EdgeInsets.only(
                                          right:
                                          Dimensions.width10 /
                                              2),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(
                                            Dimensions.radius15 /
                                                2),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              AppConstants.BASE_URL +
                                                  AppConstants
                                                      .UPLOAD_URL +
                                                  getCartHistoryList[
                                                  listCounter -
                                                      1]
                                                      .img!),
                                        ),
                                      ),
                                    )
                                        : Container();
                                  }),
                                ),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.end,
                                  children: [
                                    SmallText(
                                        text: "Total",
                                        color: AppColors.titleColor),
                                    BigText(
                                      text:
                                      "${filteredItemsPerOrder[i]} Items",
                                      color: AppColors.titleColor,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Map<int, CartModel> moreOrder = {};
                                        for (var item
                                        in getCartHistoryList) {
                                          if (item.time ==
                                              filteredOrderTimes[i]) {
                                            moreOrder.putIfAbsent(
                                                item.id!,
                                                    () => CartModel.fromJson(
                                                    jsonDecode(jsonEncode(
                                                        item))));
                                          }
                                        }
                                        Get.find<CartController>()
                                            .setItems = moreOrder;
                                        Get.find<CartController>()
                                            .addToCartList();
                                        Get.toNamed(
                                            RouteHelper.getCartPage());
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                            Dimensions.width10,
                                            vertical:
                                            Dimensions.height10 / 2),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(
                                              Dimensions.radius15 / 3),
                                          border: Border.all(
                                              width: 1,
                                              color: AppColors.mainColor),
                                        ),
                                        child: SmallText(
                                          text: "one more",
                                          color: AppColors.mainColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
                : Container(
              height: MediaQuery.of(context).size.height / 1.5,
              child: Center(
                child: const NoDataPage(
                  text: "You didn't buy anything so far!",
                  imgPath: "assets/images/emptyCart.jpg",
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}