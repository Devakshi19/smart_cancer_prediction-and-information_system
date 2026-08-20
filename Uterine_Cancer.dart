import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // ADD THIS
import '../screens/scan_pages.dart';

class UterineCancerCard extends StatelessWidget {
  const UterineCancerCard({super.key});

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
                    "UTERINE CANCER DETAILS",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: const Color.fromARGB(255, 156, 153, 227),
                  foregroundColor: Colors.white,
                ),
                body: const UterineCancerDetailsPage(),
              ),
            ),
          );
        },
        child: Container(
          height: 190,
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
                child: Icon(
                  Icons.health_and_safety,
                  size: 120,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Uterine Cancer",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Uterine Cancer AI Detection",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.smart_toy, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            "AI Detection",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Container(
                          height: 36,
                          width: 36,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
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

class UterineCancerDetailsPage extends StatefulWidget {
  const UterineCancerDetailsPage({super.key});

  @override
  State<UterineCancerDetailsPage> createState() =>
      _UterineCancerDetailsPageState();
}

class _UterineCancerDetailsPageState extends State<UterineCancerDetailsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> _allDoctors = [
    {
      'name': 'Dr Viral Patel',
      'specialization':
          'Gynecologic Oncologist\nUterine, Ovarian & Cervical Cancer',
      'experience': '10–12+ Years',
      'hospital': 'HCG Aastha Cancer Centre',
      'location': 'Sola, Ahmedabad, Gujarat',
      'address':
          'Bhagwat Vidyapith Road, Opp. Bhagwat Vidyapith Gate, Sola, Ahmedabad - 380060',
      'phone': '+91 77365 24011',
      'image': 'assets/Uterine_Cancer/Dr. Viral Patel HCG.jpg',
    },
    {
      'name': 'Dr Swati Shah',
      'specialization':
          'Gynecologic Oncologist\nRobotic Cancer Surgeon\nUterus, Ovary & Cervix Cancer',
      'experience': '10+ Years',
      'hospital': 'Shahs Cancer & Robotic Surgery Centre',
      'location': 'Gota, Ahmedabad, Gujarat',
      'address': 'SF-203 Olive Greens, SG Highway, Gota, Ahmedabad - 382481',
      'phone': '+91 89800 20898',
      'image': 'assets/Uterine_Cancer/Dr. Swati Shah.jpg',
    },
    {
      'name': 'Dr Mona Naman Shah',
      'specialization': 'Gynecologic Oncosurgeon\nRobotic Surgeon',
      'experience': 'Not publicly available',
      'hospital': 'Zydus Cancer Centre',
      'location': 'Thaltej, Ahmedabad, Gujarat',
      'address': 'Zydus Hospital Road, Thaltej, Ahmedabad - 380054',
      'phone': '+91 98795 05063',
      'image': 'assets/Uterine_Cancer/Dr. Mona Naman Shah.jpg',
    },
    {
      'name': 'Dr Nishtha Tripathi Patel',
      'specialization':
          'Gynecologic Oncologist\nUterine, Ovarian & Cervical Cancer',
      'experience': '12+ Years',
      'hospital': 'Sterling Hospital',
      'location': 'Ahmedabad, Gujarat',
      'address': 'Sterling Hospital, Sindhu Bhavan Road, Ahmedabad',
      'phone': '+91 76988 00333',
      'image': 'assets/Uterine_Cancer/Dr. Nishtha Tripathi Patel.jpg',
    },
    {
      'name': 'Dr Ankit Shah',
      'specialization': 'Gynecological Cancer Surgeon\nSurgical Oncologist',
      'experience': 'Not publicly available',
      'hospital': 'Shastriji Maharaj Hospital',
      'location': 'Atladara, Vadodara, Gujarat',
      'address':
          'Shastriji Maharaj Hospital Circle, Narayanwadi, Atladara, Vadodara - 390007',
      'phone': '+91 97714 15510',
      'image': 'assets/Uterine_Cancer/Dr. Ankit Shah.jpg',
    },
    {
      'name': 'Dr Viral Patel',
      'specialization': 'Gynecologic Oncologist',
      'experience': '10–12+ Years',
      'hospital': 'Synergy Superspeciality Hospital',
      'location': 'Rajkot, Gujarat',
      'address':
          'Synergy Circle, 150 Feet Ring Road, Opp. Gokul Mathura Apartment, Rajkot - 360005',
      'phone': '+91 77365 24011',
      'image': 'assets/Uterine_Cancer/Dr. Viral Patel Rajkot.jpg',
    },
    {
      'name': 'Dr Amit Gupta',
      'specialization':
          'Surgical Oncologist\nGynecologic & Uterine Cancer Surgery',
      'experience': 'Not publicly available',
      'hospital': 'Surat Oncology Centre',
      'location': 'Surat, Gujarat',
      'address':
          'Second Floor, Zenon Building, Opp. Unique Hospital, Near Kiran Motors, Khatodra Wadi, Surat - 395002',
      'phone': '+91 97372 67579',
      'image': 'assets/Uterine_Cancer/Dr. Amit Gupta Surat.jpg',
    },
    {
      'name': 'Dr Jignesh Shah',
      'specialization':
          'Gynecologic Oncology\nUterine, Ovarian & Cervical Cancer',
      'experience': 'Not publicly available',
      'hospital': 'The Gujarat Cancer & Research Institute (GCRI)',
      'location': 'Asarwa, Ahmedabad, Gujarat',
      'address': 'Civil Hospital Campus, Haripura, Asarwa, Ahmedabad - 380016',
      'phone': '+91 79 2268 8000',
      'image': 'assets/Uterine_Cancer/Dr. Jignesh Shah Civil.jpg',
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
              "Find a Uterine Cancer Specialist",
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFC084FC),
        icon: const Icon(Icons.document_scanner_outlined, color: Colors.white),
        label: const Text(
          "AI Scan Pelvic US / Biopsy",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ScanPage(initialCategory: 'Uterine'),
            ),
          );
        },
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
                  Icon(Icons.local_hospital,
                      size: 16,
                      color: theme.iconTheme.color?.withValues(alpha: 0.6)),
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
                  Icon(Icons.location_on,
                      size: 16,
                      color: theme.iconTheme.color?.withValues(alpha: 0.6)),
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
