// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RestaurantListAdapter extends TypeAdapter<RestaurantList> {
  @override
  final int typeId = 0;

  @override
  RestaurantList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RestaurantList(
      id: fields[0] as String,
      name: fields[1] as String,
      city: fields[2] as String,
      imageLink: fields[3] as String,
      description: fields[4] as String,
      rating: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, RestaurantList obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.city)
      ..writeByte(3)
      ..write(obj.imageLink)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.rating);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RestaurantListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
