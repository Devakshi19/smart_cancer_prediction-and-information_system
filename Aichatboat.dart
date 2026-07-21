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
      "To use the app, tap any of the prompt pills on the home screen or type your health query in the message bar below.",
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

    if (bestMatch != null && highestScore > 0) {
      return bestMatch.answer;
    }

    return "I couldn't find a direct match for that topic. Please ask about app usage, skin cancer, lung cancer, or breast cancer, or consult a certified medical provider for tailored advice.";
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
              // Main Chat Area
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
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.80,
                        ),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.white : const Color(0xFF232142),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: Radius.circular(isUser ? 16 : 0),
                            bottomRight: Radius.circular(isUser ? 0 : 16),
                          ),
                        ),
                        child: Text(
                          msg["text"] ?? "",
                          style: TextStyle(
                            color: isUser ? Colors.black : Colors.white,
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
                          hintText: _isListening ? "Listening..." : "Ask AI...",
                          hintStyle: const TextStyle(color: Colors.white60),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        onSubmitted: (val) => _sendMessage(val),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        color: _isListening ? Colors.redAccent : Colors.white,
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
