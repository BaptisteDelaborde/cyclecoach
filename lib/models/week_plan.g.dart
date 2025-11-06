// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'week_plan.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeekPlanAdapter extends TypeAdapter<WeekPlan> {
  @override
  final int typeId = 2;

  @override
  WeekPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeekPlan(
      name: fields[0] as String,
      startDate: fields[1] as DateTime,
      weeks: fields[2] as int,
      template: (fields[3] as Map).cast<int, TrainingTemplate>(),
    );
  }

  @override
  void write(BinaryWriter writer, WeekPlan obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.startDate)
      ..writeByte(2)
      ..write(obj.weeks)
      ..writeByte(3)
      ..write(obj.template);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeekPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TrainingTemplateAdapter extends TypeAdapter<TrainingTemplate> {
  @override
  final int typeId = 3;

  @override
  TrainingTemplate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrainingTemplate(
      isRest: fields[0] as bool,
      title: fields[1] as String,
      duration: fields[2] as int,
      zone: fields[3] as String,
      details: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TrainingTemplate obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.isRest)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.duration)
      ..writeByte(3)
      ..write(obj.zone)
      ..writeByte(4)
      ..write(obj.details);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrainingTemplateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
