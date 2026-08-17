import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String age;
  final String weight;
  final String height;
  final String gender;

  const EditProfilePage({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    required this.weight,
    required this.height,
    required this.gender,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController ageController;
  late TextEditingController weightController;
  late TextEditingController heightController;
  late String selectedGender;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.name);
    emailController = TextEditingController(text: widget.email);
    phoneController = TextEditingController(text: widget.phone);
    ageController = TextEditingController(text: widget.age);
    weightController = TextEditingController(text: widget.weight);
    heightController = TextEditingController(text: widget.height);
    selectedGender = widget.gender;
  }

  Widget buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: const Color.fromARGB(255, 156, 153, 227),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              buildField("Name", nameController),
              buildField("Email", emailController),
              buildField("Phone", phoneController),
              buildField("Age", ageController),
              buildField("Weight", weightController),
              buildField("Height", heightController),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: DropdownButtonFormField<String>(
                  value: ['Female', 'Male', 'Other'].contains(selectedGender) ? selectedGender : 'Female',
                  decoration: InputDecoration(
                    labelText: "Gender",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: ['Female', 'Male', 'Other']
                      .map((label) => DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value ?? 'Female';
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    "name": nameController.text,
                    "email": emailController.text,
                    "phone": phoneController.text,
                    "age": ageController.text,
                    "weight": weightController.text,
                    "height": heightController.text,
                    "gender": selectedGender,
                  });
                },
                child: const Text("Save"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
