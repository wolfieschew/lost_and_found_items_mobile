import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String nim;
  final String email;
  final String phoneNumber;
  final String address;

  const EditProfilePage({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.nim,
    required this.email,
    required this.phoneNumber,
    required this.address,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController nimController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController locationController;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.firstName);
    lastNameController = TextEditingController(text: widget.lastName);
    nimController = TextEditingController(text: widget.nim);
    emailController = TextEditingController(text: widget.email);
    phoneController = TextEditingController(text: widget.phoneNumber);
    locationController = TextEditingController(text: widget.address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Foto profil
                const CircleAvatar(
                  radius: 45,
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ),

                Positioned(
                  bottom: 1,
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      width: 90,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(45),
                          bottomRight: Radius.circular(45),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Ubah',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Card(
              elevation: 2,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Text(
                          'Personal Information',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Icon(Icons.edit, size: 18),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 12),
                    buildTextField('First Name', firstNameController),
                    buildTextField('Last Name', lastNameController),
                    buildTextField('NIM', nimController),
                    buildTextField('Email', emailController),
                    buildTextField('Phone Number', phoneController),
                    buildTextField('Current Location', locationController),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'firstName': firstNameController.text,
                    'lastName': lastNameController.text,
                    'nim': nimController.text,
                    'email': emailController.text,
                    'phoneNumber': phoneController.text,
                    'address': locationController.text,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004274),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
