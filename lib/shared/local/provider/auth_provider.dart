import 'package:chat_app/shared/local/firebase_firestore_helper.dart';
import 'package:flutter/foundation.dart';

import '../../../model/user.dart';

class AuthProvider extends ChangeNotifier{
  MyUser? user;

  void setCurrentUser(MyUser temp){
    user = temp;
    notifyListeners();
  }
  void checkLoginUser(String? id){
    print(id);
    if(id==null) {
      return;
    }
    print("ID: $id");
    FirebaseFirestoreHelper.login(id).then((value){
      print("user");
      user = value.data();
      notifyListeners();
    });
  }
}