import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  List<dynamic> json = readJson(args[0]);
  json = fixJson(json);
  // writeJson(args[0], json);
}

Map<String, dynamic>? _removeVisitTime(dynamic c) {
  Map<String, dynamic> json = c as Map<String, dynamic>;
  // print(json['visitTime']);
  if (!json['title'].contains('- Pesquisa Google')) return null;
  print(json['title'].split('- Pesquisa Google')[0]);
  // print(DateTime.fromMillisecondsSinceEpoch(v.round()));
  // print(DateTime.fromMillisecondsSinceEpoch(int.parse(v)));
  return json;
}

List<dynamic> fixJson(List<dynamic> json) {
  return json
      .map(_removeVisitTime)
      .where((element) => element != null)
      .toList();
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
