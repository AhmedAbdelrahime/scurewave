import 'package:flutter/material.dart';
import 'package:phishing_detection_app/screens/homescreen/home_screen.dart';
import 'package:telephony/telephony.dart';

class SmsDetectionScreen extends StatefulWidget {
  const SmsDetectionScreen({super.key, this.status});
  final String? status;

  @override
  // ignore: library_private_types_in_public_api
  _SmsDetectionScreenState createState() => _SmsDetectionScreenState();
}

class _SmsDetectionScreenState extends State<SmsDetectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final Telephony telephony = Telephony.instance;
  List<SmsMessage> _phishingMessages = [];
  String _scanStatus = "Scanning SMS...";

  static const List<String> _phishingKeywords = [
    "تحديث معلوماتك",
    "حسابك موقوف",
    "تم حظر حسابك",
    "بيانات البطاقة",
    "مشكلة في حسابك",
    "التحقق من الهوية",
    "اتصل بالدعم الفني",
    "انقر هنا للتفعيل",
    "تم اختراق حسابك",
    "تحذير أمني",
    "أرسل معلوماتك الشخصية",
    "عرض مغري",
    'التحديث'
        'مرحبا معكم مدير'
  ];

  @override
  void initState() {
    super.initState();
    _requestPermissionsAndScanSms();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
  }

  void _requestPermissionsAndScanSms() async {
    bool? permissionsGranted = await telephony.requestSmsPermissions;
    if (permissionsGranted == true) {
      _scanAllSms();
    } else {
      setState(() {
        _scanStatus = "SMS Permissions denied.";
      });
    }
  }

  void _scanAllSms() async {
    List<SmsMessage> messages = await telephony.getInboxSms(
      columns: [SmsColumn.BODY, SmsColumn.DATE],
    );

    List<SmsMessage> detectedPhishingMessages =
        messages.where((message) => _isPhishingMessage(message.body)).toList();

    setState(() {
      _phishingMessages = detectedPhishingMessages;
      _scanStatus =
          "Scan Complete. \n ${_phishingMessages.length} phishing messages detected.";
    });
  }

  bool _isPhishingMessage(String? message) {
    if (message == null || message.isEmpty) return false;

    return _phishingKeywords.any(
        (keyword) => message.toLowerCase().contains(keyword.toLowerCase()));
  }

  void _showMessageOptions(SmsMessage message) {
    showModalBottomSheet(
      backgroundColor: const Color.fromARGB(221, 43, 43, 43),
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.info, color: Colors.blue),
              title: const Text(
                "View Details",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _showMessageDetails(message);
              },
            ),
            ListTile(
              leading: const Icon(Icons.report, color: Colors.red),
              title: const Text(
                "Report",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _reportMessage(message);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.grey),
              title: const Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _deleteMessage(message);
              },
            ),
          ],
        );
      },
    );
  }

  void _showMessageDetails(SmsMessage message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Message Details"),
          content: Text(message.body ?? "No content available"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _reportMessage(SmsMessage message) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message reported successfully')),
    );
  }

  void _deleteMessage(SmsMessage message) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message deleted successfully')),
    );
    setState(() {
      _phishingMessages.remove(message);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'SMS Filtering',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  textAlign: TextAlign.center,
                  _scanStatus,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              _phishingMessages.isNotEmpty
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _phishingMessages.length,
                        itemBuilder: (context, index) {
                          SmsMessage message = _phishingMessages[index];
                          return GestureDetector(
                            onTap: () => _showMessageOptions(message),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 8.0,
                                      offset: const Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.warning,
                                        color: Colors.redAccent),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        message.body ?? "No content available",
                                        style: const TextStyle(
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Text(
                        "No phishing messages detected.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
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
