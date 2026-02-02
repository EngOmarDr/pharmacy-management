class Shift {
  final String name;
  final String startTime;
  final String endTime;
  final List<int> days;

  Shift({
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.days,
  });

}

enum Role {
  seller(value: 'S'),
  purchaser(value: 'P'),
  purchaserAndSeller(value: 'PS'),
  pharmacyManager(value: 'PM'),
  manager(value: 'M');

  const Role({required this.value});

  final String value;
}