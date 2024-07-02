import 'package:flutter/material.dart';
import 'package:msf/splash/splash_screen.dart';
import 'package:msf/utils/local_storage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.instance.initialize();
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {'/': (context) => const SplashScreen()},
      ),
    );
}
