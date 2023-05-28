// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Store _$StoreFromJson(Map<String, dynamic> json) => Store(
      breeds:
          (json['breeds'] as List<dynamic>).map((e) => e as String).toList(),
      name: json['name'] as String,
      contact: ContactInfo.fromJson(json['contact'] as Map<String, dynamic>),
      address: json['address'] as String,
      cep: json['cep'] as String,
      obs: json['obs'] as String,
    )..id = json['id'] as String;

Map<String, dynamic> _$StoreToJson(Store instance) => <String, dynamic>{
      'breeds': instance.breeds,
      'name': instance.name,
      'contact': instance.contact.toJson(),
      'address': instance.address,
      'cep': instance.cep,
      'obs': instance.obs,
    };

ContactInfo _$ContactInfoFromJson(Map<String, dynamic> json) => ContactInfo(
      phones:
          (json['phones'] as List<dynamic>).map((e) => e as String).toList(),
      isWhatsAppSameAsPhone: json['isWhatsAppSameAsPhone'] as bool? ?? false,
    )
      ..phonesDetails = (json['phonesDetails'] as List<dynamic>?)
          ?.map((e) => ContactDetails.fromJson(e as Map<String, dynamic>))
          .toList()
      ..whatsappDetails = json['whatsappDetails'] == null
          ? null
          : ContactDetails.fromJson(
              json['whatsappDetails'] as Map<String, dynamic>)
      ..instagramDetails = json['instagramDetails'] == null
          ? null
          : ContactDetails.fromJson(
              json['instagramDetails'] as Map<String, dynamic>);

Map<String, dynamic> _$ContactInfoToJson(ContactInfo instance) =>
    <String, dynamic>{
      'phones': instance.phones,
      'isWhatsAppSameAsPhone': instance.isWhatsAppSameAsPhone,
      'phonesDetails': instance.phonesDetails?.map((e) => e.toJson()).toList(),
      'whatsappDetails': instance.whatsappDetails?.toJson(),
      'instagramDetails': instance.instagramDetails?.toJson(),
    };

ContactDetails _$ContactDetailsFromJson(Map<String, dynamic> json) =>
    ContactDetails(
      value: json['value'] as String,
      status:
          $enumDecodeNullable(_$ContactValidationStatusEnumMap, json['status']),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$ContactDetailsToJson(ContactDetails instance) =>
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
