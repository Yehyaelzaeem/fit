import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CheerFullSlider extends StatefulWidget {
  final List<String> sliders;

  CheerFullSlider({required this.sliders});

  @override
  _CheerFullSliderState createState() => _CheerFullSliderState();
}

class _CheerFullSliderState extends State<CheerFullSlider> {
  var _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          CarouselSlider(
            items: widget.sliders.map((singleSlider) {
              // return Container(
              //   width: double.infinity,
              //   child: Image.asset(
              //     singleSlider,
              //     width: double.infinity,
              //     fit: BoxFit.fitWidth,
              //   ),
              // );
              return Container(
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: singleSlider,
                  fadeInDuration: Duration(seconds: 2),
                  errorWidget: (vtx, url, obj) {
                    return Container();
                  },
                  placeholder: (ctx, url) {
                    return CircularLoadingWidget();
                  },
                  // fit: BoxFit.c,
                ),
              );
            }).toList(),
            options: CarouselOptions(
              aspectRatio: 2.6,
              viewportFraction: 1,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 650),
              enlargeCenterPage: false,
              disableCenter: false,
              scrollDirection: Axis.horizontal,
              // to see it like cards
              initialPage: _currentPage,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: false,
//              height: 500,
              onPageChanged: (pageNo, reason) {
                setState(() {
                  _currentPage = pageNo;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ...widget.sliders.map((singleString) {
                var index = widget.sliders.indexOf(singleString);
                return Container(
                    width: 8.0,
                    height: 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? kColorPrimary
                            : Colors.grey));
              }),
            ],
          ),
        ],
      ),
    );
  }
}
