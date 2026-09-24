import 'package:dio/dio.dart';

class ApiClient {
  // Live backend on Render (use 192.168.137.1 or 192.168.1.4 for physical device testing)
  // static const String baseUrl = 'https://zovio-b.vercel.app/api';
  
  // Local backend for physical device testing over Wi-Fi
  static const String baseUrl = 'http://192.168.1.4:5000/api';
  
  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<List<dynamic>> getWorkers({double? lat, double? lng}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (lat != null && lng != null) {
        queryParams['lat'] = lat;
        queryParams['lng'] = lng;
      }
      final response = await _dio.get('/workers', queryParameters: queryParams);
      return response.data;
    } catch (e) {
      print('Error fetching workers: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('/users/profile/$userId', data: data);
      return response.data;
    } catch (e) {
      if (e is DioException) {
        print('Error updating profile: ${e.response?.data}');
      } else {
        print('Error updating profile: $e');
      }
      rethrow;
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
  Future<Map<String, dynamic>> verifyAuth(String mobile) async {
    try {
      final response = await _dio.post('/auth/verify', data: {'mobile': mobile});
      return response.data;
    } catch (e) {
      print('Error verifying auth: $e');
      rethrow;
    }
  }

  // --- Worker CRUD ---
  Future<Map<String, dynamic>> createWorker(Map<String, dynamic> workerData) async {
    final response = await _dio.post('/workers', data: workerData);
    return response.data;
  }
  Future<Map<String, dynamic>> updateWorker(String id, Map<String, dynamic> workerData) async {
    final response = await _dio.put('/workers/$id', data: workerData);
    return response.data;
  }
  Future<void> deleteWorker(String id) async {
    await _dio.delete('/workers/$id');
  }

  // --- Location CRUD ---
  Future<List<dynamic>> getLocations() async {
    final response = await _dio.get('/locations');
    return response.data;
  }
  Future<Map<String, dynamic>> createLocation(Map<String, dynamic> locationData) async {
    final response = await _dio.post('/locations', data: locationData);
    return response.data;
  }
  Future<Map<String, dynamic>> updateLocation(String id, Map<String, dynamic> locationData) async {
    final response = await _dio.put('/locations/$id', data: locationData);
    return response.data;
  }
  Future<void> deleteLocation(String id) async {
    await _dio.delete('/locations/$id');
  }

  // --- Service CRUD ---
  Future<List<dynamic>> getServices() async {
    final response = await _dio.get('/services');
    return response.data;
  }
  Future<Map<String, dynamic>> createService(Map<String, dynamic> serviceData) async {
    final response = await _dio.post('/services', data: serviceData);
    return response.data;
  }
  Future<Map<String, dynamic>> updateService(String id, Map<String, dynamic> serviceData) async {
    final response = await _dio.put('/services/$id', data: serviceData);
    return response.data;
  }
  Future<void> deleteService(String id) async {
    await _dio.delete('/services/$id');
  }
}

final apiClient = ApiClient();
