import 'package:chat_app/layout/register/register_interface.dart';
import 'package:chat_app/model/user.dart';
import 'package:chat_app/shared/local/firebase_firestore_helper.dart';
import 'package:chat_app/shared/local/provider/auth_provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterViewModel extends ChangeNotifier{
  bool isEmailValid = false;
  bool isPasswordObscured = false;
  bool isConfirmPasswordObscured = false;
  late RegisterInterface navigator;
  late AuthProvider authProvider;
  var formKey = GlobalKey<FormState>();
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
  void hideConfirmPassword(bool isVisible){
    isConfirmPasswordObscured = isVisible;
    notifyListeners();
  }
  void register(String email , String password , String name) async{
    if(!formKey.currentState!.validate()) return;
    navigator.ShowRegisterLoading();
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      MyUser user = MyUser(id: credential.user?.uid, name: name, email: email);
      FirebaseFirestoreHelper.register(user).then((value){
        authProvider.setCurrentUser(user);
        navigator.hideLoading();
        navigator.NavigateToHome();
      });

    } on FirebaseAuthException catch (e) {
      navigator.hideLoading();
      if (e.code == 'weak-password') {
        navigator.ShowRegisterMessage('The password provided is too weak.', "Failed");
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        navigator.ShowRegisterMessage('The account already exists for that email.', "Failed");
      }else if(e.code == "invalid-email"){
        navigator.ShowRegisterMessage("Email is not valid.", "Failed");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}