import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // ADD THIS

class BreastCancerCard extends StatelessWidget {
  const BreastCancerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: const Text(
                    "BREAST CANCER DETAILS",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: const Color.fromARGB(255, 156, 153, 227),
                  foregroundColor: Colors.white,
                ),
                body: const BreastCancerDetailsPage(),
              ),
            ),
          );
        },
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 177, 148, 222),
                Color.fromARGB(255, 156, 153, 227),
                Color.fromARGB(255, 158, 188, 252),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -10,
                bottom: -10,
                child: Opacity(
                  opacity: 0.15,
                  child: Image.asset(
                    'assets/images/breast_cancer_icon.png',
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.air,
                        size: 120,
                        color: Colors.white,
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Breast Cancer",
                      style: TextStyle(
                        fontSize: 27,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Mammogram Based AI Detection",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/ai_bot.png',
                          width: 24,
                          height: 24,
                          color: Colors.white,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.smart_toy, color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "AI Detection",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          height: 38,
                          width: 38,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                            color: Color(0xFF9A95E8),
                          ),
                        ),
                      ],
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

class BreastCancerDetailsPage extends StatefulWidget {
  const BreastCancerDetailsPage({super.key});

  @override
  State<BreastCancerDetailsPage> createState() =>
      _BreastCancerDetailsPageState();
}

