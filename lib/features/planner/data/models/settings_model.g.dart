// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShellUserSettingsAdapter extends TypeAdapter<ShellUserSettings> {
  @override
  final int typeId = 0;

  @override
  ShellUserSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShellUserSettings(
      language: fields[0] as String,
      theme: fields[1] as String,
      currency: fields[2] as String,
      city: fields[3] as String?,
      country: fields[4] as String?,
      latitude: fields[5] as double?,
      longitude: fields[6] as double?,
      timezone: fields[7] as String,
      calculationMethod: fields[8] as int,
      asrSchool: fields[9] as int,
      notifications: fields[10] as bool,
      userName: fields[11] as String?,
      tasbihName: fields[12] as String?,
      tasbihCount: fields[13] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ShellUserSettings obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.language)
      ..writeByte(1)
      ..write(obj.theme)
      ..writeByte(2)
      ..write(obj.currency)
      ..writeByte(3)
      ..write(obj.city)
      ..writeByte(4)
      ..write(obj.country)
      ..writeByte(5)
      ..write(obj.latitude)
      ..writeByte(6)
      ..write(obj.longitude)
      ..writeByte(7)
      ..write(obj.timezone)
      ..writeByte(8)
      ..write(obj.calculationMethod)
      ..writeByte(9)
      ..write(obj.asrSchool)
      ..writeByte(10)
      ..write(obj.notifications)
      ..writeByte(11)
      ..write(obj.userName)
      ..writeByte(12)
      ..write(obj.tasbihName)
      ..writeByte(13)
      ..write(obj.tasbihCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShellUserSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
