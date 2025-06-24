import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jounior/controllers/usercontroller.dart';
import 'package:jounior/pages/login.dart'; // Assuming this is the correct path

class AdminMinimalPage extends StatefulWidget {
  const AdminMinimalPage({Key? key}) : super(key: key);

  @override
  State<AdminMinimalPage> createState() => _AdminMinimalPageState();
}

class _AdminMinimalPageState extends State<AdminMinimalPage> {
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  // Fetch users when the page is loaded
  void _loadUsers() async {
    List<Map<String, dynamic>> fetchedUsers = await UserController.fetchUsers();
    setState(() {
      users = fetchedUsers;
    });
  }

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
            onPressed: () async {
              if ((username?.isNotEmpty ?? false) &&
                  (email?.isNotEmpty ?? false) &&
                  (password?.isNotEmpty ?? false)) {
                bool success = await UserController.addUser(
                  username!,
                  email!,
                  password!,
                );
                if (success) {
                  _loadUsers(); // Refresh the user list after adding
                  Navigator.pop(context);
                }
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
            onPressed: () async {
              bool success = await UserController.deleteUser(
                  (users[index]['id'] is int)
                      ? users[index]['id']
                      : int.tryParse(users[index]['id'].toString()) ?? 0);
              if (success) {
                setState(() {
                  users.removeAt(index); // Remove the deleted user
                });
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _logout() {
    // Replace this with your logout logic or navigation
    // Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
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
                      ElevatedButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: const Text("Refresh "),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 37, 116, 78),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: _loadUsers,
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
                      : Expanded(
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: users.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 24),
                            itemBuilder: (context, index) {
                              final user = users[index];
                              return ListTile(
                                leading: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Icon(Icons.person),
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: user['is_active'] == true
                                            ? Colors.green
                                            : Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ),
                                title: Text(user['username'] ?? 'N/A'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(user['email'] ?? 'N/A'),
                                    Text("Join Date " +
                                        _formatDate(
                                            user['date_joined'] ?? 'N/A')),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  tooltip: "Delete",
                                  onPressed: () => _showDeleteUserDialog(index),
                                ),
                              );
                            },
                          ),
                        ),
                  const SizedBox(height: 30),
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

String _formatDate(String? date) {
  if (date == null) return 'N/A';
  try {
    // Parsing the date string into DateTime
    DateTime parsedDate = DateTime.parse(date);
    // Formatting the DateTime into a human-readable format
    return DateFormat('yyyy-MMM-dd')
        .format(parsedDate); // You can change the format here
  } catch (e) {
    print('Error parsing date: $e');
    return 'Invalid date'; // Return a fallback string in case of error
  }
}
