// // GENERATED CODE - DO NOT MODIFY BY HAND
//
// part of 'medicine.dart';
//
// // **************************************************************************
// // TypeAdapterGenerator
// // **************************************************************************
//
// class MedicineSearchAdapter extends TypeAdapter<MedicineSearch> {
//   @override
//   final int typeId = 0;
//
//   @override
//   MedicineSearch read(BinaryReader reader) {
//     final numOfFields = reader.readByte();
//     final fields = <int, dynamic>{
//       for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return MedicineSearch(
//       id: fields[0] as int,
//       barcode: fields[3] as String,
//       brandName: fields[1] as String,
//       price: fields[2] as int,
//       type: fields[4] as String,
//       quantity: fields[5] as int,
//       expiryDate: fields[6] as String,
//       companyName: fields[7] as String?,
//       isNeedPrescription: fields[8] as bool?,
//       isActive: fields[9] as bool?,
//     );
//   }
//
//   @override
//   void write(BinaryWriter writer, MedicineSearch obj) {
//     writer
//       ..writeByte(10)
//       ..writeByte(0)
//       ..write(obj.id)
//       ..writeByte(1)
//       ..write(obj.brandName)
//       ..writeByte(2)
//       ..write(obj.price)
//       ..writeByte(3)
//       ..write(obj.barcode)
//       ..writeByte(4)
//       ..write(obj.type)
//       ..writeByte(5)
//       ..write(obj.quantity)
//       ..writeByte(6)
//       ..write(obj.expiryDate)
//       ..writeByte(7)
//       ..write(obj.companyName)
//       ..writeByte(8)
//       ..write(obj.isNeedPrescription)
//       ..writeByte(9)
//       ..write(obj.isActive);
//   }
//
//   @override
//   int get hashCode => typeId.hashCode;
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is MedicineSearchAdapter &&
//           runtimeType == other.runtimeType &&
//           typeId == other.typeId;
// }
