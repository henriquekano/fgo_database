import 'package:cloud_firestore/cloud_firestore.dart';

class FilterServants {
  final List<Map<String, dynamic>> _servants;
  FilterServants(this._servants);
  final Map<String, dynamic> _filter = {
    'name': null,
    'classes': null,
  };

  FilterServants setNameFilter(String nameFitler) {
    _filter['name'] = nameFitler;
    return this;
  }

  FilterServants setClasses(List<String> classes) {
    _filter['classes'] = classes;
    return this;
  }

  bool _compareName(Map<String, dynamic> doc) {
    final String servantName = doc['name'];
    final String filterName = _filter['name'];
    return filterName != null && filterName.isNotEmpty
      ? servantName.toLowerCase().contains(
        filterName.toLowerCase()
      )
      : true;
  }

  bool _compareClass(Map<String, dynamic> doc) {
    final String servantClass = doc['status']['class'].toLowerCase();
    final List<String> filterClasses = _filter['classes'];
    return filterClasses != null && filterClasses.isNotEmpty
      ? filterClasses.map((i) => i.toLowerCase()).contains(servantClass)
      : true;
  }

  List<Map<String, dynamic>> filter() {
    return _servants
      .where(_compareName)
      .where(_compareClass)
      .toList();
  }
}