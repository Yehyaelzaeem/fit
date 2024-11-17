import 'package:app/core/resources/resources.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../core/models/about_response.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/utils/alerts.dart';
import '../../../core/view/widgets/default/CircularLoadingWidget.dart';
import '../../../core/view/widgets/fit_new_app_bar.dart';
import '../../../core/view/widgets/page_lable.dart';
import '../../home/view/widgets/home_appbar.dart';
import '../cubits/about_cubit.dart';

class AboutView extends StatefulWidget {
const AboutView({Key? key}) : super(key: key);

@override
State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {

  late final AboutCubit aboutCubit;


  @override
  void initState() {
    super.initState();
    aboutCubit = BlocProvider.of<AboutCubit>(context);
    aboutCubit.fetchAboutData();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: [
          FitNewAppBar(
            title: "About us",
          ),
        BlocConsumer<AboutCubit, AboutState>(
            listener: (context, state) {
              if (state is AboutError) {
                Alerts.showToast(state.message);
              }

            },
          builder: (context, state) {
            if (state is AboutLoading) {
              return SizedBox(

                  child: CircularLoadingWidget());
            } else if (state is AboutLoaded) {
              AboutResponse response = state.aboutData;
              return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: response.data!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  "${response.data![index].title}",
                                  style: TextStyle(
                                      color: kColorPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 18),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                      width: deviceWidth,
                                      child: Html(
                                          data:
                                          """${response.data![index].text}""")),
                                  Container(
                                    width: deviceWidth,
                                    child: CachedNetworkImage(
                                      imageUrl: "${response.data![index].image}",
                                      fadeInDuration: Duration(seconds: 2),
                                      errorWidget: (vtx, url, obj) {
                                        return Container();
                                      },
                                      placeholder: (ctx, url) {
                                        return CircularLoadingWidget();
                                      },
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 3,
                        ),
                      ],
                    );
                  });  // Display the data here
            } else if (state is AboutError) {
              return Text(state.message);
            }

            return Container();
          },
        ),

      SizedBox(height: deviceWidth / 14),
    ]));
  }
}
