import 'package:chat_app/layout/login/login_interface.dart';
import 'package:chat_app/model/user.dart';
import 'package:chat_app/shared/local/cache_helper.dart';
import 'package:chat_app/shared/local/firebase_firestore_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../shared/local/provider/auth_provider.dart';

class LoginViewModel extends ChangeNotifier{
  bool isEmailValid = false;
  bool isPasswordObscured = false;
  var formKey = GlobalKey<FormState>();
  late LoginInterface navigator;
  late AuthProvider authProvider;
  bool isRemembered = false;
  void setRemembered(bool value){
    isRemembered = value;
    notifyListeners();
  }
  void checkEmail(String value){
    if(value.isEmpty || !EmailValidator.validate(value)){
      if(isEmailValid) {
        isEmailValid = false;
        notifyListeners();
      }
    }else{
      if(!isEmailValid) {
        isEmailValid = true;
        notifyListeners();
      }
    }

  }
  void hidePassword(bool isVisible){
    isPasswordObscured = isVisible;
    notifyListeners();
  }
  void login(String email , String password) async{
    if(!formKey.currentState!.validate()) return;
    navigator.ShowLoginLoading();
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      MyUser? user;
      FirebaseFirestoreHelper.login(credential.user!.uid).then((value){
        user = value.data();
        if(isRemembered){
          print("Save: ${credential.user!.uid}");
          CacheHelper.setUserId(credential.user!.uid);
        }
        authProvider.setCurrentUser(user!);
        navigator.hideLoading();
        navigator.NavigateToHome();
      });

    } on FirebaseAuthException catch (e) {
      navigator.hideLoading();
      if (e.code == 'user-not-found') {
        navigator.ShowLoginMessage("No user found for that email", "Failed");
      } else if (e.code == 'wrong-password') {
        navigator.ShowLoginMessage("Wrong password provided for that user.", "Failed");
      }
    } catch (e) {
      print(e);
    }
  }
}