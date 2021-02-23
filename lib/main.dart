import 'package:Task/ui/HomeScreen.dart';
import 'package:Task/utilies/constants.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
//  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: [
        GestureType.onTap,
        GestureType.onPanUpdateDownDirection,
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: HOME_ROUTE,
          routes: {
            HOME_ROUTE: (context) => HomeScreen(),
          }),
    );
  }
}
