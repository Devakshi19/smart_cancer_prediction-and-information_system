import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class FAQItem {
  final String title;
  final IconData icon;
  final List<String> keywords;
  final String answer;

  FAQItem({
    required this.title,
    required this.icon,
    required this.keywords,
    required this.answer,
  });
}

class AIChatbotPage extends StatefulWidget {
  const AIChatbotPage({super.key});

  @override
  State<AIChatbotPage> createState() => _AIChatbotPageState();
}

class _AIChatbotPageState extends State<AIChatbotPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];

  bool _isLoading = false;
  late stt.SpeechToText _speech;
  bool _isListening = false;

  final List<FAQItem> _faqDatabase = [
    FAQItem(
      title: "How to use the app?",
      icon: Icons.help_outline,
      keywords: ["use", "app", "help", "guide", "navigate", "how"],
      answer:
      "To use the app, tap any of the prompt pills on the home screen or type your health query in the message bar below. You can scan, chat with AI, and view doctor details.",
    ),
    FAQItem(
      title: "What is Skin Cancer?",
      icon: Icons.clean_hands_outlined,
      keywords: ["skin", "melanoma", "derma", "mole", "spot", "sun"],
      answer:
      "Skin cancer is the abnormal growth of skin cells, frequently caused by sun exposure. Look out for changing moles, asymmetrical spots, or new growths, and consult a dermatologist promptly.",
    ),
    FAQItem(
      title: "What is Lung Cancer?",
      icon: Icons.personal_injury_outlined,
      keywords: ["lung", "cough", "chest", "breath", "breathing", "respiratory"],
      answer:
      "Lung cancer forms in the tissues of the lungs. Key warning signs include persistent coughing, shortness of breath, unexplained weight loss, and chest discomfort.",
    ),
    FAQItem(
      title: "What is Breast Cancer?",
      icon: Icons.female_outlined,
      keywords: ["breast", "mammogram", "lump", "tissue", "women"],
      answer:
      "Breast cancer originates in breast tissue cells. Regular self-examinations and routine mammograms are critical for early detection and high treatment success rates.",
    ),

    FAQItem(
      title: "How does AI Scan work?",
      icon: Icons.camera_alt,
      keywords: ["scan", "ai", "detect", "camera", "upload", "image"],
      answer:
      "Upload an image of the affected area. Our AI model analyzes it and gives you a prediction with confidence score. For best results, use good lighting and a clear image.",
    ),
    FAQItem(
      title: "Is my data safe and private?",
      icon: Icons.security,
      keywords: ["privacy", "safe", "data", "secure", "information", "store"],
      answer:
      "Yes. Your images and chat history are stored locally on your device. We do not share your personal health data with any third party.",
    ),
    FAQItem(
      title: "How to find a doctor?",
      icon: Icons.local_hospital,
      keywords: ["doctor", "find", "specialist", "oncologist", "hospital", "near"],
      answer:
      "Go to any cancer card like Breast, Lung, Skin, Uterine. Tap it and you’ll see a list of specialists with hospital, location, and contact number. You can also search by name.",
    ),
    FAQItem(
      title: "Where can I see my scan history?",
      icon: Icons.history,
      keywords: ["history", "past", "report", "scan", "previous", "record"],
      answer:
      "Tap the History icon in the app. There you can view all past scans, results, confidence scores, and open detailed reports. You can also delete any scan.",
    ),
    FAQItem(
      title: "Can AI replace a real doctor?",
      icon: Icons.warning_amber,
      keywords: ["doctor", "replace", "diagnosis", "real", "medical", "advice"],
      answer:
      "No. This app is for early screening and awareness only. AI results are not a final diagnosis. Always consult a certified oncologist for medical decisions.",
    ),
    FAQItem(
      title: "What cancers can the app detect?",
      icon: Icons.biotech,
      keywords: ["cancer", "type", "detect", "support", "breast", "lung", "skin", "uterine"],
      answer:
      "Currently the app supports AI detection for Breast Cancer, Lung Cancer, Skin Cancer, and Uterine Cancer. More types will be added soon.",
    ),
    FAQItem(
      title: "How accurate is the AI?",
      icon: Icons.bar_chart,
      keywords: ["accuracy", "accurate", "percent", "confidence", "reliable"],
      answer:
      "The AI shows a confidence score with every scan. Accuracy depends on image quality. It’s a screening tool, not 100% diagnostic. Use it with professional consultation.",
    ),
    FAQItem(
      title: "How to download my report?",
      icon: Icons.download,
      keywords: ["download", "report", "pdf", "save", "export"],
      answer:
      "Open any scan from History. Tap 'View Report' and then use the download button on top to save the report to your device.",
    ),
    FAQItem(
      title: "Why is my scan result 'Suspicious'?",
      icon: Icons.report_problem,
      keywords: ["suspicious", "result", "abnormal", "positive", "meaning"],
      answer:
      "'Suspicious' means the AI detected patterns that may need attention. Please book an appointment with a specialist immediately for further tests.",
    ),
    FAQItem(
      title: "How to reset the chat?",
      icon: Icons.refresh,
      keywords: ["reset", "clear", "chat", "delete", "messages"],
      answer:
      "Tap the refresh icon at the top right of the chat screen. This will clear all chat messages.",
    ),
    FAQItem(
      title: "Does the app work offline?",
      icon: Icons.wifi_off,
      keywords: ["offline", "internet", "no network", "without wifi"],
      answer:
      "Chat and viewing history works offline. But AI scanning and fetching latest doctor data requires internet connection.",
    ),
    FAQItem(
      title: "How to use voice search?",
      icon: Icons.mic,
      keywords: ["voice", "speak", "mic", "talk", "speech"],
      answer:
      "Tap the mic icon in the chat bar and speak your question. The app will convert it to text and search for an answer.",
    ),
    FAQItem(
      title: "What are the symptoms of Uterine Cancer?",
      icon: Icons.pregnant_woman,
      keywords: ["uterine", "symptoms", "bleeding", "pain", "period"],
      answer:
      "Common symptoms include abnormal vaginal bleeding, pelvic pain, and pain during intercourse. Early checkups are important. Use the Uterine Cancer card for specialist help.",
    ),
    FAQItem(
      title: "How to contact support?",
      icon: Icons.support_agent,
      keywords: ["support", "contact", "help", "problem", "issue", "feedback"],
      answer:
      "For bugs or feedback, go to Settings > Contact Support. Our team will respond within 24 hours.",
    ),
    FAQItem(
      title: "Can I add more doctors?",
      icon: Icons.person_add,
      keywords: ["add", "doctor", "list", "update", "new"],
      answer:
      "Doctor data is updated by the admin team. If you know a specialist missing from the list, use 'Contact Support' and share their details.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _findBestResponse(String userQuery) {
    final queryWords = userQuery
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .split(' ');

    FAQItem? bestMatch;
    int highestScore = 0;

    for (var faq in _faqDatabase) {
      int score = 0;
      for (var word in queryWords) {
        if (word.length > 2 && faq.keywords.contains(word)) {
          score++;
        }
      }
      if (score > highestScore) {
        highestScore = score;
        bestMatch = faq;
      }
    }

    if (bestMatch!= null && highestScore > 0) {
      return bestMatch.answer;
    }

    return "I couldn't find a direct match for that topic. Try asking about scans, doctors, privacy, history, or the 4 cancer types. Or consult a certified medical provider for tailored advice.";
  }

  void _listenVoice() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            setState(() => _isListening = false);
          }
        },
        onError: (_) => setState(() => _isListening = false),
      );

      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              _messageController.text = result.recognizedWords;
            });
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Speech recognition is not available on this device."),
          ),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userText = text.trim();
    _messageController.clear();

    setState(() {
      _messages.add({"sender": "user", "text": userText});
      _isLoading = true;
    });

    _scrollToBottom();
    await Future.delayed(const Duration(milliseconds: 500));

    final botAnswer = _findBestResponse(userText);

    if (mounted) {
      setState(() {
        _messages.add({"sender": "ai", "text": botAnswer});
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildQuickPromptPill(FAQItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => _sendMessage(item.title),
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white30),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white24,
                child: Icon(item.icon, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "HEALTH ASSISTANT",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: "Reset Chat",
            onPressed: () => setState(() => _messages.clear()),
          )
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF5B86E5), Color(0xFF8E86E5), Color(0xFF9A95E8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: _messages.isEmpty
                    ? SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      const Icon(
                        Icons.local_hospital_sharp,
                        size: 70,
                        color: Color(0xFFFFD700),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "What can I help\nyou with?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 40),
                      ..._faqDatabase.map((faq) => _buildQuickPromptPill(faq)),
                    ],
                  ),
                )
                    : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    final isUser = msg["sender"] == "user";
                    return Align(
                      alignment: isUser? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.80,
                        ),
                        decoration: BoxDecoration(
                          color: isUser? Colors.white : const Color(0xFF232142),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: Radius.circular(isUser? 16 : 0),
                            bottomRight: Radius.circular(isUser? 0 : 16),
                          ),
                        ),
                        child: Text(
                          msg["text"]?? "",
                          style: TextStyle(
                            color: isUser? Colors.black : Colors.white,
                            fontSize: 15,
                            height: 1.4,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      ),
                      SizedBox(width: 10),
                      Text("Assistant is thinking...", style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2)),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: _isListening? "Listening..." : "Ask AI...",
                          hintStyle: const TextStyle(color: Colors.white60),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        onSubmitted: (val) => _sendMessage(val),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _isListening? Icons.mic : Icons.mic_none,
                        color: _isListening? Colors.redAccent : Colors.white,
                      ),
                      onPressed: _listenVoice,
                    ),
                    IconButton(
                      icon: const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 18,
                        child: Icon(Icons.send_rounded, color: Color(0xFF8E86E5), size: 18),
                      ),
                      onPressed: () => _sendMessage(_messageController.text),
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
