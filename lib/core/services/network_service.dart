import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class NetworkService {
  final Connectivity _connectivity;

  NetworkService(this._connectivity);

  Future<bool> get isConnected async {
    var connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<List<ConnectivityResult>> get connectivityStatus async {
    // Correctly return a single ConnectivityResult instead of a List<ConnectivityResult>
    return await _connectivity.checkConnectivity();
  }

  Stream<List<ConnectivityResult>> get connectivityStream {
    // Correctly return a Stream<ConnectivityResult> instead of a Stream<List<ConnectivityResult>>
    return _connectivity.onConnectivityChanged;
  }

  Future<http.Response> getRequest(String url) async {
    if (await isConnected) {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<http.Response> postRequest(String url, Map<String, dynamic> body) async {
    if (await isConnected) {
      final response = await http.post(Uri.parse(url), body: body);
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Failed to post data');
      }
    } else {
      throw Exception('No internet connection');
    }
  }
}
