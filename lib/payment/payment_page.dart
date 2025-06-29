import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/colors.dart';


class PaymentHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Lấy parameters từ GetX
    final amount = int.tryParse(Get.parameters['amount'] ?? '0') ?? 0;
    final addInfo = Get.parameters['info'] ?? 'THANH TOAN';

    final bankCode = 'SACOMBANK';
    final accountNumber = '060266005817';
    final accountName = 'THAI GIA BAO';

    final qrUrl =
        'https://img.vietqr.io/image/$bankCode-$accountNumber-compact.png'
        '?amount=$amount'
        '&addInfo=${Uri.encodeComponent(addInfo)}'
        '&accountName=${Uri.encodeComponent(accountName)}';

    return Scaffold(
      appBar: AppBar(title: Text('Thanh toán')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Quét mã bằng MoMo hoặc ngân hàng để thanh toán',
                style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
            SizedBox(height: 20),
            Image.network(qrUrl, width: 250, height: 250),
            SizedBox(height: 20),
            Text('Chủ tài khoản: $accountName'),
            Text('Ngân hàng: Sacombank'),
            Text('Số tiền: $amount VND'),
            Text('Nội dung: $addInfo'),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Get.toNamed('/order-successful'); // Điều hướng sau khi xác nhận
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'XÁC NHẬN THANH TOÁN',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
