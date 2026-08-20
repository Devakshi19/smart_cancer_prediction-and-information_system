import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/scan_pages.dart';

class LungCancerCard extends StatelessWidget {
  const LungCancerCard({super.key});

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
                    "LUNG CANCER DETAILS",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: const Color.fromARGB(255, 156, 153, 227),
                  foregroundColor: Colors.white,
                ),
                body: const LungCancerDetailsPage(),
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
                  Icons.air,
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
                          "Lung Cancer",
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
                          "Chest X-Ray Based AI Detection",
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

class LungCancerDetailsPage extends StatefulWidget {
  const LungCancerDetailsPage({super.key});

  @override
  State<LungCancerDetailsPage> createState() => _LungCancerDetailsPageState();
}

class _LungCancerDetailsPageState extends State<LungCancerDetailsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> _allDoctors = [
    {
      'name': 'Dr Abhishek Jain',
      'specialization':
          'Breast and Thoracic Oncosurgeon\nLung Cancer Specialist',
      'experience': '15+ Years',
      'hospital': 'Marengo CIMS Hospital',
      'location': 'Sola Ahmedabad Gujarat',
      'address':
          'Plot Number 67/1 Off Science City Road Opposite Panchamrut Bunglows Sola Ahmedabad Gujarat 380060',
      'phone': '+91 79 3010 1257',
      'image': 'assets/Lung_Cancer/Dr. Abhishek Jain.jpg',
    },
    {
      'name': 'Dr Kshitij Domadia',
      'specialization': 'Medical Oncologist\nLung Cancer Head and Neck Cancer',
      'experience': '10+ Years',
      'hospital': 'HCG Aastha Cancer Centre',
      'location': 'Sola Ahmedabad Gujarat',
      'address': 'Near Bhagwat Vidyapith Sola Ahmedabad Gujarat 380060',
      'phone': '+91 81605 07838',
      'image': 'assets/Lung_Cancer/Dr. Kshitji Domadia.jpg',
    },
    {
      'name': 'Dr Rushabh Kothari',
      'specialization': 'Medical Oncologist\nLung Cancer',
      'experience': '8+ Years',
      'hospital': 'Oncowin Cancer Center',
      'location': 'Ahmedabad Gujarat',
      'address': 'Ahmedabad Gujarat',
      'phone': 'Contact Hospital',
      'image': 'assets/Lung_Cancer/Dr. Rushabh Kothari.jpeg',
    },
    {
      'name': 'Dr Palak Bhatt',
      'specialization': 'Medical Oncologist\nLung and Breast Cancer',
      'experience': '8+ Years',
      'hospital': 'Oncowin Cancer Center',
      'location': 'Ahmedabad Gujarat',
      'address': 'Ahmedabad Gujarat',
      'phone': 'Contact Hospital',
      'image': 'assets/Lung_Cancer/Dr. Palak Bhatt.jpg',
    },
    {
      'name': 'Dr Sarav Shah',
      'specialization': 'Surgical Oncologist\nThoracic and Lung Cancer',
      'experience': '12+ Years',
      'hospital': 'Marengo CIMS Hospital',
      'location': 'Science City Ahmedabad Gujarat',
      'address':
          'Basement OPD 14 West Building Science City Road Sola Ahmedabad Gujarat',
      'phone': '+91 95868 77277',
      'image': 'assets/Lung_Cancer/Dr. Sarav Shah.jpg',
    },
    {
      'name': 'Dr Honey Parekh',
      'specialization': 'Medical Oncologist\nLung Breast and Blood Cancer',
      'experience': '10+ Years',
      'hospital': 'V Care Hospital',
      'location': 'Surat Gujarat',
      'address': '501 V Care Hospital The Commercial Hub Surat Gujarat 395001',
      'phone': '+91 90164 46014',
      'image': 'assets/Lung_Cancer/Dr. Honey Parekh.jpg',
    },
    {
      'name': 'Dr Amit Gupta',
      'specialization': 'Surgical Oncologist\nLung Head and Neck Cancer',
      'experience': '15+ Years',
      'hospital': 'Cancer Care Surat',
      'location': 'Ring Road Surat Gujarat',
      'address': '4th Floor Zenon Building Ring Road Surat Gujarat 395002',
      'phone': '+91 87800 42486',
      'image': 'assets/Lung_Cancer/Dr. Amit Gupta.jpg',
    },
    {
      'name': 'Dr Shashank Pandya',
      'specialization': 'Surgical Oncologist\nThoracic and Lung Cancer',
      'experience': '18+ Years',
      'hospital': 'The Gujarat Cancer and Research Institute',
      'location': 'Asarwa Ahmedabad Gujarat',
      'address': 'Civil Hospital Campus Asarwa Ahmedabad Gujarat 380016',
      'phone': '+91 79 2268 8000',
      'image': 'assets/Lung_Cancer/Dr. Shashank Pandya.jpg',
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ScanPage(initialCategory: 'Lung'),
            ),
          );
        },
        backgroundColor: const Color(0xFF9181F4),
        icon: const Icon(Icons.document_scanner_outlined, color: Colors.white),
        label: const Text(
          "AI Scan Chest X-Ray / CT",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Find a Lung Cancer Specialist",
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
