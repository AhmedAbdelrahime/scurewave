import 'dart:convert';
import 'package:http/http.dart' as http;

class VirusTotalService {
  final String apiKey =
      '1fe85af691356ce314bb25b956695c87918cd22f09fadfcf9c9a3d8a45b91f36';

  Future<VirusTotalResult> scanUrl(String url) async {
    const scanUrl = 'https://www.virustotal.com/vtapi/v2/url/scan';
    const reportUrl = 'https://www.virustotal.com/vtapi/v2/url/report';

    final scanResponse = await http.post(
      Uri.parse(scanUrl),
      body: {'apikey': apiKey, 'url': url},
    );

    if (scanResponse.statusCode == 200) {
      final scanJson = jsonDecode(scanResponse.body);
      final resource = scanJson['scan_id'] ?? scanJson['resource'];

      if (resource == null) {
        throw Exception('Failed to retrieve scan ID.');
      }

      await Future.delayed(const Duration(seconds: 10));

      final reportResponse = await http.get(
        Uri.parse('$reportUrl?apikey=$apiKey&resource=$resource'),
      );

      if (reportResponse.statusCode == 200) {
        final reportJson = jsonDecode(reportResponse.body);

        final scans = reportJson['scans'] as Map<String, dynamic>?;

        if (scans == null) {
          throw Exception('Failed to retrieve scans data.');
        }

        final phishingEngines = <String>[];
        final cleanEngines = <String>[];
        final unratedEngines = <String>[];
        final maliciousEngines = <String>[];

        scans.forEach((engine, details) {
          if (details['detected'] == true) {
            if (details['result'] == 'malicious') {
              maliciousEngines.add(engine);
            } else {
              phishingEngines.add(engine);
            }
          } else if (details['result'] == 'clean site') {
            cleanEngines.add(engine);
          } else {
            unratedEngines.add(engine);
          }
        });

        return VirusTotalResult(
          phishingEngines: phishingEngines,
          cleanEngines: cleanEngines,
          unratedEngines: unratedEngines,
          maliciousEngines: maliciousEngines,
        );
      } else {
        throw Exception('Failed to get URL report from VirusTotal');
      }
    } else {
      throw Exception('Failed to scan URL with VirusTotal');
    }
  }
}

class VirusTotalResult {
  final List<String> phishingEngines;
  final List<String> cleanEngines;
  final List<String> unratedEngines;
  final List<String> maliciousEngines;

  VirusTotalResult({
    required this.phishingEngines,
    required this.cleanEngines,
    required this.unratedEngines,
    required this.maliciousEngines,
  });
}
