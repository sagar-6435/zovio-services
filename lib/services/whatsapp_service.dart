import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WhatsappService {
  final Dio _dio = Dio();

  String get _gatewayUrl => dotenv.env['WHATSAPP_GATEWAY_URL'] ?? '';
  String get _apiToken => dotenv.env['WHATSAPP_API_TOKEN'] ?? '';
  String get _session => dotenv.env['WHATSAPP_SESSION'] ?? 'default';

  bool get isConfigured =>
      _gatewayUrl.isNotEmpty && _apiToken.isNotEmpty;

  /// A. Phone Number Normalization
  String _normalizePhoneNumber(String phoneNumber) {
    // Strip all non-digit characters
    String normalized = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // Ensure the number does not have leading zeros
    while (normalized.startsWith('0')) {
      normalized = normalized.substring(1);
    }

    // If it's a standard 10-digit Indian mobile number, prepend 91
    if (normalized.length == 10) {
      normalized = '91$normalized';
    }

    return normalized;
  }

  /// B. Base Request Configuration
  Future<void> _gatewayRequest(Map<String, dynamic> payload) async {
    if (!isConfigured) {
      print('Warning: WhatsApp Gateway is not configured properly in .env');
      return;
    }

    try {
      final url = '$_gatewayUrl/send-message';
      final response = await _dio.post(
        url,
        queryParameters: {
          'token': _apiToken,
          'session': _session,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
        data: payload,
      );

      if (response.statusCode == 200) {
        print('WhatsApp message sent successfully.');
      } else {
        print('Failed to send WhatsApp message. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Redact token in case it leaks in logs
      final errorString = e.toString().replaceAll(_apiToken, '[REDACTED_TOKEN]');
      print('WhatsApp API Error: $errorString');
    }
  }

  /// C. Feature Methods

  Future<void> sendText(String to, String message) async {
    final normalizedTo = _normalizePhoneNumber(to);
    await _gatewayRequest({
      'to': normalizedTo,
      'message': message,
    });
  }

  Future<void> sendMedia(String to, String message, String attachment) async {
    final normalizedTo = _normalizePhoneNumber(to);
    await _gatewayRequest({
      'to': normalizedTo,
      'message': message,
      'attachment': attachment,
    });
  }

  Future<void> sendPoll(String to, String name, List<String> options, int selectableAnswersCount) async {
    final normalizedTo = _normalizePhoneNumber(to);
    await _gatewayRequest({
      'to': normalizedTo,
      'poll': {
        'name': name,
        'options': options,
        'selectableAnswersCount': selectableAnswersCount,
      }
    });
  }

  Future<void> sendLocation(String to, double latitude, double longitude, {String? name, String? address}) async {
    final normalizedTo = _normalizePhoneNumber(to);
    await _gatewayRequest({
      'to': normalizedTo,
      'location': {
        'latitude': latitude,
        'longitude': longitude,
        if (name != null) 'name': name,
        if (address != null) 'address': address,
      }
    });
  }

  Future<void> sendContact(String to, String fullName, {String? organization, String? phoneNumber}) async {
    final normalizedTo = _normalizePhoneNumber(to);
    await _gatewayRequest({
      'to': normalizedTo,
      'contact': {
        'fullName': fullName,
        if (organization != null) 'organization': organization,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
      }
    });
  }

  Future<void> sendReaction(String to, String text, String remoteJid, String id) async {
    final normalizedTo = _normalizePhoneNumber(to);
    await _gatewayRequest({
      'to': normalizedTo,
      'reaction': {
        'text': text,
        'key': {
          'remoteJid': remoteJid,
          'id': id,
        }
      }
    });
  }

  Future<void> sendPresence(String to, String status, {int? duration}) async {
    final normalizedTo = _normalizePhoneNumber(to);
    await _gatewayRequest({
      'to': normalizedTo,
      'presence': {
        'status': status,
        if (duration != null) 'duration': duration,
      }
    });
  }
}
