import 'package:flutter/material.dart';

class AdminMinimalPage extends StatefulWidget {
  const AdminMinimalPage({Key? key}) : super(key: key);

  @override
  State<AdminMinimalPage> createState() => _AdminMinimalPageState();
}

class _AdminMinimalPageState extends State<AdminMinimalPage> {
  List<Map<String, String>> users = [
    {"username": "TASNIM", "email": "tasnim@gmail.com"},
    {"username": "MARYAM", "email": "maryamalbatool@gmail.com"},
    {"username": "FATIMA", "email": "fatima-zahraa@gmail.com"},
    {"username": "RANA", "email": "rana-ASS3@gmail.com"},
    {"username": "OMAR", "email": "omarZ999@gmail.com"},
  ];

  void _showAddUserDialog() {
    String? username;
    String? email;
    String? password;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New User Account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Username'),
              onChanged: (val) => username = val,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Email'),
              onChanged: (val) => email = val,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              onChanged: (val) => password = val,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('Add'),
            onPressed: () {
              if ((username?.isNotEmpty ?? false) &&
                  (email?.isNotEmpty ?? false) &&
                  (password?.isNotEmpty ?? false)) {
                setState(() {
                  users.add({
                    "username": username!,
                    "email": email!,
                    // Don't store password in UI, just showing the field.
                  });
                });
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteUserDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User Account'),
        content: Text(
            'Are you sure you want to delete "${users[index]['username']}"?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
            onPressed: () {
              setState(() {
                users.removeAt(index);
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _logout() {
    // Replace this with your logout logic or navigation
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: const Color.fromARGB(255, 37, 116, 78),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Card(
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Use Wrap for top line so no overflow!
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      const Icon(Icons.people,
                          color: Color.fromARGB(255, 37, 116, 78)),
                      const Text(
                        "User Accounts",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text("Add User Account"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 37, 116, 78),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: _showAddUserDialog,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  users.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 60),
                          child: Text(
                            "No users found.",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: users.length,
                          separatorBuilder: (_, __) =>
                              const Divider(height: 24),
                          itemBuilder: (context, index) {
                            final user = users[index];
                            return ListTile(
                              leading: const Icon(Icons.person,
                                  color: Color.fromARGB(255, 37, 116, 78)),
                              title: Text(
                                user['username'] ?? '',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                user['email'] ?? '',
                                style: const TextStyle(fontSize: 13),
                              ),
                              trailing: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                tooltip: "Delete",
                                onPressed: () => _showDeleteUserDialog(index),
                              ),
                            );
                          },
                        ),
                  const SizedBox(height: 30),
                  // Logout Button at the bottom right
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.logout, size: 20),
                        label: const Text("Logout"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: _logout,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
