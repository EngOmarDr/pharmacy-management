
import 'package:http/http.dart';

import 'constant.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    // return true;
    try {
       final result = await post(Uri.http(domain(), '/api/auth/jwt/verify/'))
          .timeout(const Duration(seconds: 3));
      print('response status : ${result.statusCode} from verify');
      return true;
    } on Exception catch (e) {
      print('${e.runtimeType} from ec kIsWeb isConnected network info');
      return false;
    }
  }
}
