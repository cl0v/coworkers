import 'dart:convert';
import 'dart:io';

/// How to use:
/// on terminal run `dart history_json.dart <filename>`
void main(List<String> args) {
  List<dynamic> json = readJson(args[0]);
  json = fixJson(json);
  writeJson(args[0], json);
}

Map<String, dynamic>? _convertVisitTime(dynamic c) {
  Map<String, dynamic> json = c as Map<String, dynamic>;
  // print(json['visitTime']);
  // if (!json['title'].contains('- Pesquisa Google')) return null;
  // if (json['title'].contains('ddd')) return null;
  json['visitTime'] = convertTimestampToDateTime(json['visitTime']);
  json.remove("id");
  json.remove("referringVisitId");
  json.remove('lastVisitTime');
  json.remove("transition");
  json.remove("visitId");
  json.remove("typedCount");
  // json.remove("url");
  // print(DateTime.fromMillisecondsSinceEpoch(v.round()));
  // print(DateTime.fromMillisecondsSinceEpoch(int.parse(v)));
  searches.add(json['title']);
  // searches.add(json['title'].replaceAll('- Pesquisa Google', ''));
  return json;
}

/// Faz a conversao do timestamp para DateTime e solicita o retorno caso o dia seja diferente do dia atual
String convertTimestampToDateTime(timestamp) {
  final DateTime t = DateTime.fromMillisecondsSinceEpoch((timestamp).toInt());
  return t.toString();
}

List<String> searches = [];

List<dynamic> fixJson(List<dynamic> json) {
  return json.map(_convertVisitTime).where((element) {
    return element != null;
  }).toList();
}

List<dynamic> readJson(String filename) {
  var file = File(filename);
  var contents = file.readAsStringSync();
  var json = jsonDecode(contents);
  return json;
}

void writeJson(String filename, dynamic json) {
  var file = File('temp/$filename');
  var contents = jsonEncode(json);
  file.writeAsStringSync(contents);
}
