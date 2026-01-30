import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab_revision/pages/LocationDetail.dart';

import '../entity/Location.dart';

class LocationImage extends StatelessWidget {
  Location product;

  LocationImage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(child: Image.asset(product.imageUrl, fit: BoxFit.fill));
  }
}

class LocationInfo extends StatefulWidget {
  Location product;

  LocationInfo({required this.product});

  @override
  State<StatefulWidget> createState() => LocationInfoState(product: product);
}

class LocationInfoState extends State<LocationInfo> {
  Location product;

  IncreaseStar() {
    setState(() {
      product = product.copyWith(countStar: product.countStar + 1);
    });
  }

  LocationInfoState({required this.product});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          // product name
          flex: 6,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(product.id), Text(product.name)],
          ),
        ),
        Expanded(
          flex: 1,
          child: IconButton(
            onPressed: () {
              IncreaseStar();
            },
            icon: Icon(
              Icons.star,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(flex: 1, child: Text(product.countStar.toString())),
        Expanded(
          flex: 3,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LocationDetailPage(product: product),
                ),
              );
            },
            child: Text("View Detail"),
          ),
        ),
      ],
    );
  }
}

class IconText extends StatelessWidget {
  IconData iconData;
  String content;

  IconText({required this.iconData, required this.content});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [Icon(iconData), Text(content)],
    );
  }
}

class LocationContact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconText(iconData: Icons.call, content: "CALL"),
        IconText(iconData: Icons.near_me, content: "ROUTE"),
        IconText(iconData: Icons.share, content: "SHARE"),
      ],
    );
  }
}

class LocationDescription extends StatelessWidget {
  final Location product;

  LocationDescription({required this.product});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Text(
        product.description,
        textAlign: TextAlign.justify,
        // overflow: TextOverflow.clip,
      ),
    );
  }
}

class LocationInformation extends StatelessWidget {
  Location product;

  LocationInformation({required this.product});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 400,
      child: Column(
        children: [
          Expanded(flex: 3, child: LocationImage(product: product)),
          Expanded(flex: 1, child: LocationInfo(product: product)),
          Expanded(flex: 1, child: LocationContact()),
          Expanded(flex: 3, child: LocationDescription(product: product)),
        ],
      ),
    );
  }
}
