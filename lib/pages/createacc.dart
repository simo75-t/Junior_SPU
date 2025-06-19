import 'package:flutter/material.dart';
import 'package:jounior/controllers/usercontroller.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedCurrency;
  final List<String> _currencies = ['USD', 'EUR', 'AED', 'JPY', 'SYP', 'AUD'];
  bool showVerificationField = false;
  final TextEditingController _verificationCodeController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create Your Account'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 37, 116, 78),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'lib/imges/money.jpg',
                height: 250,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    // حقل إدخال البريد الإلكتروني
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        border: Border.all(
                            color: const Color.fromARGB(255, 37, 116, 78),
                            width: 2),
                      ),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 37, 116, 78)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a Email';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
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
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 37, 116, 78)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a username';
                          }
                          return null;
                        },
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
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 37, 116, 78)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    // حقل اختيار العملة
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        border: Border.all(
                          color: const Color.fromARGB(255, 37, 116, 78),
                          width: 2,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonFormField<String>(
                        value: _selectedCurrency,
                        decoration: const InputDecoration(
                          labelText: 'Choose cash currency',
                          labelStyle: TextStyle(
                            color: Color.fromARGB(255, 37, 116, 78),
                          ),
                          border: InputBorder.none,
                        ),
                        items: _currencies
                            .map((currency) => DropdownMenuItem<String>(
                                  value: currency,
                                  child: Text(currency),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCurrency = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a currency';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          bool result = await UserController.registeruser(
                            _emailController.text.trim(),
                            _usernameController.text.trim(),
                            _passwordController.text.trim(),
                            _selectedCurrency ?? "",
                            context,
                          );

                          if (result) {
                            setState(() {
                              showVerificationField = true;
                            });
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 37, 116, 78),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 50.0),
                      ),
                      child: const Text('Done',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),

                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        border: Border.all(
                          color: const Color.fromARGB(255, 37, 116, 78),
                          width: 2,
                        ),
                      ),
                      child: TextFormField(
                        controller: _verificationCodeController,
                        decoration: const InputDecoration(
                          labelText: 'Verification Code',
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 37, 116, 78)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        await UserController.verifyCode(
                            _emailController.text.trim(),
                            _verificationCodeController.text.trim(),
                            context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 37, 116, 78),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 50.0),
                      ),
                      child: const Text('Verify',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
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
