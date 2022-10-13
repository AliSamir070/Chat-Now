import 'package:flutter/widgets.dart';

abstract class LoginInterface{
  void NavigateToHome();
  void ShowLoginLoading();
  void ShowLoginMessage(String message , String title,);
  void hideLoading();
}