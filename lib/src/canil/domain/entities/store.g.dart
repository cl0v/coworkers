// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Store _$StoreFromJson(Map<String, dynamic> json) => Store(
      json['breed'] as String,
      json['name'] as String,
      (json['phones'] as List<dynamic>)
          .map((e) => ContactInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      ContactInfo.fromJson(json['instagram'] as Map<String, dynamic>),
      ContactInfo.fromJson(json['whatsapp'] as Map<String, dynamic>),
      json['address'] as String,
      json['cep'] as String,
      json['obs'] as String,
    );

Map<String, dynamic> _$StoreToJson(Store instance) => <String, dynamic>{
      'breed': instance.breed,
      'name': instance.name,
      'phones': instance.phones,
      'whatsapp': instance.whatsapp,
      'instagram': instance.instagram,
      'address': instance.address,
      'cep': instance.cep,
      'obs': instance.obs,
    };

ContactInfo _$ContactInfoFromJson(Map<String, dynamic> json) => ContactInfo(
      value: json['value'] as String,
      status:
          $enumDecodeNullable(_$ContactValidationStatusEnumMap, json['status']),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$ContactInfoToJson(ContactInfo instance) =>
    <String, dynamic>{
      'value': instance.value,
      'status': _$ContactValidationStatusEnumMap[instance.status]!,
      'message': instance.message,
    };

const _$ContactValidationStatusEnumMap = {
  ContactValidationStatus.valid: 'valid',
  ContactValidationStatus.invalid: 'invalid',
  ContactValidationStatus.notFound: 'notFound',
  ContactValidationStatus.validationRequired: 'validationRequired',
};
