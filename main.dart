import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens.dart';
import 'widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ThemeManager extends ChangeNotifier {
  static ThemeManager? _instance;
  ThemeManager._();

  static ThemeManager get instance {
    _instance ??= ThemeManager._();
    return _instance!;
  }

  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    bool isDark = prefs.getBool('isDarkMode') ?? false;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
    notifyListeners();
  }
}

class AppState {
  static final ValueNotifier<String> languageNotifier =
  ValueNotifier('English');

  static Future<void> init() async {
    await ThemeManager.instance.loadTheme();
    final prefs = await SharedPreferences.getInstance();
    String lang = prefs.getString('selectedLanguage') ?? 'English';
    languageNotifier.value = lang;
  }

  static void toggleTheme(bool isDark) {
    ThemeManager.instance.toggleTheme(isDark);
  }

  static void setLanguage(String lang) {
    languageNotifier.value = lang;
  }

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
      'about_developer': 'About Developer',
      'logout': 'Log Out',
      'home': 'HOME',
      'history': 'HISTORY',
      'scan_now': 'SCAN NOW',
      'chatbot': 'CHATBOT',
      'contact_us': 'CONTACT US',
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
      'about_developer': 'डेवलपर के बारे में',
      'logout': 'लॉग आउट',
      'home': 'होम',
      'history': 'इतिहास',
      'scan_now': 'स्कैन करें',
      'chatbot': 'चैटबॉट',
      'contact_us': 'संपर्क करें',
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
      'about_developer': 'ડેવલપર વિશે',
      'logout': 'લોગ આઉટ',
      'home': 'હોમ',
      'history': 'ઇતિહાસ',
      'scan_now': 'સ્કેન કરો',
      'chatbot': 'ચેટબોટ',
      'contact_us': 'સંપર્ક કરો',
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

  try {
    if (Firebase.apps.isEmpty) {
      if (kIsWeb) {
        await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyBUn8czg17vM8Jp4elyJdus10vs5TX9Ky0",
            authDomain: "cancer-detection-app-4a51a.firebaseapp.com",
            projectId: "cancer-detection-app-4a51a",
            storageBucket: "cancer-detection-app-4a51a.firebasestorage.app",
            messagingSenderId: "573751912810",
            appId: "1:573751912810:web:2842a33e953e529e079d13",
            measurementId: "G-7702EMXK8C",
          ),
        );
      } else {
        await Firebase.initializeApp();
      }
    }
  } catch (e) {
    debugPrint("Firebase initialization error: $e");
  }

  await AppState.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeManager.instance,
      builder: (context, _) {
        return ValueListenableBuilder<String>(
          valueListenable: AppState.languageNotifier,
          builder: (context, __, ___) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              themeMode: ThemeManager.instance.themeMode,
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

  String _totalScansStr = '00';
  String _activeScansStr = '00';
  String _lastScanDateStr = '--';

  @override
  void initState() {
    super.initState();
    _loadDrawerUserData();
    _loadDashboardStats();
    ScanService.scanUpdatesNotifier.addListener(_loadDashboardStats);
  }

  @override
  void dispose() {
    ScanService.scanUpdatesNotifier.removeListener(_loadDashboardStats);
    super.dispose();
  }

  Future<void> _loadDashboardStats() async {
    try {
      final stats = await ScanService.getDashboardStats();
      if (mounted) {
        setState(() {
          _totalScansStr = stats['total'] ?? '00';
          _activeScansStr = stats['active'] ?? '00';
          _lastScanDateStr = stats['last'] ?? '--';
        });
      }
    } catch (e) {
      debugPrint("Error loading dashboard stats: $e");
    }
  }

  Future<void> _loadDrawerUserData() async {
    final userData = await UserSession.getUser();
    final firebaseUser = FirebaseAuth.instance.currentUser;
    setState(() {
      currentUserName =
          firebaseUser?.displayName ?? userData['name'] ?? "Cancer Detection App";
      currentUserEmail =
          firebaseUser?.email ?? userData['email'] ?? "AI-Based Cancer Detection";
    });
  }

  Widget _buildQuickStatItem(
      String label,
      String value,
      IconData icon, {
        VoidCallback? onTap,
      }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Column(
              children: [
                Icon(icon, color: const Color(0xFF9A95E8), size: 22),
                const SizedBox(height: 6),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStatDivider() {
    return Container(
      height: 35,
      width: 1,
      color: Theme.of(context).dividerColor.withOpacity(0.2),
    );
  }

  void _showQuickScanModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
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
                      Navigator.pop(modalContext);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ScanPage(initialCategory: 'Skin'),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.personal_injury,
                        color: Color(0xFF9A95E8)),
                    title: const Text("Lung Cancer (Chest X-Ray)"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.pop(modalContext);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ScanPage(initialCategory: 'Lung'),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.female, color: Color(0xFF9A95E8)),
                    title: const Text("Breast Cancer Detection"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.pop(modalContext);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ScanPage(initialCategory: 'Breast'),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.health_and_safety,
                        color: Color(0xFF9A95E8)),
                    title: const Text("Uterine Cancer Detection"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.pop(modalContext);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ScanPage(initialCategory: 'Uterine'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
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
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello, ${currentUserName.split(' ')[0]} 👋",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Your health is our top priority",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: Theme.of(context).brightness == Brightness.dark
                      ? [const Color(0xFF1E1E2F), const Color(0xFF2E2E4A)]
                      : [const Color(0xFFF3F2FF), Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: const Color(0xFF9A95E8).withOpacity(0.15),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          "AI Screening Dashboard",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF9A95E8),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF9A95E8).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle,
                                size: 14, color: Color(0xFF9A95E8)),
                            SizedBox(width: 4),
                            Text(
                              "Live Sync",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF9A95E8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildQuickStatItem(
                        "Total Scans",
                        _totalScansStr,
                        Icons.analytics_outlined,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HistoryPage()),
                          );
                        },
                      ),
                      _buildQuickStatDivider(),
                      _buildQuickStatItem(
                        "Active Scans",
                        _activeScansStr,
                        Icons.play_circle_outline,
                        onTap: () {
                          _showQuickScanModal(context);
                        },
                      ),
                      _buildQuickStatDivider(),
                      _buildQuickStatItem(
                        "Last Scan",
                        _lastScanDateStr,
                        Icons.calendar_today_outlined,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HistoryPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 15, bottom: 5),
            child: Text(
              "Select Detection Tool",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SkinCancerCard(),
          const LungCancerCard(),
          const UterineCancerCard(),
          const BreastCancerCard(),
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
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
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
            ListTile(
              leading: const Icon(Icons.developer_mode_sharp),
              title: Text(AppState.tr('about_developer')),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AboutDevelopersPage()),
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
                  await FirebaseAuth.instance.signOut();
                  try {
                    await GoogleSignIn().signOut();
                  } catch (_) {}
                  if (!context.mounted) return;
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
            label: AppState.tr('home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.history_sharp, size: 26),
            activeIcon: const Icon(Icons.assignment, size: 28),
            label: AppState.tr('history'),
          ),
          BottomNavigationBarItem(
            icon: const CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xFF9A95E8),
              child: Icon(Icons.add_a_photo, color: Colors.white, size: 20),
            ),
            label: AppState.tr('scan_now'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.support_agent_outlined, size: 26),
            activeIcon: const Icon(Icons.support_agent, size: 28),
            label: AppState.tr('chatbot'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.perm_contact_calendar_outlined, size: 26),
            activeIcon: const Icon(Icons.medical_services, size: 28),
            label: AppState.tr('contact_us'),
          ),
        ],
      ),
    );
  }
}
