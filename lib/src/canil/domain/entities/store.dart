// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'store.g.dart';

@JsonSerializable(explicitToJson: true)
class Store {
  final List<String> breeds;
  final String name;
  final List<ContactInfo> phones;
  final ContactInfo whatsapp;
  final ContactInfo instagram;
  final String address;
  final String cep;
  final String obs;

  Store({
    required this.breeds,
    required this.name,
    required this.phones,
    required this.whatsapp,
    required this.instagram,
    required this.address,
    required this.cep,
    required this.obs,
  });

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);
  Map<String, dynamic> toJson() => _$StoreToJson(this);
}

enum ContactValidationStatus {
  valid,
  invalid,
  notFound, //TODO: String.empty => notFound
  validationRequired
}

@JsonSerializable()
class ContactInfo {
  late String value;
  late ContactValidationStatus status;
  final String? message;

  ContactInfo({
    required this.value,
    ContactValidationStatus? status,
    this.message,
  }) {
    this.status = status ??
        (value.isEmpty
            ? ContactValidationStatus.notFound
            : ContactValidationStatus.validationRequired);
  }

  factory ContactInfo.fromJson(Map<String, dynamic> json) =>
      _$ContactInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ContactInfoToJson(this);
}
