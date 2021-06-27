import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget avatar(double widthHeight) {
  return Container(
    width: widthHeight,
    height: widthHeight,
    child: CachedNetworkImage(
      imageUrl: 'imageUrl',
      errorWidget: (context, url, error) => avatarPlaceHolder(),
      placeholder: (context, url) => avatarPlaceHolder(),
    ),
  );
}

Widget avatarPlaceHolder() {
  return Container(
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.blue[100],
      borderRadius: BorderRadius.circular(250),
    ),
    child: Icon(
      Icons.person,
      color: Colors.white,
    ),
  );
}
