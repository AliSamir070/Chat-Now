import 'package:chat_app/layout/home/home_screen.dart';
import 'package:chat_app/layout/register/register_interface.dart';
import 'package:chat_app/layout/register/register_viewmodel.dart';
import 'package:chat_app/shared/local/utils.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/local/style.dart';

class RegisterScreen extends StatefulWidget {
  static String route = "RegisterScreen";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> implements RegisterInterface {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  late RegisterViewModel _registerViewModel;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider(
        create: (context)=>RegisterViewModel(),
        builder: (context , _){
          _registerViewModel = Provider.of(context);
          _registerViewModel.authProvider = Provider.of(context);
          _registerViewModel.navigator = this;
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/back.png'),
                    fit: BoxFit.cover
                ),
                color: Colors.white
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Text(
                    'Create Account'
                ),
              ),
              body: Center(
                child: Padding(
                  padding: EdgeInsetsDirectional.only(start: 20,end: 20,top: height*0.18),
                  child: SingleChildScrollView(
                    child: Container(
                      height: height*0.6,
                      child: Form(
                        key: _registerViewModel.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              style: Theme.of(context).textTheme.titleSmall,
                              keyboardType: TextInputType.name,
                              controller: nameController,

                              validator: (value){
                                if(value!.isEmpty){
                                  return "Name shouldn't be empty";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 3
                                    )
                                ),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).canvasColor
                                    )
                                ),
                                labelText: 'Name',
                                labelStyle: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                            SizedBox(
                              height: height*0.02,
                            ),
                            TextFormField(
                              style: Theme.of(context).textTheme.titleSmall,
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              onChanged: (value){
                                _registerViewModel.checkEmail(value);
                              },
                              validator: (value){
                                if(value!.isEmpty || !EmailValidator.validate(value)){
                                  return "Enter valid email";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                suffixIcon: _registerViewModel.isEmailValid?Icon(Icons.check_circle_rounded,color: Theme.of(context).primaryColor,):null,
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 3
                                    )
                                ),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).canvasColor
                                    )
                                ),
                                labelText: 'Email',
                                labelStyle: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                            SizedBox(
                              height: height*0.02,
                            ),
                            TextFormField(
                              style: Theme.of(context).textTheme.titleSmall,
                              keyboardType: TextInputType.visiblePassword,
                              controller: passwordController,
                              obscureText: _registerViewModel.isPasswordObscured,
                              validator: (value){
                                if(value!.isEmpty || value.length<6){
                                  return "Password shouldn't be less than 6 characters";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                suffixIcon: _registerViewModel.isPasswordObscured
                                    ?IconButton(onPressed: (){
                                  _registerViewModel.hidePassword(false);
                                }, icon: Icon(Icons.visibility_off_outlined,color: Theme.of(context).primaryColor,size: height*0.02,))
                                    :IconButton(onPressed: (){
                                  _registerViewModel.hidePassword(true);
                                }, icon: Icon(Icons.visibility_outlined,color: Theme.of(context).primaryColor,size: height*0.02)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 3
                                    )
                                ),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).canvasColor
                                    )
                                ),
                                labelText: 'Password',
                                labelStyle: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                            SizedBox(
                              height: height*0.02,
                            ),
                            TextFormField(
                              style: Theme.of(context).textTheme.titleSmall,
                              keyboardType: TextInputType.visiblePassword,
                              controller: confirmPasswordController,
                              obscureText: _registerViewModel.isConfirmPasswordObscured,
                              validator: (value){
                                if(value!.compareTo(passwordController.text) == -1){
                                  return "Confirm password not valid";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                suffixIcon: _registerViewModel.isConfirmPasswordObscured
                                    ?IconButton(onPressed: (){
                                  _registerViewModel.hideConfirmPassword(false);
                                }, icon: Icon(Icons.visibility_off_outlined,color: Theme.of(context).primaryColor,size: 30,))
                                    :IconButton(onPressed: (){
                                  _registerViewModel.hideConfirmPassword(true);
                                }, icon: Icon(Icons.visibility_outlined,color: Theme.of(context).primaryColor,size: 30)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 3
                                    )
                                ),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).canvasColor
                                    )
                                ),
                                labelText: 'Confirm Password',
                                labelStyle: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                            Spacer(),
                            ElevatedButton(
                                onPressed: (){
                                  _registerViewModel.register(emailController.text , passwordController.text , nameController.text);
                                },
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 15 , horizontal: 30),
                                    primary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadiusDirectional.circular(10)
                                    )
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "Create Account",
                                      style: Theme.of(context).textTheme.displayMedium,
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Theme.of(context).secondaryHeaderColor,
                                      size: 30,
                                    )
                                  ],
                                )
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
    );
  }

  @override
  void NavigateToHome() {
    Navigator.pushReplacementNamed(context, HomeScreen.route);
  }

  @override
  void ShowRegisterLoading() {
    showAuthLoading(context);
  }

  @override
  void ShowRegisterMessage(String message, String title) {
    showMessage(context,message: message , title: title , positiveTitle: "Ok",positiveFunction: (){
      Navigator.pop(context);
    });
  }

  @override
  void hideLoading() {
    hideAuthLoading(context);
  }
}
