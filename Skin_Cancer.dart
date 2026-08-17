import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // ADD THIS


class SkinCancerCard extends StatelessWidget {
  const SkinCancerCard({super.key});

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
                    "SKIN CANCER DETAILS",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: const Color.fromARGB(255, 156, 153, 227),
                  foregroundColor: Colors.white,
                ),
                body: const SkinCancerDetailsPage(),
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
                child: Icon(
                  Icons.air,
                  size: 120,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Skin Cancer",
                      style: TextStyle(
                        fontSize: 27,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Skin Cancer AI Detection",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(
                          Icons.smart_toy,
                          color: Colors.white,
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

class SkinCancerDetailsPage extends StatefulWidget {
  const SkinCancerDetailsPage({super.key});

  @override
  State<SkinCancerDetailsPage> createState() => _SkinCancerDetailsPageState();
}

class _SkinCancerDetailsPageState extends State<SkinCancerDetailsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> _allDoctors = [
    {
      'name': 'Dr Murtuza I Laxmidhar',
      'specialization': 'Surgical Oncologist\nSkin Cancer',
      'experience': '22+ Years',
      'hospital': 'Apollo Cancer Centre',
      'location': 'Ellisbridge, Ahmedabad, Gujarat',
      'address':
          'Akshara Complex, 12 Shanti Sadan Co-op Housing Society Ltd., Near Parimal Garden, Ellisbridge, Ahmedabad - 380006',
      'phone': '+91 84018 01066',
      'imagePath': 'assets/Dr. Murtuza I. Laxmidhar.jpg',
    },
    {
      'name': 'Dr V R N Vijay Kumar',
      'specialization': 'Surgical Oncologist\nSkin Cancer',
      'experience': '9+ Years',
      'hospital': 'Apollo Hospital',
      'location': 'Bhat, Gandhinagar, Gujarat',
      'address':
          'Block A, Apollo Hospitals International Ltd., Bhat GIDC Industrial Estate, Gandhinagar - 382428',
      'phone': '+91 83695 64934',
      'imagePath': 'assets/Dr. V. R. N. Vijay Kumar.jpg',
    },
    {
      'name': 'Dr Bhavesh Parekh',
      'specialization': 'Medical Oncologist',
      'experience': '20+ Years',
      'hospital': 'HCG Aastha Cancer Hospital',
      'location': 'Sola, Ahmedabad, Gujarat',
      'address': 'Opp. Bhagwat Vidyapith, Sola, Ahmedabad - 380060',
      'phone': '+91 80653 41327',
      'imagePath': 'assets/Dr. Bhavesh Parekh.jpg',
    },
    {
      'name': 'Dr Anand Shah',
      'specialization': 'Surgical Oncologist\nSkin Cancer',
      'experience': '8+ Years',
      'hospital': 'Anand Onco Care',
      'location': 'Surat, Gujarat',
      'address':
          '206, Accron Trade Center, Civil Char Rasta, Ring Road, Khatodra Wadi, Surat - 395002',
      'phone': '+91 88494 75805',
      'imagePath': 'assets/Dr. Anand Shah.jpg',
    },
    {
      'name': 'Dr Bhargav Trivedi',
      'specialization': 'Surgical Oncologist',
      'experience': '15+ Years',
      'hospital': 'Cancer Care Centre',
      'location': 'Jamnagar, Gujarat',
      'address':
          '302, Adeshwer Plaza, Near Maruti Restaurant, Digvijay Plot, Jamnagar - 361005',
      'phone': '+91 74900 37365',
      'imagePath': 'assets/Dr. Bhargav Trivedi.jpg',
    },
    {
      'name': 'Dr Dipayan Nandy',
      'specialization': 'Medical Oncologist',
      'experience': '11+ Years (17 years overall)',
      'hospital': 'The Cancer Clinic',
      'location': 'Vadodara, Gujarat',
      'address':
          '415-417, Gangotri Icon, Opp. Gokul Party Plot, Gotri Vasna Road, Vadodara - 390007',
      'phone': '+91 87996 70646',
      'imagePath': 'assets/Dr. dipayan nandy.jpg',
    },
    {
      'name': 'Dr Jignesh Shah',
      'specialization': 'Surgical Oncologist',
      'experience': '20+ Years',
      'hospital': 'The Gujarat Cancer and Research Institute (GCRI)',
      'location': 'Asarwa, Ahmedabad, Gujarat',
      'address': 'Civil Hospital Campus, Asarwa, Ahmedabad - 380016',
      'phone': '+91 79 2268 8000',
      'imagePath': 'assets/Dr. jignesh shah.jpg',
    },
    {
      'name': 'Dr Akash Shah',
      'specialization': 'Medical Oncologist',
      'experience': '14+ Years',
      'hospital': 'Apollo Hospital',
      'location': 'Bhat, Gandhinagar, Gujarat',
      'address':
          'Plot No. 1A, Bhat GIDC Industrial Estate, Gandhinagar - 382428',
      'phone': '+91 79 6673 6673',
      'imagePath': 'assets/Dr. Akash Shah.jpg',
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
              "Find a Skin Cancer Specialist",
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
                imagePath: doctor['imagePath'],
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
    String? imagePath,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                    foregroundImage:
                        imagePath != null ? AssetImage(imagePath) : null,
                    child: Icon(
                      Icons.person,
                      size: 32,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
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
                                "$experience Experience",
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
