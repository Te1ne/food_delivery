import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/auth/sign_up_page.dart';
import 'package:food_delivery/base/custom_loader.dart';
import 'package:food_delivery/base/show_custom_snackbar.dart';
import 'package:food_delivery/controllers/auth_controller.dart';
import 'package:food_delivery/route/route_helper.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widgets/app_text_field.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:get/get.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    //var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var phoneController = TextEditingController();
    void _login(AuthController authController){
      String phone = phoneController.text.trim();
      //String email = emailController.text.trim();
      String password = passwordController.text.trim();

      if(phone.isEmpty){
        showCustomSnackBar("Type in your phone number", title: "Phone number");
      }else if(password.isEmpty){
        showCustomSnackBar("Type in your password", title: "password");
      }else if(password.length<6){
        showCustomSnackBar("Password can not be less than 6 characters", title: "Password ");
      }else{

        authController.login(phone, password).then((status){
          if(status.isSuccess){
            Get.toNamed(RouteHelper.getInitial());
            //Get.toNamed(RouteHelper.getCartPage());
          }else{
            showCustomSnackBar(status.message);
          }
        });
      }

    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<AuthController>(builder: (authController){
        return !authController.isLoading?SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: Dimensions.screenHeight*0.05,),
              //app logo
              Container(
                height: Dimensions.screenHeight*0.25,
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 80,
                    backgroundImage: AssetImage(
                        "assets/images/logo2.jpg"
                    ),
                  ),
                ),
              ),
              //welcome
              Container(
                margin: EdgeInsets.only(
                    left: Dimensions.width20
                ),
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello",
                      style: TextStyle(
                          fontSize: Dimensions.font20*3 + Dimensions.font20/2,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      "Sign in to your account",
                      style: TextStyle(
                          fontSize: Dimensions.font20,
                          color: Colors.grey[500]
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height20,),
              //your email
              AppTextField(textController: phoneController,
                  icon: Icons.phone,
                  hintText: "Phone"),
              SizedBox(height: Dimensions.height20,),
              //your password
              AppTextField(textController: passwordController,
                icon: Icons.password_sharp,
                hintText: "Password",
                isObscure: true,),
              SizedBox(height: Dimensions.height20,),
              //tag line
              Row(
                children: [
                  Expanded(child: Container()),
                  RichText(
                    text: TextSpan(
                        text: "Sign in to your account",
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: Dimensions.font20
                        )
                    ),
                  ),
                  SizedBox(height: Dimensions.width20,),
                ],
              ),
              SizedBox(height: Dimensions.screenHeight*0.05,),
              //sign in button
              GestureDetector(
                onTap: (){
                  _login(authController);
                },
                child: Container(
                  width: Dimensions.screenWidth/2,
                  height: Dimensions.screenHeight/13,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                      color: AppColors.mainColor
                  ),
                  child: Center(
                    child: BigText(
                      text: "Sign in",
                      size: Dimensions.font20 + Dimensions.font20/2,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: Dimensions.screenHeight*0.05,),
              //sign up options
              RichText(
                text: TextSpan(
                    text: "Don't have an account?",
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: Dimensions.font20
                    ),
                    children: [
                      TextSpan(
                          recognizer: TapGestureRecognizer()..onTap=()=>Get.to(()=>SignUpPage(), transition: Transition.fade),
                          text: " Create",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.mainBlackColor,
                              fontSize: Dimensions.font20
                          ))
                    ]
                ),
              ),
            ],
          ),
        ):CustomLoader();
      }),
    );
  }
}
