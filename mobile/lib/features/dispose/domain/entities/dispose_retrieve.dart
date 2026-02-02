import 'package:pharmacy/features/dispose/domain/entities/dispose_item.dart';

class DisposeRetrieve {
  final String id;
  final String user;
  final List<DisposeItem> disposeList;

  DisposeRetrieve(
      {required this.id, required this.user, required this.disposeList});

  factory DisposeRetrieve.fromJson(Map<String, dynamic> json) {
    List items = json['items'];
    List<DisposeItem> disposeList = [];
    for (var element in items) {
      disposeList.add(DisposeItem.fromJson(element));
    }
    return DisposeRetrieve(
        id: json['id'], user: json['user'], disposeList: disposeList);
  }
}