class _BreastCancerDetailsPageState extends State<BreastCancerDetailsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> _allDoctors = [
    {
      'name': 'Dr Noopur Patel',
      'specialization': 'Breast Cancer Surgeon\nBreast Surgical Oncology',
      'experience': '8+ Years',
      'hospital': 'Marengo CIMS Hospital',
      'location': 'Sola, Ahmedabad, Gujarat',
      'address':
          'Plot No. 67/1, Off Science City Road, Opp. Panchamrut Bunglows, Sola, Ahmedabad - 380060',
      'phone': '+91 79 3010 1257',
      'image': 'assets/Breast_Cancer/Dr. Noopur Patel.jpg',
    },
    {
      'name': 'Dr Shalin Shah',
      'specialization': 'Breast Cancer Surgeon\nSurgical Oncologist',
      'experience': '10+ Years',
      'hospital': 'SSO Cancer Hospital',
      'location': 'Bodakdev, Ahmedabad, Gujarat',
      'address':
          'Opp. Pandit Deendayal Upadhyay Auditorium Hall, Behind Rajpath Rangoli Road, Bodakdev, Ahmedabad - 380054',
      'phone': '+91 89768 97202',
      'image': 'assets/Breast_Cancer/Dr. Shalin Shah.jpg',
    },
    {
      'name': 'Dr Priyanka Chiripal',
      'specialization': 'Breast Cancer & Medical Oncology',
      'experience': '12+ Years',
      'hospital': 'Zydus Cancer Hospital',
      'location': 'Thaltej, Ahmedabad, Gujarat',
      'address':
          'Zydus Hospital, Sarkhej-Gandhinagar Highway, Thaltej, Ahmedabad - 380059',
      'phone': '+91 98254 00705',
      'image': 'assets/Breast_Cancer/Dr. Priyanka Chiripal.jpg',
    },
    {
      'name': 'Dr Honey Parekh',
      'specialization': 'Medical Oncologist\nBreast Cancer & Chemotherapy',
      'experience': '10+ Years',
      'hospital': 'V Care Hospital',
      'location': 'Surat, Gujarat',
      'address':
          '501 V Care Hospital, The Commercial Hub, Opp. Rajhans Olympia, Surat - 395001',
      'phone': '+91 90164 46014',
      'image': 'assets/Lung_Cancer/Dr. Honey Parekh.jpg',
    },
    {
      'name': 'Dr Jayesh A Prajapati',
      'specialization':
          'Breast & Gynecologic Cancer Surgeon\nRobotic Surgical Oncology',
      'experience': '15+ Years',
      'hospital': 'Wacha Clinic',
      'location': 'Ahmedabad, Gujarat',
      'address':
          '1001-1021, 10th Floor, Sun Avenue One Building, Behind Shreyas Foundation, Shyamal Cross Road, Ahmedabad - 380015',
      'phone': '+91 79 4800 4800',
      'image': 'assets/Breast_Cancer/Dr. Jayesh A Prajapati.jpg',
    },
    {
      'name': 'Dr Ankit Shah',
      'specialization': 'Breast Oncoplasty\nBreast Cancer Surgeon',
      'experience': 'Not publicly available',
      'hospital': 'Shastriji Maharaj Hospital',
      'location': 'Atladara, Vadodara, Gujarat',
      'address':
          'Shastriji Maharaj Hospital Circle, Narayanwadi, Atladara, Vadodara - 390012',
      'phone': '+91 97714 15510',
      'image': 'assets/Breast_Cancer/Dr. Ankit Shah Vadodara.jpg',
    },
    {
      'name': 'Dr Ekta Vala Chandarana',
      'specialization': 'Medical Oncologist\nBreast Cancer',
      'experience': '10+ Years',
      'hospital': 'Medisquare Superspeciality Hospital',
      'location': 'Ahmedabad, Gujarat',
      'address': 'Medisquare Superspeciality Hospital, Ahmedabad, Gujarat',
      'phone': '+91 88668 43843',
      'image': 'assets/Breast_Cancer/Dr. Ekta Vala Chandarana.jpg',
    },
    {
      'name': 'Dr Mihir Shah',
      'specialization': 'Surgical Oncologist\nBreast Cancer Surgery',
      'experience': '12+ Years',
      'hospital': 'Shalby Cancer & Research Institute (SCRI)',
      'location': 'SG Highway, Ahmedabad, Gujarat',
      'address':
          '3rd Floor, SCRI, Shalby Hospitals, Opp. Karnavati Club, SG Highway, Ahmedabad - 380015',
      'phone': '+91 70692 59255',
      'image': 'assets/Breast_Cancer/Dr. Mihir Shah.jpg',
    },
  ];
  Future<void> _makePhoneCall(String phoneNumber) async {
    // Remove spaces, newlines, and text like "Contact Hospital"
    String cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');

    if (cleanedNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Phone number not available")),
      );
      return;
    }

    final Uri phoneUri = Uri(scheme: 'tel', path: cleanedNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not call $phoneNumber")),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredDoctors = _allDoctors.where((doctor) {
      final query = _searchQuery.toLowerCase();
      return doctor['name']!.toLowerCase().contains(query) ||
          doctor['specialization']!.toLowerCase().contains(query) ||
          doctor['hospital']!.toLowerCase().contains(query) ||
          doctor['location']!.toLowerCase().contains(query) ||
          doctor['experience']!.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Find a Breast Cancer Specialist",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search Doctor",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ...filteredDoctors.map(
              (doctor) => doctorCard(
                context,
                doctorName: doctor['name']!,
                specialization: doctor['specialization']!,
                experience: doctor['experience']!,
                hospital: doctor['hospital']!,
                location: doctor['location']!,
                address: doctor['address']!,
                phone: doctor['phone']!,
                imagePath: doctor['image'] ?? '',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget doctorCard(
    BuildContext context, {
    required String doctorName,
    required String specialization,
    required String experience,
    required String hospital,
    required String location,
    required String address,
    required String phone,
    String imagePath = '',
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final String experienceText = experience.toLowerCase().contains("available")
        ? "Experience: $experience"
        : "$experience Experience";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: isDark ? 1 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor:
                        isDark ? Colors.grey[800] : const Color(0xFFECEFF1),
                    child: ClipOval(
                      child: imagePath.isNotEmpty
                          ? Image.asset(
                              imagePath,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  size: 32,
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                );
                              },
                            )
                          : Icon(
                              Icons.person,
                              size: 32,
                              color:
                                  isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctorName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          specialization,
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.textTheme.bodySmall?.color ??
                                Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.work_history_outlined,
                              size: 14,
                              color: Color(0xFF9A95E8),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                experienceText,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF9A95E8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Icon(
                    Icons.local_hospital,
                    size: 16,
                    color: theme.iconTheme.color?.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "$hospital ($location)",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: theme.iconTheme.color?.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      address,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.textTheme.bodySmall?.color ?? Colors.grey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _makePhoneCall(phone), // CHANGED: NOW CALLS
                  icon: const Icon(Icons.phone, size: 18),
                  label: Text(phone),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9A95E8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
