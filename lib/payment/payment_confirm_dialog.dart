import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaymentConfirmDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final random = Random();
    final amount = (random.nextInt(9) + 1) * 100000; // Random amount 100k-900k

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Row(
        children: [
          Icon(Icons.payment, color: Colors.blue),
          SizedBox(width: 10),
          Text('Xác nhận thanh toán'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Người nhận:', 'Cửa hàng ABC'),
          _buildInfoRow('Số tiền:', '${amount.toString().replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (
              Match m) => '${m[1]},')} VNĐ'),
          _buildInfoRow('Nội dung:', 'Thanh toán hóa đơn'),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info, color: Colors.orange, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Kiểm tra thông tin trước khi xác nhận',
                    style: TextStyle(
                      color: Colors.orange[800],
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
            _showPaymentSuccess(context, amount);
          },
          child: Text('Xác nhận'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentSuccess(BuildContext context, int amount) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 60,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Thanh toán thành công!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${amount.toString().replaceAllMapped(
                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (
                        Match m) => '${m[1]},')} VNĐ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text('Hoàn tất'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            )
    );
  }
}