import 'package:flutter/foundation.dart';
import 'package:flutter_task/rest_api_services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class DisplayImageProvider with ChangeNotifier {

  Status? _status = Status.idle;
  Status? get status => _status;

  String? _imagePath;
  String? get imagePath => _imagePath;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> uploadImageFromInternet() async {
    _status = Status.loading;
    notifyListeners();
    try {
      http.Response response = await RestApiServices.getImage();
      if(response.statusCode == 200) {
        Map<String, dynamic> json = convert.jsonDecode(response.body);
        String imageSrc = json['results'][0]['picture']['medium'];
        _imagePath = imageSrc;
        _status = Status.success;
      } else {
        _status = Status.failed;
      }
      notifyListeners();
    } catch(error) {
      _status = Status.failed;
    }
    notifyListeners();
  }

}

enum Status {idle, success, failed, loading}

