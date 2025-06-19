import 'package:flutter/material.dart';
import 'package:jounior/controllers/usercontroller.dart';
import 'package:jounior/pages/homepage.dart';
import 'createacc.dart'; // استيراد صفحة "Create Account"

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Log Into Your Profile'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 37, 116, 78),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('lib/imges/money.jpg', height: 250),
            const SizedBox(height: 40),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  // حقل إدخال اسم المستخدم
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      border: Border.all(
                          color: const Color.fromARGB(255, 37, 116, 78),
                          width: 2),
                    ),
                    child: TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                            color: const Color.fromARGB(255, 37, 116, 78)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // حقل إدخال كلمة المرور
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      border: Border.all(
                          color: const Color.fromARGB(255, 37, 116, 78),
                          width: 2),
                    ),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        labelStyle:
                            TextStyle(color: Color.fromARGB(255, 37, 116, 78)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // زر تسجيل الدخول
                  ElevatedButton(
                    // onPressed: () async {
                    //   if (_formKey.currentState?.validate() ?? false) {
                    //     await UserController.login(
                    //         _usernameController.text.trim(),
                    //         _passwordController.text.trim(),
                    //         context);
                    //   }
                    // },
                    onPressed: () async {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Homepage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 37, 116, 78),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 50.0),
                    ),
                    child: const Text('Login',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Homepage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 37, 116, 78),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 50.0),
                    ),
                    child: const Text('Skip Login for test',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),

                  const SizedBox(height: 20),
                  // رسالة "Don't have an account?" مع زر "Create Account"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text("Don't have an account? ",
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                      GestureDetector(
                        onTap: () {
                          // الانتقال إلى صفحة "Create Account"
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CreateAccountPage(), // الانتقال إلى صفحة "Create Account"
                            ),
                          );
                        },
                        child: const Text('Create Account',
                            style: TextStyle(
                                color: Color.fromARGB(255, 37, 116, 78),
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
