
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static SharedPreferences? _preferences;
  static const _KeyAccessToken = 'authToken';
  static const _KeyPName = 'pName';
  static const _KeyBId = 'bId';
  static const _KeyBSId = 'bSId';
  static const _KeyBPrice = 'bPrice';
  static const _KeyBProfit = 'bProfit';
  static const _KeyBQuantity = 'bQuantity';
  static const _KeyBTotal = 'bTotal';




  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();


  static Future setAccessToken(String s) async {
    await _preferences?.setString(_KeyAccessToken, s);
  }
  static Future setPName(String s) async {
    await _preferences?.setString(_KeyPName, s);
  }
  static Future setBid(String s) async {
    await _preferences?.setString(_KeyBId, s);
  }
  static Future setBSid(String s) async {
    await _preferences?.setString(_KeyBSId, s);
  }
  static Future setBPrice(String s) async {
    await _preferences?.setString(_KeyBPrice, s);
  }
  static Future setBProfit(String s) async {
    await _preferences?.setString(_KeyBProfit, s);
  }
  static Future setBQuantity(String s) async {
    await _preferences?.setString(_KeyBQuantity, s);
  }
  static Future setBTotal(String s) async {
    await _preferences?.setString(_KeyBTotal, s);
  }




  static String? getAccessToken() => _preferences?.getString(_KeyAccessToken);
  static String? getBPrice() => _preferences?.getString(_KeyBPrice);
  static String? getBName() => _preferences?.getString(_KeyPName);
  static String? getBQuantity() => _preferences?.getString(_KeyBQuantity);

}
