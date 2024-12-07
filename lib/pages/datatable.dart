import 'package:flutter/material.dart';
import 'package:myapp/datasources/dessert_data_source.dart';
import 'package:myapp/models/dessert.dart';

class MyDatatable extends StatefulWidget {
  const MyDatatable({super.key});

  @override
  _MyDatatableState createState() => _MyDatatableState();
}

class RestorableDessertSelections extends RestorableProperty<Set<int>> {
  Set<int> _dessertSelections = {};

  bool isSelected(int index) => _dessertSelections.contains(index);

  void setDessertSelections(List<Dessert> desserts) {
    final updatedSet = <int>{};
    for (var i = 0; i < desserts.length; i++) {
      if (desserts[i].selected) {
        updatedSet.add(i);
      }
    }
    _dessertSelections = updatedSet;
    notifyListeners();
  }

  @override
  Set<int> createDefaultValue() => _dessertSelections;

  @override
  Set<int> fromPrimitives(Object? data) {
    final selectedItemIndices = data as List<dynamic>;
    _dessertSelections = {
      ...selectedItemIndices.map<int>((dynamic id) => id as int),
    };
    return _dessertSelections;
  }

  @override
  void initWithValue(Set<int> value) {
    _dessertSelections = value;
  }

  @override
  Object toPrimitives() => _dessertSelections.toList();
}

class _MyDatatableState extends State<MyDatatable> with RestorationMixin {
  final RestorableDessertSelections _dessertSelections = RestorableDessertSelections();
  final RestorableInt _rowIndex = RestorableInt(0);
  final RestorableInt _rowsPerPage = RestorableInt(PaginatedDataTable.defaultRowsPerPage);
  final RestorableBool _sortAscending = RestorableBool(true);
  final RestorableIntN _sortColumnIndex = RestorableIntN(null);
  
  DessertDataSource? _dessertsDataSource;

  @override
  String get restorationId => 'data_table_demo';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_dessertSelections, 'selected_row_indices');
    registerForRestoration(_rowIndex, 'current_row_index');
    registerForRestoration(_rowsPerPage, 'rows_per_page');
    registerForRestoration(_sortAscending, 'sort_ascending');
    registerForRestoration(_sortColumnIndex, 'sort_column_index');

    _dessertsDataSource ??= DessertDataSource(context);
    
    switch (_sortColumnIndex.value) {
      case 0:
        _dessertsDataSource!.sort<String>((d) => d.name, _sortAscending.value);
        break;
      case 1:
        _dessertsDataSource!.sort<num>((d) => d.calories, _sortAscending.value);
        break;
      case 2:
        _dessertsDataSource!.sort<num>((d) => d.fat, _sortAscending.value);
        break;
      case 3:
        _dessertsDataSource!.sort<num>((d) => d.carbs, _sortAscending.value);
        break;
      case 4:
        _dessertsDataSource!.sort<num>((d) => d.protein, _sortAscending.value);
        break;
      case 5:
        _dessertsDataSource!.sort<num>((d) => d.sodium, _sortAscending.value);
        break;
      case 6:
        _dessertsDataSource!.sort<num>((d) => d.calcium, _sortAscending.value);
        break;
      case 7:
        _dessertsDataSource!.sort<num>((d) => d.iron, _sortAscending.value);
        break;
    }

    _dessertsDataSource!.updateSelectedDesserts(_dessertSelections);
    _dessertsDataSource!.addListener(_updateSelectedDessertRowListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dessertsDataSource ??= DessertDataSource(context);
    _dessertsDataSource!.addListener(_updateSelectedDessertRowListener);
  }

  @override
  void dispose() {
    _rowsPerPage.dispose();
    _sortColumnIndex.dispose();
    _sortAscending.dispose();
    _dessertsDataSource!.removeListener(_updateSelectedDessertRowListener);
    _dessertsDataSource!.dispose();
    super.dispose();
  }

  void _updateSelectedDessertRowListener() {
    _dessertSelections.setDessertSelections(_dessertsDataSource!.desserts);
  }

  void _sort<T>(Comparable<T> Function(Dessert d) getField, int columnIndex, bool ascending) {
    _dessertsDataSource!.sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex.value = columnIndex;
      _sortAscending.value = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Data Table'),
      ),
      body: Scrollbar(
        child: ListView(
          children: [
            PaginatedDataTable(
              header: const Text('Nutrition'),
              rowsPerPage: _rowsPerPage.value,
              initialFirstRowIndex: _rowIndex.value,
              sortColumnIndex: _sortColumnIndex.value,
              sortAscending: _sortAscending.value,
              onRowsPerPageChanged: (value) {
                setState(() {
                  _rowsPerPage.value = value!;
                });
              },
              onPageChanged: (rowIndex) {
                setState(() {
                  _rowIndex.value = rowIndex;
                });
              },
              onSelectAll: _dessertsDataSource!.selectAll,
              columns: [
                DataColumn(
                  label: const Text('Dessert 1 serving'),
                  onSort: (int columnIndex, bool ascending) {
                    setState(() {
                      _sort<String>((d) => d.name, columnIndex, ascending);
                    });
                  },
                ),
                DataColumn(
                  label: const Text('Calories'),
                  onSort: (int columnIndex, bool ascending) {
                    setState(() {
                      _sort<num>((d) => d.calories, columnIndex, ascending);
                    });
                  },
                ),
                DataColumn(
                  label: const Text('Fat (g)'),
                  onSort: (int columnIndex, bool ascending) {
                    setState(() {
                      _sort<num>((d) => d.fat, columnIndex, ascending);
                    });
                  },
                ),
                DataColumn(
                  label: const Text('Carbs (g)'),
                  onSort: (int columnIndex, bool ascending) {
                    setState(() {
                      _sort<num>((d) => d.carbs, columnIndex, ascending);
                    });
                  },
                ),
                DataColumn(
                  label: const Text('Protein (g)'),
                  onSort: (int columnIndex, bool ascending) {
                    setState(() {
                      _sort<num>((d) => d.protein, columnIndex, ascending);
                    });
                  },
                ),
                DataColumn(
                  label: const Text('Sodium (mg)'),
                  onSort: (int columnIndex, bool ascending) {
                    setState(() {
                      _sort<num>((d) => d.sodium, columnIndex, ascending);
                    });
                  },
                ),
                DataColumn(
                  label: const Text('Calcium (%)'),
                  onSort: (int columnIndex, bool ascending) {
                    setState(() {
                      _sort<num>((d) => d.calcium, columnIndex, ascending);
                    });
                  },
                ),
                DataColumn(
                  label: const Text('Iron (%)'),
                  onSort: (int columnIndex, bool ascending) {
                    setState(() {
                      _sort<num>((d) => d.iron, columnIndex, ascending);
                    });
                  },
                ),
              ],
              source: _dessertsDataSource!,
            ),
          ],
        ),
      ),
    );
  }
}
