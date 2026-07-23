import 'package:flutter/material.dart';

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
                  title: const Text("LUNG CANCER DETAILS",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),),
                  backgroundColor: Color.fromARGB(255, 156, 153, 227),
                  foregroundColor: Colors.white,
                ),
                body: const LungCancerDetailsPage(),
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
                      "Lung Cancer",
                      style: TextStyle(
                        fontSize: 27,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Chest X-Ray Based AI Detection",
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
class LungCancerDetailsPage extends StatelessWidget {
  const LungCancerDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Find a lung Cancer Specialist",
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
              doctorName: "Dr Abhishek Jain",
              specialization:
              "Breast and Thoracic Oncosurgeon\nLung Cancer Specialist",
              hospital: "Marengo CIMS Hospital",
              location: "Sola Ahmedabad Gujarat",
              address:
              "Plot Number 67/1 Off Science City Road Opposite Panchamrut Bunglows Sola Ahmedabad Gujarat 380060",
              phone: "+91 79 3010 1257",
            ),

            doctorCard(
              context,
              doctorName: "Dr Kshitij Domadia",
              specialization:
              "Medical Oncologist\nLung Cancer Head and Neck Cancer",
              hospital: "HCG Aastha Cancer Centre",
              location: "Sola Ahmedabad Gujarat",
              address:
              "Near Bhagwat Vidyapith Sola Ahmedabad Gujarat 380060",
              phone: "+91 81605 07838",
            ),

            doctorCard(
              context,

              doctorName: "Dr Rushabh Kothari",
              specialization: "Medical Oncologist\nLung Cancer",
              hospital: "Oncowin Cancer Center",
              location: "Ahmedabad Gujarat",
              address: "Ahmedabad Gujarat",
              phone: "Contact Hospital",
            ),

            doctorCard(
              context,
              doctorName: "Dr Palak Bhatt",
              specialization:
              "Medical Oncologist\nLung and Breast Cancer",
              hospital: "Oncowin Cancer Center",
              location: "Ahmedabad Gujarat",
              address: "Ahmedabad Gujarat",
              phone: "Contact Hospital",
            ),

            doctorCard(
              context,
              doctorName: "Dr Sarav Shah",
              specialization:
              "Surgical Oncologist\nThoracic and Lung Cancer",
              hospital: "Marengo CIMS Hospital",
              location: "Science City Ahmedabad Gujarat",
              address:
              "Basement OPD 14 West Building Science City Road Sola Ahmedabad Gujarat",
              phone: "+91 95868 77277",
            ),

            doctorCard(
              context,
              doctorName: "Dr Honey Parekh",
              specialization:
              "Medical Oncologist\nLung Breast and Blood Cancer",
              hospital: "V Care Hospital",
              location: "Surat Gujarat",
              address:
              "501 V Care Hospital The Commercial Hub Surat Gujarat 395001",
              phone: "+91 90164 46014",
            ),

            doctorCard(
              context,
              doctorName: "Dr Amit Gupta",
              specialization:
              "Surgical Oncologist\nLung Head and Neck Cancer",
              hospital: "Cancer Care Surat",
              location: "Ring Road Surat Gujarat",
              address:
              "4th Floor Zenon Building Ring Road Surat Gujarat 395002",
              phone: "+91 87800 42486",
            ),

            doctorCard(
              context,
              doctorName: "Dr Shashank Pandya",
              specialization:
              "Surgical Oncologist\nThoracic and Lung Cancer",
              hospital: "The Gujarat Cancer and Research Institute",
              location: "Asarwa Ahmedabad Gujarat",
              address:
              "Civil Hospital Campus Asarwa Ahmedabad Gujarat 380016",
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
