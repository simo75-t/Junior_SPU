import 'package:flutter/material.dart';
import 'package:jounior/controllers/updatepasswordcontroller.dart'; // Correct the import
import 'package:jounior/pages/homepage.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  final TextEditingController _oldPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  bool _loading = false;

  Future<void> _handleUpdatePassword() async {
    final oldPassword = _oldPassword.text;
    final newPassword = _newPassword.text;
    final confirmPassword = _confirmPassword.text;

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() => _loading = true);
    final result = await UpdatePasswordController.changePassword(
      oldPassword,
      newPassword,
      confirmPassword,
      context,
    );
    setState(() => _loading = false);

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully!')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Homepage()),
        (route) => false,
      );
    }
    // If failed, error is already shown in controller
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Password'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 37, 116, 78),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(
                    color: const Color.fromARGB(255, 37, 116, 78), width: 2),
              ),
              child: TextFormField(
                controller: _oldPassword,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Please Enter the Old Password',
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 37, 116, 78)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(
                    color: const Color.fromARGB(255, 37, 116, 78), width: 2),
              ),
              child: TextFormField(
                controller: _newPassword,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Please Enter a new Password',
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 37, 116, 78)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(
                    color: const Color.fromARGB(255, 37, 116, 78), width: 2),
              ),
              child: TextFormField(
                controller: _confirmPassword,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Please Enter the new password Again',
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 37, 116, 78)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _handleUpdatePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 37, 70, 116),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 50.0),
                    ),
                    child: const Text('Update',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
          ],
        ),
      ),
    );
  }
}
