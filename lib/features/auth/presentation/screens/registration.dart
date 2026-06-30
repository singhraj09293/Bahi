import 'package:challan_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => RegistrationState();
}

class RegistrationState extends State<Registration> {
  bool _obscure = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Create your account',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                textAlign: TextAlign.center,
                'Create account to start managing your karkhana" or "Set up your Bahi account.',
                style: TextStyle(color: AppColors.grey),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xffF5E6C8),
                  borderRadius: BorderRadius.circular(30),
                ),

                child: Icon(
                  Icons.menu_book,
                  size: 70,
                  color: AppColors.primary,
                ),
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
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('First Name', style: TextStyle(fontSize: 20)),
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
                          hintText: 'First Name',
                          hintStyle: TextStyle(color: AppColors.grey),
                          contentPadding: EdgeInsets.all(20),
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.person,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Last Name', style: TextStyle(fontSize: 20)),
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
                          hintText: 'Last name',
                          hintStyle: TextStyle(color: AppColors.grey),
                          contentPadding: EdgeInsets.all(20),
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.person,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
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
                          contentPadding: EdgeInsets.all(20),
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.email,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
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
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(color: AppColors.grey),
                          contentPadding: EdgeInsets.all(20),
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.lock,
                            color: AppColors.primary,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscure = !_obscure;
                              });
                            },
                            child: Icon(
                              _obscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(360, 60),
                        backgroundColor: AppColors.primary,
                      ),
                      onPressed: () {},
                      child: Text(
                        'Continue',
                        style: TextStyle(color: Colors.white, fontSize: 23),
                      ),
                    ),
                   
                    
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
