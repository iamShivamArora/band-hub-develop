import 'package:band_hub/routes/RouteGenerator.dart';
import 'package:band_hub/routes/Routes.dart';
import 'package:band_hub/util/socket_caller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'widgets/app_color.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await socketCaller();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light));

    return GetMaterialApp(
      builder: EasyLoading.init(),
      title: 'Band hub',
      theme: ThemeData(
        primarySwatch: AppColor.materialColor,
        appBarTheme:
            const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.light),
        fontFamily: 'Poppins',
        primaryColor: Colors.black,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        dividerColor: Colors.grey,
        cardColor: Colors.white,
        sliderTheme: const SliderThemeData(
          activeTrackColor: Color(0xff89CFF0),
          inactiveTrackColor: Color(0x0c000000),
        ),
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: AppColor.appColor),
        textSelectionTheme:
            const TextSelectionThemeData(cursorColor: Colors.black),
      ),
      navigatorObservers: [ClearFocusOnPush()],
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.splashScreen,
      defaultTransition: Transition.native,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

class ClearFocusOnPush extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    final focus = FocusManager.instance.primaryFocus;
    focus?.unfocus();
  }
}
