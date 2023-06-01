import 'package:coworkers/src/utils/regex.dart';

class SplitPhone {
  final String phone;

  SplitPhone(this.phone);

  List<String> call() => phone.split(splitBySpecialsRegex).map((e) => e.trim()).toList();
}