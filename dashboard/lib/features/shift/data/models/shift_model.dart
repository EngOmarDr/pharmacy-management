import 'package:dashboard/features/shift/domain/entities/shift.dart';

class ShiftModel extends Shift {
  final int id;

  ShiftModel(
      {required this.id,
      required super.name,
      required super.startTime,
      required super.endTime,
      required super.days});

  factory ShiftModel.fromJson(Map json) {
    List<int>day = [];
    for(var ele in json['days']){
      day.add(ele);
    }
    return ShiftModel(
        id: json['id'],
        name: json['name'],
        startTime: json['start_time'],
        endTime: json['end_time'],
        days: day);
  }



  Map<String,dynamic> toJson()=> {
    'name' : name,
    'start_time' : startTime,
    'end_time':endTime,
    'days': days
  };

}
