import 'dart:io';
import 'package:flutter/material.dart';
import 'scan_service.dart';

class ScanRecord {
  final String id;
  final String cancerType;
  final String date;
  final String time;
  final String result;
  final double confidence;
  final String hospital;
  final IconData icon;
  final Color color;
  final String? imageUrl;
  final int? timestamp;

  const ScanRecord({
    required this.id,
    required this.cancerType,
    required this.date,
    required this.time,
    required this.result,
    required this.confidence,
    required this.hospital,
    required this.icon,
    required this.color,
    this.imageUrl,
    this.timestamp,
  });

  factory ScanRecord.fromMap(String docId, Map<String, dynamic> map) {
    String type = map['cancerType'] ?? 'Skin Cancer';
    IconData icon = Icons.health_and_safety_rounded;
    Color color = const Color(0xFFF97316);

    if (type.contains('Breast')) {
      icon = Icons.favorite_rounded;
      color = const Color(0xFFEC4899);
    } else if (type.contains('Uterine')) {
      icon = Icons.medical_services_rounded;
      color = const Color(0xFFEAB308);
    } else if (type.contains('Lung')) {
      icon = Icons.air_rounded;
      color = const Color(0xFF3B82F6);
    }

    return ScanRecord(
      id: docId,
      cancerType: type,
      date: map['date'] ?? 'Today',
      time: map['time'] ?? '10:00 AM',
      result: map['result'] ?? 'Normal',
      confidence: (map['confidence'] as num?)?.toDouble() ?? 0.95,
      hospital: map['hospital'] ?? 'AI Diagnostic Center',
      icon: icon,
      color: color,
      imageUrl: map['imageUrl'],
      timestamp: map['timestamp'] as int?,
    );
  }
}

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _selectedFilter = "All";
  List<ScanRecord> _allScans = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserScans();
  }

  Future<void> _loadUserScans() async {
    setState(() => _isLoading = true);
    final userScans = await ScanService.getUserScans();
    if (mounted) {
      setState(() {
        _allScans = userScans;
        _isLoading = false;
      });
    }
  }

  List<ScanRecord> get _filteredScans {
    if (_selectedFilter == "Normal") {
      return _allScans.where((s) => s.result == "Normal").toList();
    } else if (_selectedFilter == "Flagged") {
      return _allScans.where((s) => s.result != "Normal").toList();
    }
    return _allScans;
  }

  void _onViewReport(ScanRecord scan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: scan.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(scan.icon, color: scan.color, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          scan.cancerType,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          scan.hospital,
                          style: const TextStyle(color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Uploaded Image Display in Report Modal
              if (scan.imageUrl != null && scan.imageUrl!.isNotEmpty) ...[
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: scan.imageUrl!.startsWith('http')
                      ? Image.network(
                    scan.imageUrl!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  )
                      : Image.file(
                    File(scan.imageUrl!),
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              ],

              const Divider(height: 32),
              _buildReportDetailRow("Date & Time", "${scan.date} at ${scan.time}"),
              _buildReportDetailRow("Scan ID", scan.id),
              _buildReportDetailRow("AI Result", scan.result),
              _buildReportDetailRow(
                "Confidence Rating",
                "${(scan.confidence * 100).toStringAsFixed(1)}%",
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF817EE0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Close Report",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReportDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _onDeleteScan(ScanRecord scan) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text("Delete Record"),
          content: Text(
            "Are you sure you want to delete the ${scan.cancerType} report from ${scan.date}?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Color(0xFF64748B)),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                await ScanService.deleteScanRecord(scan.id);
                setState(() {
                  _allScans.removeWhere((item) => item.id == scan.id);
                });
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${scan.cancerType} scan deleted."),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text(
                "Delete",
                style: TextStyle(
                  color: Color(0xFFEF4444),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF817EE0);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "SCAN HISTORY",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: const Color(0xFF9C99E3),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: _buildSummaryHeader(themeColor),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildFilterChips(themeColor),
            ),
          ),

          // Scan Records List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final scan = _filteredScans[index];
                  return HistoryCard(
                    scan: scan,
                    onViewReport: () => _onViewReport(scan),
                    onDelete: () => _onDeleteScan(scan),
                  );
                },
                childCount: _filteredScans.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader(Color primaryColor) {
    final totalScans = _allScans.length;
    final normalScans = _allScans.where((s) => s.result == "Normal").length;
    final flaggedScans = totalScans - normalScans;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, primaryColor.withOpacity(0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem("Total Scans", "$totalScans", Colors.white),
          Container(height: 35, width: 1, color: Colors.white24),
          _buildStatItem("Normal", "$normalScans", const Color(0xFF86EFAC)),
          Container(height: 35, width: 1, color: Colors.white24),
          _buildStatItem("Flagged", "$flaggedScans", const Color(0xFFFCA5A5)),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips(Color primaryColor) {
    final categories = ["All", "Normal", "Flagged"];
    return Row(
      children: categories.map((category) {
        final isSelected = _selectedFilter == category;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(category),
            selected: isSelected,
            selectedColor: primaryColor.withOpacity(0.15),
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
              color: isSelected ? primaryColor : const Color(0xFF64748B),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isSelected ? primaryColor : const Color(0xFFE2E8F0),
              ),
            ),
            onSelected: (selected) {
              if (selected) {
                setState(() => _selectedFilter = category);
              }
            },
          ),
        );
      }).toList(),
    );
  }
}

class HistoryCard extends StatelessWidget {
  final ScanRecord scan;
  final VoidCallback onViewReport;
  final VoidCallback onDelete;

  const HistoryCard({
    super.key,
    required this.scan,
    required this.onViewReport,
    required this.onDelete,
  });

  Widget _buildScanThumbnail() {
    if (scan.imageUrl != null && scan.imageUrl!.isNotEmpty) {
      if (scan.imageUrl!.startsWith('http')) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.network(
            scan.imageUrl!,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Icon(scan.icon, color: scan.color, size: 24),
          ),
        );
      } else {
        final file = File(scan.imageUrl!);
        if (file.existsSync()) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.file(
              file,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Icon(scan.icon, color: scan.color, size: 24),
            ),
          );
        }
      }
    }
    return Icon(scan.icon, color: scan.color, size: 24);
  }

  @override
  Widget build(BuildContext context) {
    final isNormal = scan.result == "Normal";
    final statusColor = isNormal ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    final statusBg = isNormal ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: scan.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: _buildScanThumbnail(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scan.cancerType,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        scan.hospital,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                // Status Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        scan.result,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined, size: 14, color: Color(0xFF64748B)),
                          const SizedBox(width: 6),
                          Text(
                            "${scan.date} • ${scan.time}",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF475569),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "AI Confidence: ${(scan.confidence * 100).toInt()}%",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: scan.confidence,
                      backgroundColor: const Color(0xFFE2E8F0),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        scan.confidence > 0.9 ? const Color(0xFF6366F1) : const Color(0xFFF59E0B),
                      ),
                      minHeight: 5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onViewReport,
                    icon: const Icon(Icons.description_outlined, size: 18),
                    label: const Text("View Report"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF817EE0),
                      side: const BorderSide(color: Color(0xFF817EE0)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 11),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444)),
                    tooltip: "Delete Record",
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
