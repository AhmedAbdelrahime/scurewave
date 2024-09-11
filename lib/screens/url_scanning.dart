import 'package:flutter/material.dart';
import 'package:phishing_detection_app/screens/homescreen/home_screen.dart';
import 'package:phishing_detection_app/services/virustotal_service.dart';
import 'package:phishing_detection_app/widgets/custourlextfield.dart';

class UrlScanning extends StatefulWidget {
  const UrlScanning({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UrlScanningState createState() => _UrlScanningState();
}

class _UrlScanningState extends State<UrlScanning> {
  final TextEditingController _urlController = TextEditingController();
  bool _isLoading = false;
  String _resultMessage = '';
  VirusTotalResult? virusTotalResult;
  final VirusTotalService _virusTotalService = VirusTotalService();

  void _scanUrl() async {
    setState(() {
      _isLoading = true;
      _resultMessage = '';
      virusTotalResult = null;
    });

    try {
      final url = _urlController.text.trim();

      // Check if the URL is not empty
      if (url.isEmpty) {
        setState(() {
          _resultMessage = 'Please enter a valid URL.';
          _isLoading = false;
        });
        return;
      }

      // Use VirusTotal service to check the URL
      virusTotalResult = await _virusTotalService.scanUrl(url);

      // Update the result message based on the scan
      setState(() {
        _resultMessage = 'URL Scan Results:';
      });
    } catch (e) {
      setState(() {
        _resultMessage = 'Error checking URL: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'URL Scanning',
          style: TextStyle(color: Colors.white70),
        ),
        centerTitle: true,
        backgroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white70),
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
            children: [
              CustomTextField(
                controller: _urlController,
                keyboardType: TextInputType.url,
                labelText: 'Enter URL',
                hintText: 'https://example.com',
                icon: Icons.link,
                fillColor: Colors.black54,
                borderColor: Colors.white70,
                focusedBorderColor: Colors.blueAccent,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 6.0, // Thicker progress indicator
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blueAccent), // Blue accent color
                      ),
                    )
                  : ElevatedButton(
                      onPressed: _scanUrl,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:
                            Colors.blueAccent, // Text color of the button
                        shadowColor: Colors.blueAccent
                            .withOpacity(0.5), // Button shadow color
                        elevation: 8.0, // Shadow elevation of the button
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12.0), // Rounded corners
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 16.0), // Button padding
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Scan URL'),
                    ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              if (virusTotalResult != null) ...[
                Text(
                  _resultMessage,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Checked by ${virusTotalResult!.phishingEngines.length + virusTotalResult!.cleanEngines.length + virusTotalResult!.unratedEngines.length + virusTotalResult!.maliciousEngines.length} companies',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 16.0),
                ...virusTotalResult!.phishingEngines.map((engine) {
                  return ListTile(
                    leading:
                        const Icon(Icons.warning, color: Colors.orangeAccent),
                    title: Text(
                      engine,
                      style: const TextStyle(color: Colors.orangeAccent),
                    ),
                  );
                }),
                ...virusTotalResult!.maliciousEngines.map((engine) {
                  return ListTile(
                    leading: const Icon(Icons.error, color: Colors.redAccent),
                    title: Text(
                      engine,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  );
                }),
                ...virusTotalResult!.cleanEngines.map((engine) {
                  return ListTile(
                    leading: const Icon(Icons.check_circle,
                        color: Colors.greenAccent),
                    title: Text(
                      engine,
                      style: const TextStyle(color: Colors.greenAccent),
                    ),
                  );
                }),
                ...virusTotalResult!.unratedEngines.map((engine) {
                  return ListTile(
                    leading: const Icon(Icons.help, color: Colors.grey),
                    title: Text(
                      engine,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  );
                }),
              ] else
                Text(
                  _resultMessage,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
