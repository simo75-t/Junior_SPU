import 'package:flutter/material.dart';
import 'package:jounior/controllers/usercontroller.dart';
import 'package:jounior/pages/login.dart';
import 'package:jounior/pages/updatePass.dart';
import '/models/usermodel.dart';

class Settingspage extends StatefulWidget {
  const Settingspage({super.key});

  @override
  State<Settingspage> createState() => _SettingspageState();
}

class _SettingspageState extends State<Settingspage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _loading = true);
    try {
      await UserController.getInfo(context);
      final user = UserController.user;
      if (user != null) {
        _usernameController.text = user.username;
        _emailController.text = user.email;
      } else {
        _usernameController.clear();
        _emailController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load user data!')),
        );
      }
    } catch (e) {
      _usernameController.clear();
      _emailController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading user info: $e')),
      );
    }
    setState(() => _loading = false);
  }

  Future<void> _deleteAccount() async {
    await UserController.delaccount(context);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  Future<void> _logout() async {
    await UserController.logout(context);
    // Navigation handled in logout()
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Profile Settings'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 37, 116, 78),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Loader only for the text fields area:
            _loading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      _buildInfoCard('Email', _emailController),
                      const SizedBox(height: 16),
                      _buildInfoCard('Username', _usernameController),
                    ],
                  ),
            if (_loading) const SizedBox(height: 60), // keeps layout nice
            const SizedBox(height: 30),
            _buildActionButton(
              label: 'Update Password',
              color: const Color.fromARGB(255, 0, 135, 40),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UpdatePassword()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildActionButton(
              label: 'Delete Account',
              color: const Color.fromARGB(255, 200, 40, 40),
              onPressed: _deleteAccount,
            ),
            const SizedBox(height: 16),
            _buildActionButton(
              label: 'Logout',
              color: const Color.fromARGB(255, 200, 40, 40),
              onPressed: _logout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        controller: controller,
        enabled: false,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Color.fromARGB(255, 37, 116, 78),
            fontWeight: FontWeight.w600,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
        ),
        child: Text(label, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
