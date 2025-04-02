import 'package:flutter/material.dart';
import 'package:pocket_flow/screens/loading_page.dart';
import 'package:pocket_flow/services/api_services.dart';
import 'package:pocket_flow/widgets/bottom_navbar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore_for_file: use_build_context_synchronously

class UpdateAccountPage extends StatefulWidget {
  final Map<String, dynamic>? user;
  const UpdateAccountPage({
    super.key,
    required this.user,
  });

  @override
  State<UpdateAccountPage> createState() => _UpdateAccountPageState();
}

class _UpdateAccountPageState extends State<UpdateAccountPage> {
  final ApiService apiService = ApiService();
  late Map<String, dynamic> user;
  int? userId;

  @override
  void initState() {
    super.initState();
    _getUserId();
    user = Map<String, dynamic>.from(widget.user ?? {});
  }

  Future<void> _saveToDatabase() async {
    try {
      if (userId == null) {
        throw Exception('Invalid user ID: $userId');
      }

      await apiService.updateUser(
        userId!,
        username: user.containsKey('username') ? user['username'] : null,
        email: user.containsKey('email') ? user['email'] : null,
        password: user.containsKey('password') ? user['password'] : null,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User updated successfully')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoadingPage(
            page: BottomNavbarWidget(),
          ),
        ),
      );
    } catch (e) {
      debugPrint("Error updating user: $e"); // Debugging log
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId');
  }

  void _showEditDialog(String key, String currentValue) {
    final TextEditingController controller =
        TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $key'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  user[key] = controller.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();
    bool isPasswordVisible = false;
    bool isConfirmPasswordVisible = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Change Password'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: passwordController,
                    obscureText: !isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: !isConfirmPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isConfirmPasswordVisible =
                                !isConfirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (passwordController.text ==
                        confirmPasswordController.text) {
                      setState(() {
                        user['password'] = passwordController.text;
                      });
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Passwords do not match'),
                        ),
                      );
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Update Account'),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              ...user.entries.map((entry) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(
                      entry.key,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(user[entry.key].toString()),
                    trailing: const Icon(Icons.edit),
                    onTap: () =>
                        _showEditDialog(entry.key, user[entry.key].toString()),
                  ),
                );
              }),
              Card(
                color: Colors.blueAccent,
                child: ListTile(
                  title: const Text(
                    'Change Password',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  trailing: const Icon(Icons.lock, color: Colors.white),
                  onTap: _showChangePasswordDialog,
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveToDatabase,
                child: const Text('บันทึก'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
