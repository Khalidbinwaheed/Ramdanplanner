// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_entry_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DayEntryAdapter extends TypeAdapter<DayEntry> {
  @override
  final int typeId = 1;

  @override
  DayEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DayEntry(
      dayNumber: fields[0] as int,
      dateG: fields[1] as DateTime,
      dateH: fields[2] as String,
      fastKept: fields[3] as bool,
      sadaqahAmount: fields[4] as double,
      istighfarCount: fields[5] as int,
      duroodCount: fields[6] as int,
      subhanAllahCount: fields[20] == null ? 0 : fields[20] as int,
      prayers: (fields[7] as Map).map((dynamic k, dynamic v) =>
          MapEntry(k as String, (v as List).cast<String>())),
      taraweeh: fields[8] as bool,
      adhkar: (fields[9] as Map).cast<String, bool>(),
      tilawat: (fields[10] as Map).cast<String, dynamic>(),
      dars: (fields[11] as Map).cast<String, dynamic>(),
      surahMulk: fields[12] as bool,
      customItems: (fields[13] as List).cast<String>(),
      personalDuas: (fields[14] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      reflections: (fields[15] as Map).cast<String, String>(),
      progressPercent: fields[16] as double,
      updatedAt: fields[17] as DateTime,
      istighfar1000x: fields[18] as bool,
      durood100x: fields[19] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DayEntry obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.dayNumber)
      ..writeByte(1)
      ..write(obj.dateG)
      ..writeByte(2)
      ..write(obj.dateH)
      ..writeByte(3)
      ..write(obj.fastKept)
      ..writeByte(4)
      ..write(obj.sadaqahAmount)
      ..writeByte(5)
      ..write(obj.istighfarCount)
      ..writeByte(6)
      ..write(obj.duroodCount)
      ..writeByte(7)
      ..write(obj.prayers)
      ..writeByte(8)
      ..write(obj.taraweeh)
      ..writeByte(9)
      ..write(obj.adhkar)
      ..writeByte(10)
      ..write(obj.tilawat)
      ..writeByte(11)
      ..write(obj.dars)
      ..writeByte(12)
      ..write(obj.surahMulk)
      ..writeByte(13)
      ..write(obj.customItems)
      ..writeByte(14)
      ..write(obj.personalDuas)
      ..writeByte(15)
      ..write(obj.reflections)
      ..writeByte(16)
      ..write(obj.progressPercent)
      ..writeByte(17)
      ..write(obj.updatedAt)
      ..writeByte(18)
      ..write(obj.istighfar1000x)
      ..writeByte(19)
      ..write(obj.durood100x)
      ..writeByte(20)
      ..write(obj.subhanAllahCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
