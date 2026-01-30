import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../entity/Location.dart';
import '../widgets/LocationWidget.dart';

class Locationpage extends StatelessWidget {
  List<Location> lists = Location.getList();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Location List")),
      body: ListView.builder(
        itemCount: Location.getList().length,
        itemBuilder: (context, index) =>
            LocationInformation(product: Location.getList()[index]),
      ),
      // body: LocationInformation(product: lists[0]),
    );
  }
}
