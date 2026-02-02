// class SaleAdd {
//   final List<Items> items;
//
//   SaleAdd({required this.items});
//
//   factory SaleAdd.fromJson(Map<String, dynamic> json) {
//     return SaleAdd(
//       items: (json['items'] as List).map((e) => Items.fromJson(e)).toList(),
//     );
//   }
//
//   // Map<String, dynamic> toJson() {
//     // final Map<String, dynamic> data = <String, dynamic>{};
//     // data['items'] = items.map((e) => e.toJson()).toList();
//     // return data;
//   // }
// }
//
// class Items {
//   final int? id;
//   final int medicine;
//   final int quantity;
//   final int price;
//
//   Items(
//       {this.id,
//       required this.medicine,
//       required this.quantity,
//       required this.price});
//
//   factory Items.fromJson(Map<String, dynamic> json) {
//     return Items(
//         id: json['id'],
//         medicine: json['medicine'],
//         quantity: json['quantity'],
//         price: json['price']);
//   }
//
//  static List<Map<String, dynamic>> toJson(List<Items> items) {
//     List<Map<String, dynamic>> newList = List.empty(growable: true);
//     for (Items element in items) {
//       newList.add(toJsonOne(element));
//     }
//     // for (var element in newList) {print(jsonEncode(newList));}
//     // data['medicine'] = medicine;
//     // data['quantity'] = quantity;
//     // data['price'] = price;
//     return newList;
//   }
//
//  static Map<String, dynamic> toJsonOne(Items item) {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = item.id;
//     data['medicine'] = item.medicine;
//     data['quantity'] = item.quantity;
//     data['price'] = item.price;
//     return data;
//   }
// }
