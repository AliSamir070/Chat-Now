import 'package:chat_app/layout/home/home_interface.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier{
  late HomeInterface interface;

  void goToAddRoom(){
    interface.NavigateToAddRoom();
  }
}