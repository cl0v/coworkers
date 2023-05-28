// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Store _$StoreFromJson(Map<String, dynamic> json) => Store(
      breeds:
          (json['breeds'] as List<dynamic>).map((e) => e as String).toList(),
      name: json['name'] as String,
      phones: (json['phones'] as List<dynamic>)
          .map((e) => ContactInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      whatsapp: ContactInfo.fromJson(json['whatsapp'] as Map<String, dynamic>),
      instagram:
          ContactInfo.fromJson(json['instagram'] as Map<String, dynamic>),
      address: json['address'] as String,
      cep: json['cep'] as String,
      obs: json['obs'] as String,
    );

Map<String, dynamic> _$StoreToJson(Store instance) => <String, dynamic>{
      'breeds': instance.breeds,
      'name': instance.name,
      'phones': instance.phones.map((e) => e.toJson()).toList(),
      'whatsapp': instance.whatsapp.toJson(),
      'instagram': instance.instagram.toJson(),
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
