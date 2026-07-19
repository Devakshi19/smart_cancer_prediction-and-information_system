import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),

      appBar: AppBar(
        title: const Text("SCAN HISTORY"),
        backgroundColor: const Color(0xFF9C99E3),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: ListView(
        padding: const EdgeInsets.all(15),

        children: const [

          HistoryCard(
            cancerType: "Breast Cancer",
            date: "12 July 2026",
            time: "10:30 AM",
            result: "Normal",
            confidence: "98%",
            hospital: "AI Medical Center",
            icon: Icons.favorite,
            color: Colors.pink,
          ),

          SizedBox(height: 15),
          HistoryCard(
            cancerType: "Uterine cancer",
            date: "5 July 2026",
            time: "10:00 AM",
            result: "Normal",
            confidence: "89",
            hospital: "AI Medical Center",
            icon: Icons.favorite,
            color: Colors.yellow,
          ),

          SizedBox(height: 15),

          HistoryCard(
            cancerType: "Skin Cancer",
            date: "10 July 2026",
            time: "2:15 PM",
            result: "Suspicious",
            confidence: "91%",
            hospital: "Cancer Care Hospital",
            icon: Icons.health_and_safety,
            color: Colors.orange,
          ),

          SizedBox(height: 15),

          HistoryCard(
            cancerType: "Lung Cancer",
            date: "05 July 2026",
            time: "9:45 AM",
            result: "Normal",
            confidence: "96%",
            hospital: "Apollo Hospital",
            icon: Icons.air,
            color: Colors.blue,
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF9C99E3),
        child: const Icon(Icons.download, color: Colors.white),
        onPressed: () {
          // Download all reports
        },
      ),
    );
  }
}

class HistoryCard extends StatelessWidget {
  final String cancerType;
  final String date;
  final String time;
  final String result;
  final String confidence;
  final String hospital;
  final IconData icon;
  final Color color;

  const HistoryCard({
    super.key,
    required this.cancerType,
    required this.date,
    required this.time,
    required this.result,
    required this.confidence,
    required this.hospital,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),

      child: Padding(
        padding: const EdgeInsets.all(15),

        child: Column(
          children: [

            Row(
              children: [

                CircleAvatar(
                  radius: 26,
                  // ignore: deprecated_member_use
                  backgroundColor: color.withOpacity(0.15),
                  child: Icon(icon, color: color, size: 28),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        cancerType,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        hospital,
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Divider(height: 25),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                const Text(
                  "Scan Date",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                Text(date),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                const Text(
                  "Time",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                Text(time),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                const Text(
                  "AI Result",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                Chip(
                  backgroundColor: result == "Normal"
                      ? Colors.green.shade100
                      : Colors.red.shade100,

                  label: Text(
                    result,
                    style: TextStyle(
                      color: result == "Normal"
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                const Text(
                  "Confidence",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                Text(
                  confidence,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Row(
              children: [

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.visibility),
                    label: const Text("View Report"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9C99E3),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
