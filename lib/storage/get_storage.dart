import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Database extends GetxController {
  final box = GetStorage();

  Future<void> initStorage() async {
    await GetStorage.init();
  }

  void storeValue(String constant,String value){
    box.write(constant, value);
  }

  getValue(String constant){
    return box.read(constant);
  }

  clearData(){
    box.erase();
  }

  // void storeUserModel(UserModel model) {
  //   box.write('user_model', model.toJson());
  // }

  // UserModel restoreUserModel() {
  //   final map = box.read('user_model') ?? UserModel().toJson();
  //   return UserModel.fromJson(map);
  // }
}