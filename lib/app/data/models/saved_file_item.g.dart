// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_file_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedFileItemAdapter extends TypeAdapter<SavedFileItem> {
  @override
  final int typeId = 0;

  @override
  SavedFileItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedFileItem(
      id: fields[0] as String,
      fileName: fields[1] as String,
      filePath: fields[2] as String,
      dateSaved: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SavedFileItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fileName)
      ..writeByte(2)
      ..write(obj.filePath)
      ..writeByte(3)
      ..write(obj.dateSaved);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedFileItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
