import 'package:challan_app/core/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _obscure = false;
  signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login Failed $e')));
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              SizedBox(height: 30),
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
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(5.0),
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
                        controller: email,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(color: AppColors.grey),
                          contentPadding: EdgeInsets.all(25),
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.email,
                            color: AppColors.primary,
                          ),
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
                        controller: password,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(color: AppColors.grey),
                          contentPadding: EdgeInsets.all(25),
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
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => ForgetPass()),
                            );
                          },
                          child: Text(
                            'Forget Password?',
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 100),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(360, 60),
                        backgroundColor: AppColors.primary,
                      ),
                      onPressed: () {
                        signIn();
                      },
                      child: Text(
                        'Sign in',
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
  }
}

class ForgetPass extends StatelessWidget {
  const ForgetPass({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    Future<void> forgetPassword() async {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email.text.trim(),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/forget.png', height: 300),
              SizedBox(height: 20),
              Text(
                'Reset Your Password',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              SizedBox(height: 10),
              Text(
                textAlign: TextAlign.center,
                "Enter your email adress below and we’ll send you a link with instructions",
                style: TextStyle(color: AppColors.grey),
              ),
              SizedBox(height: 20),
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
                  controller: email,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: AppColors.grey),
                    contentPadding: EdgeInsets.all(25),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.email, color: AppColors.primary),
                  ),
                ),
              ),
              SizedBox(height: 200),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(360, 60),
                  backgroundColor: AppColors.primary,
                ),
                onPressed: () async {
                  await forgetPassword();
                  Future.delayed(Duration(seconds: 3), () {
                    Navigator.pop(context);
                  });
                },
                child: Text(
                  'Send Verification code',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
