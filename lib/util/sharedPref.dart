import 'package:shared_preferences/shared_preferences.dart';

import 'global_variable.dart';

class SharedPref {
  SharedPreferences? sharedPref;

  Future setPreferenceJson(jsonString) async {
    sharedPref = await SharedPreferences.getInstance();
    print(jsonString);
    sharedPref!.setString(GlobalVariable.userData, jsonString);
  }

  Future<String> getPreferenceJson() async {
    sharedPref = await SharedPreferences.getInstance();
    return sharedPref!.getString(GlobalVariable.userData) ?? "";
  }


  Future getPreference() async {
    sharedPref = await SharedPreferences.getInstance();
  }

  Future setToken(token) async {
    sharedPref = await SharedPreferences.getInstance();
    sharedPref!.setString(GlobalVariable.token, token);
  }

  Future<String?> getToken() async {
    sharedPref = await SharedPreferences.getInstance();
    return sharedPref!.getString(GlobalVariable.token);
  }


  Future setNotification(status) async {
    sharedPref = await SharedPreferences.getInstance();
    sharedPref!.setBool(GlobalVariable.notificationStatus, status);
  }

  Future<bool?> getNotification() async {
    sharedPref = await SharedPreferences.getInstance();
    return sharedPref!.getBool(GlobalVariable.notificationStatus);
  }

  Future setIsRemember(bool isRemember) async {
    sharedPref = await SharedPreferences.getInstance();
    sharedPref!.setBool(GlobalVariable.isRemember, isRemember);
  }

  Future<bool?> getIsRemember() async {
    sharedPref = await SharedPreferences.getInstance();
    return sharedPref!.getBool(GlobalVariable.isRemember);
  }

  Future storeRememberData(String data) async {
    //email, password
    sharedPref = await SharedPreferences.getInstance();
    sharedPref!.setString(GlobalVariable.rememberData, data);
  }

  Future<String?> getStoreRememberData() async {
    sharedPref = await SharedPreferences.getInstance();
    return sharedPref!.getString(GlobalVariable.rememberData);
  }
}

class SharePrefFirstTime {
  SharedPreferences? sharePrefIsFirstTime;

  Future setIsFirstTimeLogin(status) async {
    sharePrefIsFirstTime = await SharedPreferences.getInstance();
    sharePrefIsFirstTime!.setStringList("isFirstTime", status);
  }

  Future<List<String>?> getIsFirstTimeLogin() async {
    sharePrefIsFirstTime = await SharedPreferences.getInstance();
    return sharePrefIsFirstTime!.getStringList("isFirstTime");
  }
}
