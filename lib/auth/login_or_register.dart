 import 'package:flutter/cupertino.dart';
import 'package:seen/pages/login_page.dart';
import 'package:seen/pages/register_page.dart';

class LoginorRegister extends StatefulWidget {
   const LoginorRegister({super.key});

   @override
   State<LoginorRegister> createState() => _LoginorRegisterState();
 }

 class _LoginorRegisterState extends State<LoginorRegister> {
  bool showLoginPage =true;
   void switchPage(){
     setState(() {
       showLoginPage = !showLoginPage;
     });
   }
   @override
   Widget build(BuildContext context) {
     if (showLoginPage){
       return LoginPage(onTap: switchPage);
     }else {
       return RegisterPage(onTap: switchPage,);
     }
   }
 }
