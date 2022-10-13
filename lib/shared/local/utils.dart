import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showMessage(BuildContext context , {String? message , String? title , Function? positiveFunction, String? positiveTitle}){
  AlertDialog dialog = AlertDialog(
    title: Text(title??""),
    content: Text(message??""),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.circular(20)
    ),
    actions: [
      ElevatedButton(
          onPressed: (){
            if(positiveFunction != null) {
              positiveFunction();
            }
          }, child: Text(positiveTitle??"")
      )
    ],
  );
  showDialog(context: context, builder: (context)=>dialog);
}
void showAuthLoading(BuildContext context ){
  AlertDialog dialog = AlertDialog(

    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusDirectional.circular(20)
    ),
    content: Container(
      height: 120,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Loading...'
            ),
            SizedBox(height: 15,),
            CircularProgressIndicator()
          ],
        ),
      ),
    ),
  );
  showDialog(context: context, builder: (context)=>dialog);
}
void hideAuthLoading(BuildContext context){
  Navigator.pop(context);
}
void showToastMessage(BuildContext context , String message){
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      backgroundColor: Theme.of(context).primaryColor,
      textColor: Colors.white,
      fontSize: 16.0
  );
}