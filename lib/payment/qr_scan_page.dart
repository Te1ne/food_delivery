import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/payment/payment_confirm_dialog.dart';

class QRScanPage extends StatefulWidget {
  @override
  _QRScanPageState createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isScanning = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.repeat();

    // Simulate scan result after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        _simulateScanResult();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _simulateScanResult() {
    setState(() {
      _isScanning = false;
    });

    showDialog(
      context: context,
      builder: (context) => PaymentConfirmDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Quét mã QR'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Camera preview simulation
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[900],
            child: Center(
              child: Text(
                'Camera Preview\n(Giả lập)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 18,
                ),
              ),
            ),
          ),

          // Scan overlay
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: _isScanning
                  ? AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Stack(
                    children: [
                      Positioned(
                        top: _animation.value * 230,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 2,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  );
                },
              )
                  : Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 60,
              ),
            ),
          ),

          // Instructions
          Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _isScanning
                    ? 'Đưa mã QR vào trong khung để quét'
                    : 'Đã phát hiện mã QR!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}