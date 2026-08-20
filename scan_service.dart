import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'historypage.dart';

class ScanService {
  static const String _localScansKey = 'user_scan_history_records';
  
  /// Global notifier to notify UI widgets (like AI Screening Dashboard) when scans change
  static final ValueNotifier<int> scanUpdatesNotifier = ValueNotifier<int>(0);

  /// Save a new scan record to user's Cloud Firestore account & local cache
  static Future<void> saveScanRecord({
    required String cancerCategory,
    required String result,
    required double confidence,
    String? imageUrl,
    required dynamic summary,
    required dynamic diagnosis,
  }) async {
    final now = DateTime.now();
    final String scanId = 'scan_${now.millisecondsSinceEpoch}';
    final String dateStr = '${now.day} ${_monthName(now.month)} ${now.year}';
    final String timeStr =
        '${_twoDigits(now.hour % 12 == 0 ? 12 : now.hour % 12)}:${_twoDigits(now.minute)} ${now.hour >= 12 ? 'PM' : 'AM'}';

    final String cancerTypeStr = '$cancerCategory Cancer';

    final scanData = {
      'id': scanId,
      'cancerType': cancerTypeStr,
      'date': dateStr,
      'time': timeStr,
      'result': result,
      'confidence': confidence,
      'hospital': 'AI Diagnostic Center',
      'imageUrl': imageUrl ?? '',
      'timestamp': now.millisecondsSinceEpoch,
    };

    // 1. Save to Cloud Firestore under User's UID if logged in
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('scans')
            .doc(scanId)
            .set({
          ...scanData,
          'userEmail': user.email ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        }).timeout(const Duration(seconds: 6));
        debugPrint("Scan successfully saved to Firestore for user: ${user.uid}");
      } catch (e) {
        debugPrint("Firestore scan save notice: $e");
      }
    }

    // 2. Save to Local SharedPreferences Cache for persistent access
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> stored = prefs.getStringList(_localScansKey) ?? [];
      stored.insert(0, jsonEncode(scanData));
      await prefs.setStringList(_localScansKey, stored);
      debugPrint("Scan saved to local storage cache.");
    } catch (e) {
      debugPrint("Local scan save error: $e");
    }

    // Notify listeners that a new scan was recorded
    scanUpdatesNotifier.value++;
  }

  /// Compute dynamic real-time stats for the Home AI Screening Dashboard
  static Future<Map<String, String>> getDashboardStats() async {
    final scans = await getUserScans();

    // 1. Total Scans (formatted with leading zero if single digit)
    final int totalCount = scans.length;
    final String totalStr = totalCount < 10 ? '0$totalCount' : '$totalCount';

    // 2. Active Scans (scans recorded today)
    final now = DateTime.now();
    int scansToday = 0;
    for (var scan in scans) {
      if (scan.timestamp != null) {
        final scanDate = DateTime.fromMillisecondsSinceEpoch(scan.timestamp!);
        if (scanDate.year == now.year &&
            scanDate.month == now.month &&
            scanDate.day == now.day) {
          scansToday++;
        }
      } else if (scan.date.toLowerCase().contains('today') ||
          scan.date.startsWith('${now.day} ${_monthName(now.month)} ${now.year}')) {
        scansToday++;
      }
    }
    final String activeStr = scansToday < 10 ? '0$scansToday' : '$scansToday';

    // 3. Last Scan Date
    String lastScanStr = '--';
    if (scans.isNotEmpty) {
      final latest = scans.first;
      if (latest.timestamp != null) {
        final latestDate = DateTime.fromMillisecondsSinceEpoch(latest.timestamp!);
        final today = DateTime(now.year, now.month, now.day);
        final scanDay = DateTime(latestDate.year, latestDate.month, latestDate.day);
        final diffDays = today.difference(scanDay).inDays;

        if (diffDays == 0) {
          lastScanStr = 'Today';
        } else if (diffDays == 1) {
          lastScanStr = 'Yesterday';
        } else if (diffDays < 7) {
          lastScanStr = '$diffDays days ago';
        } else {
          lastScanStr = '${latestDate.day} ${_monthName(latestDate.month)}';
        }
      } else {
        if (latest.date.toLowerCase().contains('today')) {
          lastScanStr = 'Today';
        } else {
          final parts = latest.date.split(' ');
          if (parts.length >= 2) {
            lastScanStr = '${parts[0]} ${parts[1]}';
          } else {
            lastScanStr = latest.date;
          }
        }
      }
    }

    return {
      'total': totalStr,
      'active': activeStr,
      'last': lastScanStr,
    };
  }

  /// Fetch all scan records for current user (combining Firestore + Local + Defaults)
  static Future<List<ScanRecord>> getUserScans() async {
    List<ScanRecord> scans = [];
    final user = FirebaseAuth.instance.currentUser;

    // 1. Fetch from Firestore if logged in
    if (user != null) {
      try {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('scans')
            .get()
            .timeout(const Duration(seconds: 5));

        for (var doc in querySnapshot.docs) {
          scans.add(ScanRecord.fromMap(doc.id, doc.data()));
        }
      } catch (e) {
        debugPrint("Firestore fetch notice: $e");
      }
    }

    // 2. Fetch from Local Cache if Firestore is empty or offline
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> stored = prefs.getStringList(_localScansKey) ?? [];
      for (String item in stored) {
        try {
          Map<String, dynamic> map = jsonDecode(item);
          String docId =
              map['id'] ?? 'scan_${DateTime.now().millisecondsSinceEpoch}';
          if (!scans.any((s) => s.id == docId)) {
            scans.add(ScanRecord.fromMap(docId, map));
          }
        } catch (_) {}
      }
    } catch (e) {
      debugPrint("Local fetch error: $e");
    }

    // 3. Fallback mock initial records if no scans recorded yet
    if (scans.isEmpty) {
      scans.addAll(_defaultScans);
    }

    // Sort by newest timestamp first
    scans.sort((a, b) => (b.timestamp ?? 0).compareTo(a.timestamp ?? 0));

    return scans;
  }

  /// Delete a scan record from Firestore and Local Cache
  static Future<void> deleteScanRecord(String scanId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('scans')
            .doc(scanId)
            .delete();
      } catch (e) {
        debugPrint("Firestore delete error: $e");
      }
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> stored = prefs.getStringList(_localScansKey) ?? [];
      stored.removeWhere((item) {
        try {
          Map<String, dynamic> map = jsonDecode(item);
          return map['id'] == scanId;
        } catch (_) {
          return false;
        }
      });
      await prefs.setStringList(_localScansKey, stored);
    } catch (e) {
      debugPrint("Local delete error: $e");
    }

    scanUpdatesNotifier.value++;
  }

  static String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[(month - 1) % 12];
  }

  static String _twoDigits(int n) => n >= 10 ? "$n" : "0$n";

  static final List<ScanRecord> _defaultScans = [
    const ScanRecord(
      id: "demo_1",
      cancerType: "Breast Cancer",
      date: "12 Jul 2026",
      time: "10:30 AM",
      result: "Normal",
      confidence: 0.98,
      hospital: "AI Medical Center",
      icon: Icons.favorite_rounded,
      color: Color(0xFFEC4899),
      timestamp: 1783852200000,
    ),
    const ScanRecord(
      id: "demo_2",
      cancerType: "Skin Cancer",
      date: "10 Jul 2026",
      time: "02:15 PM",
      result: "Suspicious",
      confidence: 0.91,
      hospital: "Cancer Care Hospital",
      icon: Icons.health_and_safety_rounded,
      color: Color(0xFFF97316),
      timestamp: 1783692900000,
    ),
  ];
}
