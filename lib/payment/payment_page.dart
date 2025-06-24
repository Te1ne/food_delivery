import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:math' as Math;
import 'package:food_delivery/controllers/cart_controller.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:food_delivery/widgets/small_text.dart';

class PaymentHomePage extends StatefulWidget {
  @override
  _PaymentHomePageState createState() => _PaymentHomePageState();
}

class _PaymentHomePageState extends State<PaymentHomePage> {
  String paymentData = '';
  String orderId = '';
  CartController cartController = Get.find<CartController>();
  Timer? _paymentTimer;
  bool _isPaymentProcessing = false;

  @override
  void initState() {
    super.initState();
    generatePaymentQR();
    startPaymentMonitoring();
  }

  @override
  void dispose() {
    _paymentTimer?.cancel();
    super.dispose();
  }

  void generatePaymentQR() {
    // Tạo dữ liệu thanh toán duy nhất
    int totalAmount = cartController.totalAmount;
    print(totalAmount);
    orderId = DateTime.now().millisecondsSinceEpoch.toString();

    setState(() {
      paymentData = 'PAYMENT:$orderId:$totalAmount:${DateTime.now().millisecondsSinceEpoch}';
    });
  }

  void startPaymentMonitoring() {
    // Kiểm tra trạng thái thanh toán mỗi 2 giây
    _paymentTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      checkPaymentStatus();
    });
  }

  Future<void> checkPaymentStatus() async {
    if (_isPaymentProcessing) return;

    try {
      // Gọi API để kiểm tra trạng thái thanh toán
      // Thay thế bằng API thực tế của bạn
      bool isPaymentSuccess = await simulatePaymentCheck();

      if (isPaymentSuccess) {
        _isPaymentProcessing = true;
        _paymentTimer?.cancel();

        // Hiển thị loading
        showPaymentProcessingDialog();

        // Simulate processing time
        await Future.delayed(Duration(seconds: 2));

        // Add to history và chuyển trang
        Navigator.of(context).pop(); // Close loading dialog
        Get.toNamed('/order-successful');
      }
    } catch (e) {
      print('Error checking payment status: $e');
    }
  }

  Future<bool> simulatePaymentCheck() async {
    // Mô phỏng việc kiểm tra thanh toán
    // Trong thực tế, bạn sẽ gọi API để kiểm tra:
    // - Có ai đó quét mã QR này chưa
    // - Thanh toán có thành công không

    // Simulate random success after some time (for demo)
    if (DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(int.parse(orderId))).inSeconds > 10) {
      return Math.Random().nextBool(); // 50% chance success after 10 seconds
    }
    return false;
  }

  void showPaymentProcessingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.mainColor),
            SizedBox(height: Dimensions.height20),
            BigText(text: "Đang xử lý thanh toán..."),
            SizedBox(height: Dimensions.height10),
            SmallText(text: "Vui lòng chờ trong giây lát", color: Colors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: BigText(text: "Thanh toán", color: Colors.white),
        backgroundColor: AppColors.mainColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: GetBuilder<CartController>(
        builder: (cartController) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(Dimensions.width20),
              child: Column(
                children: [
                  // Thông tin đơn hàng
                  Container(
                    padding: EdgeInsets.all(Dimensions.width20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: Dimensions.height30),

                  // Mã QR thanh toán
                  Container(
                    padding: EdgeInsets.all(Dimensions.width20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        BigText(text: "Quét mã QR để thanh toán"),
                        SizedBox(height: Dimensions.height20),

                        // QR Code
                        Container(
                          padding: EdgeInsets.all(Dimensions.width20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(Dimensions.radius15),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: paymentData.isNotEmpty
                              ? QrImageView(
                            data: paymentData,
                            version: QrVersions.auto,
                            size: 250.0,
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          )
                              : Container(
                            width: 250,
                            height: 250,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.mainColor,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: Dimensions.height20),
                        SmallText(
                          text: "Sử dụng ứng dụng ngân hàng hoặc ví điện tử để quét mã QR",
                          color: Colors.grey,
                        ),
                        SizedBox(height: Dimensions.height10),
                        SmallText(
                          text: "Hệ thống sẽ tự động phát hiện khi thanh toán thành công",
                          color: Colors.grey,
                        ),
                        SizedBox(height: Dimensions.height10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.mainColor,
                              ),
                            ),
                            SizedBox(width: Dimensions.width10),
                            SmallText(
                              text: "Đang chờ thanh toán...",
                              color: AppColors.mainColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: Dimensions.height30),

                  // Nút demo (để test)
                  Container(
                    width: double.maxFinite,
                    height: Dimensions.height20*3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                      color: AppColors.mainColor,
                    ),
                    child: TextButton(
                      onPressed: () {
                        // Simulate QR scan success
                        Get.toNamed('/order-successful');
                      },
                      child: BigText(
                        text: "Demo: Thanh toán thành công",
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}