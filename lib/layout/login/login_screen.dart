import 'package:chat_app/layout/home/home_screen.dart';
import 'package:chat_app/layout/login/login_interface.dart';
import 'package:chat_app/layout/login/login_viewmodel.dart';
import 'package:chat_app/layout/register/register_screen.dart';
import 'package:chat_app/shared/local/style.dart';
import 'package:chat_app/shared/local/utils.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static String route = "LoginScreen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> implements LoginInterface{
  late LoginViewModel _loginViewModel;

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider(
      create: (context)=>LoginViewModel(),
      builder: (context,_){
        _loginViewModel = Provider.of(context);
        _loginViewModel.authProvider = Provider.of(context);
        _loginViewModel.navigator = this;
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
                    'Login'
                ),
              ),
              body: Center(
                child: Padding(
                  padding: EdgeInsetsDirectional.only(start: 20,end: 20,top: 40),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _loginViewModel.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Welcome back!',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(
                            height: height*0.03,
                          ),
                          TextFormField(
                            style: Theme.of(context).textTheme.titleSmall,
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            onChanged: (value){
                              _loginViewModel.checkEmail(value);
                            },
                            validator: (value){
                              if(value!.isEmpty || !EmailValidator.validate(value.trim())){
                                return "Enter valid email";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              suffixIcon: _loginViewModel.isEmailValid?Icon(Icons.check_circle_rounded,color: Theme.of(context).primaryColor,):null,
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
                            obscureText: _loginViewModel.isPasswordObscured,
                            validator: (value){
                              if(value!.isEmpty || value.length<6){
                                return "Password shouldn't be less than 6 characters";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              suffixIcon: _loginViewModel.isPasswordObscured
                                  ?IconButton(onPressed: (){
                                    _loginViewModel.hidePassword(false);
                              }, icon: Icon(Icons.visibility_off_outlined,color: Theme.of(context).primaryColor,size: 30,))
                                  :IconButton(onPressed: (){
                                    _loginViewModel.hidePassword(true);
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
                              labelText: 'Password',
                              labelStyle: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          SizedBox(
                            height: height*0.02,
                          ),
                          TextButton(
                              onPressed: (){},
                              style: ButtonStyle(
                                overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
                                alignment: AlignmentDirectional.centerStart,
                                padding: MaterialStateProperty.resolveWith((states) => EdgeInsetsDirectional.zero)
                              ),
                              child: Text(
                                  'Forgot password?',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppStyle.textColor,
                                  ),
                              )
                          ),
                          SizedBox(
                            height: height*0.02,
                          ),
                          Row(
                            children: [
                              Text(
                                'Remember me',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppStyle.textColor,
                                ),
                              ),
                              SizedBox(width: 5,),
                              Transform.scale(
                                scale: 1.5,
                                child: Checkbox(
                                    value: _loginViewModel.isRemembered,
                                    onChanged: (value){
                                      _loginViewModel.setRemembered(value!);
                                    },
                                    shape: CircleBorder(),
                                    tristate: false,
                                    side: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: height*0.02,
                          ),
                          ElevatedButton(
                              onPressed: (){
                                _loginViewModel.login(emailController.text , passwordController.text);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 15 , horizontal: 30)
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "Login",
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 30,
                                  )
                                ],
                              )
                          ),
                          SizedBox(
                            height: height*0.02,
                          ),
                          TextButton(
                              onPressed: (){
                                Navigator.pushNamed(context, RegisterScreen.route);
                              },
                              style: ButtonStyle(
                                  overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
                                  alignment: AlignmentDirectional.centerStart,
                                  padding: MaterialStateProperty.resolveWith((states) => EdgeInsetsDirectional.zero)
                              ),
                              child: Text(
                                'Or Create My Account',
                                style: Theme.of(context).textTheme.displaySmall,
                              )
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
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
  void ShowLoginLoading() {
    showAuthLoading(context);
  }

  @override
  void ShowLoginMessage(String message , String title) {
    showMessage(context,message: message , title: title , positiveTitle: "Ok",positiveFunction: (){
      Navigator.pop(context);
    });
  }

  @override
  void hideLoading() {
    hideAuthLoading(context);
  }
}
/*
* splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: (){
            FocusScope.of(context).requestFocus(new FocusNode());
          }
* */