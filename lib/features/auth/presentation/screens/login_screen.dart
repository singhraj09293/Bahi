import 'package:challan_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Welcome Back!',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                'Let’s login for explore continues',
                style: TextStyle(color: AppColors.grey),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xffF5E6C8),
                  borderRadius: BorderRadius.circular(30),
                ),
          
                child: Icon(Icons.menu_book, size: 70, color: AppColors.primary),
              ),
              SizedBox(height: 5),
              Text(
                'BAHI',
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text('Email', style: TextStyle(fontSize: 20))],
                    ),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xffF5E6C8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(color: AppColors.grey),
                          contentPadding: EdgeInsets.all(25),
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.email, color: AppColors.primary),
                        ),
                      ),
                    ),
          
                    SizedBox(height: 30),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Password', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xffF5E6C8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(color: AppColors.grey),
                          contentPadding: EdgeInsets.all(25),
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.lock, color: AppColors.primary),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forget Password?',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(360, 60),
                        backgroundColor: AppColors.primary,
                      ),
                      onPressed: () {},
                      child: Text(
                        'Sign in',
                        style: TextStyle(color: Colors.white, fontSize: 23),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Divider(thickness: 1.5, color: Colors.grey),
                        ),
                        SizedBox(width: 7),
                        Text(
                          'or continue with',
                          style: TextStyle(color: AppColors.grey),
                        ),
                        SizedBox(width: 7),
                        Expanded(
                          child: Divider(thickness: 1.5, color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        fixedSize: Size(100, 55),
                        side: BorderSide(color: AppColors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'G',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(color: AppColors.grey),
                        ),
                        SizedBox(width: 7,),
                        Text(
                          'Create Account',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
