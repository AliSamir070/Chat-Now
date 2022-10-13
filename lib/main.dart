import 'package:chat_app/layout/add%20room/addroom_screen.dart';
import 'package:chat_app/layout/chat/chat_screen.dart';
import 'package:chat_app/layout/home/home_screen.dart';
import 'package:chat_app/layout/login/login_screen.dart';
import 'package:chat_app/layout/register/register_screen.dart';
import 'package:chat_app/shared/local/cache_helper.dart';
import 'package:chat_app/shared/local/provider/auth_provider.dart';
import 'package:chat_app/shared/local/style.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  CacheHelper.prefs = await SharedPreferences.getInstance();
  String? id  = CacheHelper.getUserId();
  runApp(ChangeNotifierProvider(
      child: MyApp(id),
      create: (context)=>AuthProvider(),
  )
  );
}

class MyApp extends StatelessWidget {
  String? id;
  MyApp(this.id);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print("object");
    AuthProvider provider = Provider.of(context);
    if(provider.user==null){
      provider.checkLoginUser(id);
    }
    return MaterialApp(
      theme: AppStyle.lightTheme,
      debugShowCheckedModeBanner: false,

      routes: {
        HomeScreen.route:(_)=>HomeScreen(),
        LoginScreen.route:(_)=>LoginScreen(),
        RegisterScreen.route:(_)=>RegisterScreen(),
        AddRoomScreen.route:(_)=>AddRoomScreen(),
        ChatScreen.route:(_)=>ChatScreen()
      },
      initialRoute: id==null?LoginScreen.route:HomeScreen.route,
    );
  }
}


