import 'package:flutter/material.dart';
import 'package:project/screens/settings_page.dart';
import 'package:project/screens/user_session.dart';
import 'screens.dart';
import 'widgets.dart';

// --- APP STATE FOR THEME & TRANSLATIONS ---
class AppState {
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);
  static final ValueNotifier<String> languageNotifier =
      ValueNotifier('English');

  static Future<void> init() async {
    // Load preferences logic handled inside SettingsPage/UserSession
  }

  static void toggleTheme(bool isDark) {
    themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  static void setLanguage(String lang) {
    languageNotifier.value = lang;
  }

  // Dictionary mapping
  static final Map<String, Map<String, String>> _localizedValues = {
    'English': {
      'app_title': 'CANCER DETECTION APP',
      'login': 'LOGIN',
      'signup': 'SIGN UP',
      'profile': 'Profile',
      'about': 'About',
      'help': 'Help & Feedback',
      'terms': 'Terms & Conditions',
      'settings': 'Settings',
      'logout': 'Log Out',
      'home': 'HOME',
      'reports': 'REPORTS',
      'scan_now': 'SCAN NOW',
      'chatbot': 'CHATBOT',
      'doctors': 'DOCTORS',
    },
    'Hindi': {
      'app_title': 'कैंसर पता लगाने वाला ऐप',
      'login': 'लॉग इन',
      'signup': 'साइन अप',
      'profile': 'प्रोफ़ाइल',
      'about': 'हमारे बारे में',
      'help': 'सहायता और प्रतिक्रिया',
      'terms': 'नियम और शर्तें',
      'settings': 'सेटिंग्स',
      'logout': 'लॉग आउट',
      'home': 'होम',
      'reports': 'रिपोर्ट्स',
      'scan_now': 'स्कैन करें',
      'chatbot': 'चैटबॉट',
      'doctors': 'डॉक्टर्स',
    },
    'Gujarati': {
      'app_title': 'કેન્સર ડિટેક્શન એપ',
      'login': 'લોગ ઇન',
      'signup': 'સાઇન અપ',
      'profile': 'પ્રોફાઇલ',
      'about': 'અમારા વિશે',
      'help': 'મદદ અને પ્રતિસાદ',
      'terms': 'નિયમો અને શરતો',
      'settings': 'સેટિંગ્સ',
      'logout': 'લોગ આઉટ',
      'home': 'હોમ',
      'reports': 'રિપોર્ટ્સ',
      'scan_now': 'સ્કેન કરો',
      'chatbot': 'ચેટબોટ',
      'doctors': 'ડૉક્ટર્સ',
    },
  };

  static String tr(String key) {
    String currentLang = languageNotifier.value;
    return _localizedValues[currentLang]?[key] ??
        _localizedValues['English']![key] ??
        key;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppState.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppState.themeNotifier,
      builder: (context, currentTheme, _) {
        return ValueListenableBuilder<String>(
          valueListenable: AppState.languageNotifier,
          builder: (context, __, ___) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              themeMode: currentTheme,
              theme: ThemeData(
                brightness: Brightness.light,
                primaryColor: const Color(0xFF9A95E8),
                scaffoldBackgroundColor: Colors.white,
                appBarTheme: const AppBarTheme(
                  backgroundColor: Color(0xFF9A95E8),
                  foregroundColor: Colors.white,
                ),
              ),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                scaffoldBackgroundColor: const Color(0xFF121212),
                appBarTheme: const AppBarTheme(
                  backgroundColor: Color(0xFF232142),
                  foregroundColor: Colors.white,
                ),
                cardColor: const Color(0xFF1E1E1E),
                drawerTheme: const DrawerThemeData(
                  backgroundColor: Color(0xFF1E1E1E),
                ),
              ),
              home: const SplashScreen(),
            );
          },
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String currentUserName = "Cancer Detection App";
  String currentUserEmail = "AI-Based Cancer Detection";

  @override
  void initState() {
    super.initState();
    _loadDrawerUserData();
  }

  // Fetch logged-in user data for the Navigation Drawer
  Future<void> _loadDrawerUserData() async {
    final userData = await UserSession.getUser();
    setState(() {
      currentUserName = userData['name'] ?? "Cancer Detection App";
      currentUserEmail = userData['email'] ?? "AI-Based Cancer Detection";
    });
  }

  // Modal Sheet for Central Scan Button
  void _showQuickScanModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Cancer AI Detection Type",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              ListTile(
                leading:
                    const Icon(Icons.clean_hands, color: Color(0xFF9A95E8)),
                title: const Text("Skin Cancer Detection"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Open Skin Cancer Detector Screen
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.personal_injury, color: Color(0xFF9A95E8)),
                title: const Text("Lung Cancer (Chest X-Ray)"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Open Lung Cancer Detector Screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.female, color: Color(0xFF9A95E8)),
                title: const Text("Breast Cancer Detection"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Open Breast Cancer Detector Screen
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppState.tr('app_title'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: Text(
              AppState.tr('login'),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignupPage()),
              );
            },
            child: Text(
              AppState.tr('signup'),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: ListView(
        children: [
          SkinCancerCard(),
          LungCancerCard(),
          UterineCancerCard(),
          BreastCancerCard(),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF9A95E8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage("assets/drawer_logo.jpeg"),
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    currentUserName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    currentUserEmail,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(AppState.tr('profile')),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
                _loadDrawerUserData();
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: Text(AppState.tr('settings')),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(AppState.tr('about')),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: Text(AppState.tr('help')),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.description_outlined),
              title: Text(AppState.tr('terms')),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TermsConditionsPage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: Text(
                AppState.tr('logout'),
                style: const TextStyle(color: Colors.redAccent),
              ),
              onTap: () async {
                bool? logout = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(AppState.tr('logout')),
                    content: const Text("Are you sure you want to log out?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(AppState.tr('logout')),
                      ),
                    ],
                  ),
                );

                if (logout == true) {
                  await UserSession.logout();
                  if (!mounted) return;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).cardColor,
        elevation: 12,
        selectedItemColor: const Color(0xFF9A95E8),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        onTap: (index) {
          if (index == 0) {
            setState(() => _selectedIndex = 0);
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HistoryPage()),
            );
          } else if (index == 2) {
            _showQuickScanModal(context);
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AIChatbotPage()),
            );
          } else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ContactPage()),
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined, size: 26),
            activeIcon: const Icon(Icons.home, size: 28),
            label: AppState.tr('HOME'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.history_sharp, size: 26),
            activeIcon: const Icon(Icons.assignment, size: 28),
            label: AppState.tr('HISTORY'),
          ),
          BottomNavigationBarItem(
            icon: const CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xFF9A95E8),
              child: Icon(Icons.add_a_photo, color: Colors.white, size: 20),
            ),
            label: AppState.tr('SCAN NOW'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.support_agent_outlined, size: 26),
            activeIcon: const Icon(Icons.support_agent, size: 28),
            label: AppState.tr('CHATBOAT'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.perm_contact_calendar_outlined, size: 26),
            activeIcon: const Icon(Icons.medical_services, size: 28),
            label: AppState.tr('CONTACT US'),
          ),
        ],
      ),
    );
  }
}
