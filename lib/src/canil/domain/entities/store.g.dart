// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Store _$StoreFromJson(Map<String, dynamic> json) => Store(
      json['name'] as String,
      json['phone'] as String,
      json['instagram'] as String,
      json['address'] as String,
      json['cep'] as String,
    );

Map<String, dynamic> _$StoreToJson(Store instance) => <String, dynamic>{
      'name': instance.name,
      'phone': instance.phone,
      'instagram': instance.instagram,
      'address': instance.address,
      'cep': instance.cep,
    };
