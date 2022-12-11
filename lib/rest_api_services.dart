import 'package:http/http.dart' as http;

class RestApiServices {
  static const String _baseUrl = 'https://randomuser.me/api/';

  static Future<http.Response> getImage() async{
    http.Response response = await http.get(Uri.parse(_baseUrl));
    return response;
  }
}