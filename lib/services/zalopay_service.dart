import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class ZaloPayService {
  static const String endpoint = "https://sb-openapi.zalopay.vn/v2/create";
  static const String appId = "2553";
  static const String key1 = "PcY4iZIKFCIdgZvA6ueMcMHHUbRLYjPL";

  static Future<String?> createZaloPayOrder(int totalAmount) async {
    try {
      final String appUser = "user123";
      final String embedData = "{}";
      final String item = '[{"itemid":"food1","itemname":"Order","itemprice":$totalAmount,"itemquantity":1}]';
      final int timestamp = DateTime.now().millisecondsSinceEpoch;

      final now = DateTime.now();
      final date = "${now.year % 100}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}";
      final random = (100000 + now.millisecond).toString();
      final appTransId = "$date\_$random";

      final String data = "$appId|$appTransId|$appUser|$totalAmount|$timestamp|$embedData|$item";
      final mac = Hmac(sha256, utf8.encode(key1)).convert(utf8.encode(data)).toString();

      final body = {
        "app_id": int.parse(appId),
        "app_user": appUser,
        "app_time": timestamp,
        "amount": totalAmount,
        "app_trans_id": appTransId,
        "embed_data": embedData,
        "item": item,
        "description": "Đơn hàng #$random",
        "bank_code": "zalopayapp",
        "mac": mac
      };

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print("ZaloPay Response: ${response.body}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json["return_code"] == 1) {
          return json["order_url"];
        } else {
          print("Lỗi trả về từ ZaloPay: ${json["return_message"]}");
        }
      } else {
        print("HTTP lỗi: ${response.statusCode}");
      }
    } catch (e) {
      print("Lỗi khi tạo đơn hàng ZaloPay: $e");
    }

    return null;
  }
}
