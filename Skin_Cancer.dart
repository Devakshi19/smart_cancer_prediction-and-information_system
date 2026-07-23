import 'package:flutter/material.dart';

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

class SkinCancerDetailsPage extends StatelessWidget {
  const SkinCancerDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              decoration: InputDecoration(
                hintText: "Search Doctor",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  filterChip(context, "Location"),
                  const SizedBox(width: 10),
                  filterChip(context, "Hospital"),
                  const SizedBox(width: 10),
                  filterChip(context, "Specialization"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            doctorCard(
              context,
              doctorName: "Dr Viral Patel",
              specialization: "Gynecologic Oncologist\nUterine, Ovarian & Cervical Cancer",
              hospital: "HCG Aastha Cancer Centre",
              location: "Sola, Ahmedabad",
              address: "Bhagwat Vidyapith Road, Opp. Bhagwat Vidyapith Gate, Sola, Ahmedabad - 380060",
              phone: "+91 77365 24011",
            ),
            doctorCard(
              context,
              doctorName: "Dr Swati Shah",
              specialization: "Gynecologic Oncologist\nRobotic Cancer Surgeon",
              hospital: "Shahs Cancer & Robotic Surgery Centre",
              location: "Gota, Ahmedabad",
              address: "SF-203 Olive Greens, SG Highway, Gota, Ahmedabad - 382481",
              phone: "+91 89800 20898",
            ),
            doctorCard(
              context,
              doctorName: "Dr Mona Naman Shah",
              specialization: "Gynecologic Oncosurgeon\nRobotic Surgeon",
              hospital: "Zydus Cancer Centre",
              location: "Thaltej, Ahmedabad",
              address: "Zydus Hospital Road, Thaltej, Ahmedabad - 380054",
              phone: "+91 98795 05063",
            ),
            doctorCard(
              context,
              doctorName: "Dr Nishtha Tripathi Patel",
              specialization: "Gynecologic Oncologist\nUterine, Ovarian & Cervical Cancer",
              hospital: "Sterling Hospital",
              location: "Ahmedabad",
              address: "Sterling Hospital, Sindhu Bhavan Road, Ahmedabad",
              phone: "+91 76988 00333",
            ),
            doctorCard(
              context,
              doctorName: "Dr Ankit Shah",
              specialization: "Gynecological Cancer Surgeon\nSurgical Oncologist",
              hospital: "Shastriji Maharaj Hospital",
              location: "Atladara, Vadodara",
              address: "Hospital Circle, Narayanwadi, Atladara, Vadodara - 390007",
              phone: "+91 97714 15510",
            ),
            doctorCard(
              context,
              doctorName: "Dr Viral Patel",
              specialization: "Gynecologic Oncologist",
              hospital: "Synergy Superspeciality Hospital",
              location: "Rajkot",
              address: "150 Feet Ring Road, Rajkot - 360005",
              phone: "+91 77365 24011",
            ),
            doctorCard(
              context,
              doctorName: "Dr Amit Gupta",
              specialization: "Surgical Oncologist\nGynecologic & Uterine Cancer Surgery",
              hospital: "Surat Oncology Centre",
              location: "Surat",
              address: "Zenon Building, Khatodra Wadi, Surat - 395002",
              phone: "+91 97372 67579",
            ),
            doctorCard(
              context,
              doctorName: "Dr Jignesh Shah",
              specialization: "Gynecologic Oncology\nUterine, Ovarian & Cervical Cancer",
              hospital: "GCRI",
              location: "Asarwa, Ahmedabad",
              address: "Civil Hospital Campus, Asarwa, Ahmedabad - 380016",
              phone: "+91 79 2268 8000",
            ),
          ],
        ),
      ),
    );
  }

  Widget filterChip(BuildContext context, String title) {
    return Chip(
      label: Text(title),
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.2)),
      ),
    );
  }

  Widget doctorCard(
      BuildContext context, {
        required String doctorName,
        required String specialization,
        required String hospital,
        required String location,
        required String address,
        required String phone,
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
                    backgroundColor: isDark ? Colors.grey[800] : const Color(0xFFECEFF1),
                    child: Icon(Icons.person, size: 32, color: isDark ? Colors.grey[400] : Colors.grey[600]),
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
                            color: theme.textTheme.bodySmall?.color ?? Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Icon(Icons.local_hospital, size: 16, color: theme.iconTheme.color?.withValues(alpha: 0.6)),
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
                  Icon(Icons.location_on, size: 16, color: theme.iconTheme.color?.withValues(alpha: 0.6)),
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
                  onPressed: () {},
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
