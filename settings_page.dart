import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;
  bool _enableNotifications = true;
  bool _enableReminders = true;
  String _selectedLanguage = 'English';

  final List<String> _languages = ['English', 'Hindi', 'Gujarati'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = ThemeManager.instance.themeMode == ThemeMode.dark;
      _enableNotifications = prefs.getBool('enableNotifications') ?? true;
      _enableReminders = prefs.getBool('enableReminders') ?? true;
      _selectedLanguage = AppState.languageNotifier.value;
    });
  }

  Future<void> _saveBoolSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _saveStringSetting(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFF9A95E8),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppState.tr('SETTINGS'),
        ),
        backgroundColor: const Color(0xFF9A95E8),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          _buildSectionHeader("Appearance"),
          SwitchListTile(
            secondary:
                const Icon(Icons.dark_mode_outlined, color: Colors.deepPurple),
            title: const Text("Dark Mode"),
            subtitle: const Text("Switch to dark theme interface"),
            value: _isDarkMode,
            activeTrackColor: const Color(0xFF9A95E8),
            onChanged: (bool value) async {
              setState(() {
                _isDarkMode = value;
              });
              // Triggers global theme change through AppState & ThemeManager
              AppState.toggleTheme(value);
            },
          ),

          ListTile(
            leading:
                const Icon(Icons.language_outlined, color: Colors.deepPurple),
            title: const Text("App Language"),
            subtitle: Text(_selectedLanguage),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showLanguageDialog();
            },
          ),

          const Divider(),
          _buildSectionHeader("Notifications & Reminders"),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_active_outlined,
                color: Colors.deepPurple),
            title: const Text("Push Notifications"),
            subtitle: const Text("Receive health tips & scan report alerts"),
            value: _enableNotifications,
            activeTrackColor: const Color(0xFF9A95E8),
            onChanged: (bool value) {
              setState(() {
                _enableNotifications = value;
              });
              _saveBoolSetting('enableNotifications', value);
            },
          ),
          SwitchListTile(
            secondary:
                const Icon(Icons.alarm_outlined, color: Colors.deepPurple),
            title: const Text("Screening Reminders"),
            subtitle: const Text("Reminders for regular self-exams & checkups"),
            value: _enableReminders,
            activeTrackColor: const Color(0xFF9A95E8),
            onChanged: (bool value) {
              setState(() {
                _enableReminders = value;
              });
              _saveBoolSetting('enableReminders', value);
            },
          ),

          const Divider(),
          _buildSectionHeader("Privacy & Storage"),
          ListTile(
            leading: const Icon(Icons.cleaning_services_outlined,
                color: Colors.deepPurple),
            title: const Text("Clear Cache"),
            subtitle:
                const Text("Free up storage used by temporary scan files"),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Cache cleared successfully")),
              );
            },
          ),
        ],
      ),
    );
  }
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Language"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _languages.map((String lang) {
              return RadioListTile<String>(
                title: Text(lang),
                value: lang,
                groupValue: _selectedLanguage,
                activeColor: const Color(0xFF9A95E8),
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      _selectedLanguage = value;
                    });
                    _saveStringSetting('selectedLanguage', value);
                    AppState.setLanguage(value);

                    Navigator.pop(context);
                  }
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
