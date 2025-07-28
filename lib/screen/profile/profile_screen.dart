import 'package:booking/screen/auth/ChangePass.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _firstName = "John";
  String _lastName = "Doe";
  String _email = "john.doe@email.com";
  String _phoneNumber = "09981234567";
  String _username = "johndoe123";

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isEditingFirstName = false;
  bool _isEditingLastName = false;
  bool _isEditingEmail = false;
  bool _isEditingPhone = false;

  @override
  void initState() {
    super.initState();
    _firstNameController.text = _firstName;
    _lastNameController.text = _lastName;
    _emailController.text = _email;
    _phoneController.text = _phoneNumber;
  }

  void _updateProfile() {
    setState(() {
      _firstName = _firstNameController.text;
      _lastName = _lastNameController.text;
      _email = _emailController.text;
      _phoneNumber = _phoneController.text;

      _isEditingFirstName = false;
      _isEditingLastName = false;
      _isEditingEmail = false;
      _isEditingPhone = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated successfully!")),
    );
  }

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required bool isEditing,
    required VoidCallback onToggleEdit,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: !isEditing,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isEditing ? Icons.check : Icons.edit,
            color: Colors.white,
          ),
          onPressed: onToggleEdit,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0f9ba8), Color(0xFF006d77)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black, size: 26),
                      onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxWidth: 400),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                const CircleAvatar(
                                  radius: 56,
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.person, size: 64, color: Colors.black38),
                                ),
                                Positioned(
                                  right: 6,
                                  bottom: 6,
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: const Icon(Icons.edit, size: 20, color: Colors.black),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _username,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 24),
                            _buildEditableField(
                              label: 'First Name',
                              controller: _firstNameController,
                              isEditing: _isEditingFirstName,
                              onToggleEdit: () {
                                setState(() {
                                  _isEditingFirstName = !_isEditingFirstName;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildEditableField(
                              label: 'Last Name',
                              controller: _lastNameController,
                              isEditing: _isEditingLastName,
                              onToggleEdit: () {
                                setState(() {
                                  _isEditingLastName = !_isEditingLastName;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildEditableField(
                              label: 'Email',
                              controller: _emailController,
                              isEditing: _isEditingEmail,
                              onToggleEdit: () {
                                setState(() {
                                  _isEditingEmail = !_isEditingEmail;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildEditableField(
                              label: 'Phone Number',
                              controller: _phoneController,
                              isEditing: _isEditingPhone,
                              onToggleEdit: () {
                                setState(() {
                                  _isEditingPhone = !_isEditingPhone;
                                });
                              },
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: _updateProfile,
                                child: const Text(
                                  "Update Profile",
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                                  );
                                },
                                child: const Text(
                                  "Change Password",
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
