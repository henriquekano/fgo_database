import 'dart:async';
import 'dart:convert'
  show json;
import 'package:http/http.dart'
  show get, Response;

const ENDPOINT = 'https://fgo-database-api.herokuapp.com';

List<Map<String, dynamic>> _pickDocs(Response response) {
  final parsedResponse = Map<String, dynamic>.from(json.decode(response.body));
  return List<Map<String, dynamic>>.from(parsedResponse['docs']);
}

Future<List<Map<String, dynamic>>> fetchServants() {
  return get('$ENDPOINT/servant')
    .then(_pickDocs);
}

Future<List<Map<String, dynamic>>> fetchActiveSkills({ String servantId }) {
  var url = '$ENDPOINT/active_skill?';
  if (servantId != null) {
    url = '${url}servant=$servantId';
  }
  return get(url)
    .then(_pickDocs);
}

Future<List<Map<String, dynamic>>> fetchClassSkills({ String servantId }) {
  var url = '$ENDPOINT/class_skill?';
  if (servantId != null) {
    url = '${url}servant=$servantId';
  }
  return get(url)
    .then(_pickDocs);
}

Future<List<Map<String, dynamic>>> fetchItems() {
  var url = '$ENDPOINT/item';
  return get(url)
    .then(_pickDocs);
}

Future<List<Map<String, dynamic>>> fetchCraftEssences() {
  var url = '$ENDPOINT/craft_essence';
  return get(url)
    .then(_pickDocs);
}
