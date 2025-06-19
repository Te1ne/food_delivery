import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery/payment/qr_generate_page.dart';
import 'package:food_delivery/payment/qr_scan_page.dart';

class PaymentHomePage extends StatefulWidget {
  @override
  _PaymentHomePageState createState() => _PaymentHomePageState();
}

class _PaymentHomePageState extends State<PaymentHomePage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Thanh toán QR', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Balance Card
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[600]!, Colors.blue[800]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Số dư khả dụng',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '2,450,000 VNĐ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // Payment Form
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thông tin thanh toán',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Amount Input
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'Số tiền (VNĐ)',
                      hintText: 'Nhập số tiền cần thanh toán',
                      prefixIcon: Icon(Icons.attach_money, color: Colors.green),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                  ),

                  SizedBox(height: 15),

                  // Description Input
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Nội dung (tuỳ chọn)',
                      hintText: 'Mô tả giao dịch',
                      prefixIcon: Icon(Icons.description, color: Colors.orange),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // Quick Amount Buttons
            Text(
              'Số tiền nhanh',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildQuickAmountButton('50K', 50000),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildQuickAmountButton('100K', 100000),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildQuickAmountButton('200K', 200000),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildQuickAmountButton('500K', 500000),
                ),
              ],
            ),

            SizedBox(height: 30),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _generateQRCode(),
                    icon: Icon(Icons.qr_code, size: 24),
                    label: Text('Tạo mã QR', style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _scanQRCode(),
                    icon: Icon(Icons.qr_code_scanner, size: 24),
                    label: Text('Quét mã QR', style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 30),

            // Recent Transactions
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Giao dịch gần đây',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 15),
                  _buildTransactionItem('Thanh toán QR', '-150,000 VNĐ', '12:30', Colors.red),
                  _buildTransactionItem('Nhận tiền', '+500,000 VNĐ', '10:15', Colors.green),
                  _buildTransactionItem('Chuyển khoản', '-75,000 VNĐ', '09:45', Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAmountButton(String label, int amount) {
    return ElevatedButton(
      onPressed: () {
        _amountController.text = amount.toString();
      },
      child: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[100],
        foregroundColor: Colors.grey[800],
        padding: EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(String title, String amount, String time, Color amountColor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: amountColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.payment,
              color: amountColor,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              color: amountColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _generateQRCode() {
    if (_amountController.text.isEmpty) {
      _showMessage('Vui lòng nhập số tiền');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRGeneratePage(
          amount: _amountController.text,
          description: _descriptionController.text,
        ),
      ),
    );
  }

  void _scanQRCode() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QRScanPage()),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
      ),
    );
  }
}