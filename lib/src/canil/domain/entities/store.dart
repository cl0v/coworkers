// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'store.g.dart';

@JsonSerializable()
class Store {

  final String name;
  final String phone;
  final String instagram;
  final String address;
  final String cep;
  final String obs;

  Store(
    this.name,
    this.phone,
    this.instagram,
    this.address,
    this.cep,
    this.obs,
  );

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);
  Map<String, dynamic> toJson() => _$StoreToJson(this);
}
