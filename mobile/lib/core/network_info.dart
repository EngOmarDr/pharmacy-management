

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    return true;
    // if (kIsWeb) {
    //   try {
    //     final result = await get(Uri.https('www.google.com'));
    //     if (result.statusCode == 200) {
    //       return true;
    //     } else {
    //       return false;
    //     }
    //   } on SocketException catch (e) {
    //     print('$e from kIsWeb isConnected network info');
    //     return false;
    //   }on Exception catch(e){
    //     print('$e from kIsWeb isConnected network info');
    //     return false;
    //   }
    // }
    // try {
    //   final result = await InternetAddress.lookup('www.google.com');
    //   if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    //     return true;
    //   } else {
    //     return false;
    //   }
    // } on Exception catch (e) {
    //   print('$e ${e.runtimeType} from isConnected network info');
    //   return false;
    // }
  }
}
