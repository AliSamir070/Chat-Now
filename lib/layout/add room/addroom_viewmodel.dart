import 'package:chat_app/layout/add%20room/addroom_interface.dart';
import 'package:chat_app/model/room.dart';
import 'package:chat_app/shared/local/firebase_firestore_helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../model/category.dart';

class AddRoomViewModel extends ChangeNotifier{
  var formKey = GlobalKey<FormState>();
  Category? SelectedCategory;
  late AddRoomInterface navigator;
  void setCategory(Category? newCategory){
    SelectedCategory = newCategory;
    notifyListeners();
  }
  void addRoom(String name , String description , String userid){
    if(!formKey.currentState!.validate() || SelectedCategory==null) return;
    navigator.ShowLoading();
    FirebaseFirestoreHelper.addRoom(Room(
        id: "",
        roomName: name,
        description: description,
        categoryId: SelectedCategory!.id,
        memberNumber: 1,
        users: [userid]
    )).then((value){
      navigator.hideLoading();
      navigator.showToast();
      navigator.NavigateToHome();
    });
  }
}