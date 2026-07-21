import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchText = "";

  Map<String, String> cancerInfo = {
    "Breast Cancer":
        "Breast cancer begins in breast tissue. Early detection using mammograms increases the chance of successful treatment.",
    "Skin Cancer":
        "Skin cancer develops because of abnormal skin cell growth. Protect yourself from UV rays.",
    "Lung Cancer":
        "Lung cancer usually affects smokers but can also occur in non-smokers.",
    "Symptoms":
        "Common symptoms include fatigue, unexplained weight loss, persistent cough and unusual lumps.",
    "Treatment":
        "Treatment includes surgery, chemotherapy, radiation therapy and immunotherapy."
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "SEARCH",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 156, 153, 227),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search Cancer Information...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Text(
              "Popular Searches",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ActionChip(
                  label: const Text("Breast Cancer"),
                  onPressed: () {
                    setState(() {
                      searchText = "Breast Cancer";
                    });
                  },
                ),
                ActionChip(
                  label: const Text("Skin Cancer"),
                  onPressed: () {
                    setState(() {
                      searchText = "Skin Cancer";
                    });
                  },
                ),
                ActionChip(
                  label: const Text("Lung Cancer"),
                  onPressed: () {
                    setState(() {
                      searchText = "Lung Cancer";
                    });
                  },
                ),
                ActionChip(
                  label: const Text("Symptoms"),
                  onPressed: () {
                    setState(() {
                      searchText = "Symptoms";
                    });
                  },
                ),
                ActionChip(
                  label: const Text("Treatment"),
                  onPressed: () {
                    setState(() {
                      searchText = "Treatment";
                    });
                  },
                ),
              ],
            ),
            if (searchText.isNotEmpty &&
                cancerInfo.keys.any((key) =>
                    key.toLowerCase().contains(searchText.toLowerCase())))
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cancerInfo.keys.firstWhere(
                          (key) => key
                              .toLowerCase()
                              .contains(searchText.toLowerCase()),
                        ),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        cancerInfo[cancerInfo.keys.firstWhere(
                          (key) => key
                              .toLowerCase()
                              .contains(searchText.toLowerCase()),
                        )]!,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 25),
            const SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.history),
              title: Text("Breast Cancer"),
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text("Skin Cancer"),
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text("Symptoms"),
            ),
            const SizedBox(height: 30),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
