import 'package:flutter/material.dart';
import 'package:locie/components/font_text.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/helper/firestore_query.dart';
import 'package:locie/helper/local_storage.dart';
import 'package:locie/helper/screen_size.dart';
import 'package:locie/models/unit.dart';

class UnitDialog extends StatefulWidget {
  final Function(Unit) onChange;
  const UnitDialog({@required this.onChange});

  @override
  _UnitDialogState createState() => _UnitDialogState();
}

class _UnitDialogState extends State<UnitDialog> {
  bool isLoading = true;
  List<Unit> units = [];
  LocalStorage localStorage = LocalStorage();
  FireStoreQuery storeQuery = FireStoreQuery();

  void insertUnits(List<Unit> units) {
    setState(() {
      this.units = units;
      this.isLoading = false;
    });
  }

  Future<void> pullUnits() async {
    await localStorage.init();
    List<Unit> units = await storeQuery.fetchUnits();
    print(localStorage.prefs.getString("units") + "D");
    print(units);
    // //printunits);
    this.insertUnits(units);
  }

  @override
  void initState() {
    pullUnits();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Scale scale = Scale(context);
    return Dialog(
      child: PrimaryContainer(
        widget: isLoading
            ? Center(
                child: Container(
                  child: CircularProgressIndicator(),
                ),
              )
            : ListView.builder(
                itemCount: units.length,
                itemBuilder: (context, index) => Container(
                      padding: EdgeInsets.symmetric(
                          vertical: scale.vertical(8),
                          horizontal: scale.horizontal(4)),
                      child: ListTile(
                        onTap: () {
                          widget.onChange(units[index]);
                        },
                        title: LatoText(
                          '${units[index].name} (${units[index].sign})',
                          size: 18,
                        ),
                      ),
                    )),
      ),
    );
  }
}
