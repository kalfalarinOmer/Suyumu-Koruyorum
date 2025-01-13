/*
* vatandaşın başvurunun düzenlenmesi, çözüldüğünün doğrulanması
* vatandaş profil sayfasındaki bilgilerin veritabanından getirilmesi
*/


import 'package:flutter/material.dart';
import 'package:suyumukoruyorum/Helpers/MyInheritor.dart';
import 'package:suyumukoruyorum/LandingPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:change_app_package_name/change_app_package_name.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyInheritor(child: const SuyumuKoruyorum()));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class SuyumuKoruyorum extends StatelessWidget {
  const SuyumuKoruyorum({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SuyumuKoruyorum',
      theme: ThemeData(),
      home: LandingPage(),
    );
  }
}