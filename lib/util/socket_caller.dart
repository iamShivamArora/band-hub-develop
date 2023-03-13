import 'package:band_hub/util/sharedPref.dart';
import 'package:band_hub/util/socket_manger.dart';
import 'package:get_it/get_it.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

GetIt getIt = GetIt.instance;

Future<void> socketCaller() async {
  getIt.registerSingleton<IO.Socket>(await initSocket());
  getIt.registerLazySingleton<SocketManger>(() => SocketManger());
  String? token = await SharedPref().getToken();

  if (token != null && token.isNotEmpty) {
    print(token);
    getIt<SocketManger>().connectUserSocket();
  }
}
