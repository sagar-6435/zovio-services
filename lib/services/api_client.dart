import 'package:dio/dio.dart';

class ApiClient {
  // Use 10.0.2.2 for Android emulators, localhost for Web/iOS
  static const String baseUrl = 'http://localhost:5000/api';
  
  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<List<dynamic>> getWorkers() async {
    try {
      final response = await _dio.get('/workers');
      return response.data;
    } catch (e) {
      print('Error fetching workers: $e');
      return [];
    }
  }

  Future<bool> createBooking(Map<String, dynamic> bookingData) async {
    try {
      final response = await _dio.post('/bookings', data: bookingData);
      return response.statusCode == 201;
    } catch (e) {
      print('Error creating booking: $e');
      return false;
    }
  }
}

final apiClient = ApiClient();
