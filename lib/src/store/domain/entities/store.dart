// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'store.g.dart';

@JsonSerializable(explicitToJson: true)
class Store {
  @JsonKey(includeToJson: false)
  late String id;
  List<String> breeds;
  String name;
  ContactInfo contact;
  String address;
  String cep;
  String obs;

  Store({
    required this.breeds,
    required this.name,
    required this.contact,
    required this.address,
    required this.cep,
    required this.obs,
  });

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);
  Map<String, dynamic> toJson() => _$StoreToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ContactInfo {
  final List<String> phones;
  final bool isWhatsAppSameAsPhone;
  late List<ContactDetails>? phonesDetails;
  late ContactDetails? whatsappDetails;
  late ContactDetails? instagramDetails;

  ContactInfo({
    required this.phones,
    this.isWhatsAppSameAsPhone = false,
    String? whatsapp,
    String? instagram,
  }) {
    if (instagram != null) {
      instagramDetails = ContactDetails(value: instagram);
    }
    if (phones.isNotEmpty) {
      phonesDetails =
          phones.map<ContactDetails>((e) => ContactDetails(value: e)).toList();
      if (!isWhatsAppSameAsPhone && whatsapp != null && whatsapp.isNotEmpty) {
        whatsappDetails = ContactDetails(value: whatsapp);
      } else {
        whatsappDetails = ContactDetails(value: phones.first);
      }
    }
  }

  factory ContactInfo.fromJson(Map<String, dynamic> json) =>
      _$ContactInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ContactInfoToJson(this);
}

enum ContactValidationStatus {
  valid,
  invalid,
  notFound, //TODO: String.empty => notFound
  validationRequired
}

@JsonSerializable()
class ContactDetails {
  late String value;
  late ContactValidationStatus status;
  final String? message;

  ContactDetails({
    required this.value,
    ContactValidationStatus? status,
    this.message,
  }) {
    this.status = status ??
        (value.isEmpty
            ? ContactValidationStatus.notFound
            : ContactValidationStatus.validationRequired);
  }

  factory ContactDetails.fromJson(Map<String, dynamic> json) =>
      _$ContactDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$ContactDetailsToJson(this);
}
