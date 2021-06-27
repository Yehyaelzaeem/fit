import 'package:app/app/utils/theme/app_colors.dart';
import 'package:app/app/widgets/default/CircularLoadingWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomeSlider extends StatefulWidget {
  final List<String> sliders;

  HomeSlider({required this.sliders});

  @override
  _HomeSliderState createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  var _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Stack(
        children: <Widget>[
          CarouselSlider(
            items: widget.sliders.map((singleSlider) {
              return Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: singleSlider,
                        errorWidget: (vtx, url, obj) {
                          return Container();
                        },
                        placeholder: (ctx, url) {
                          return CircularLoadingWidget();
                        },
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
            options: CarouselOptions(
              aspectRatio: 3,
              viewportFraction: 1.0,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 650),
              enlargeCenterPage: false,
              disableCenter: false,
              scrollDirection: Axis.horizontal,
              // to see it like cards
              initialPage: _currentPage,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
//              height: 500,
              onPageChanged: (pageNo, reason) {
                setState(() {
                  _currentPage = pageNo;
                });
              },
            ),
          ),
          Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ...widget.sliders.map((singleString) {
                    var index = widget.sliders.indexOf(singleString);
                    return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: _currentPage == index ? kColorPrimary : Colors.white));
                  }),
                ],
              )),
        ],
      ),
    );
  }
}
