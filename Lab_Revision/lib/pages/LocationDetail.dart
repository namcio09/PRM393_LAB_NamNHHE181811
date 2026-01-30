import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab_revision/entity/Location.dart';
import 'package:lab_revision/widgets/LocationWidget.dart';

class LocationDetailPage extends StatelessWidget {
  final Location product;

  LocationDetailPage({required this.product});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Location List")),
      body: LocationInformation(product: product)
      );
  }
}