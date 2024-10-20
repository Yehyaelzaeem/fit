
import 'package:app/core/resources/app_assets.dart';
import 'package:app/core/view/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../core/models/orientation_videos_response.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/resources/resources.dart';
import '../../../core/services/api_provider.dart';
import '../../../core/utils/alerts.dart';
import '../../../core/view/widgets/default/CircularLoadingWidget.dart';
import '../../../core/view/widgets/default/text.dart';
import '../../../core/view/widgets/error_handler_widget.dart';
import '../../../core/view/widgets/fit_new_app_bar.dart';
import '../../../core/view/widgets/page_lable.dart';
import '../../home/cubits/home_cubit.dart';
import '../../home/view/widgets/home_appbar.dart';
import '../../videos/video_player_widget.dart';


class OrientationView extends StatefulWidget {
  @override
  State<OrientationView> createState() => _OrientationViewState();
}

class _OrientationViewState extends State<OrientationView> {


  late final HomeCubit homeCubit;


  @override
  void initState() {
    homeCubit = BlocProvider.of<HomeCubit>(context);
    homeCubit.fetchOrientationVideos();
    // getHomeData();
    super.initState();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(body:ListView(children: [
      FitNewAppBar(
        title: "Orientation",
      ),

          SizedBox(height: 12),

          BlocConsumer<HomeCubit, HomeStates>(
            listener: (context, state) {
              if (state is HomePageFailureState) {
                Alerts.showToast(state.failure.message);
              }

            },
            builder: (context, state) => state is OrientationLoading
                ? Container(
              height: AppSize.s250,
              padding: const EdgeInsets.symmetric(vertical: 100),
              child: Center(child: CircularLoadingWidget()),
            )
                : homeCubit.orientationVideosResponse.data == null
              ? Padding(
                  padding: EdgeInsets.only(top: deviceHeight * 0.2),
                  child: Column(
                    children: [
                      Image.asset(
                        AppImages.kEmptyPackage,
                        scale: 5,
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      kTextbody("  Empty!  ", size: 16),
                    ],
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 18,
                    childAspectRatio: 0.9,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: homeCubit.orientationVideosResponse.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.all(4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => VideoPlayerWidget(
                                          link: homeCubit.orientationVideosResponse
                                                  .data?[index]
                                                  .videoUrl ??
                                              "")));
                            },
                            child: Container(
                              height: MediaQuery.of(context).orientation ==
                                      Orientation.landscape
                                  ? deviceHeight * 0.6
                                  : deviceHeight * 0.18,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  image: DecorationImage(
                                      image: NetworkImage(homeCubit.orientationVideosResponse
                                              .data?[index]
                                              .image ??
                                          ""),
                                      fit: MediaQuery.of(context).orientation ==
                                              Orientation.landscape
                                          ? BoxFit.fill
                                          : BoxFit.cover)),
                              child: Center(
                                child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                    child: Icon(
                                      Icons.play_circle,
                                      color: kColorPrimary,
                                    )),
                              ),
                            ),
                          ),
                          VerticalSpace(AppSize.s2),
                          Center(
                              child: CustomText(
                                  homeCubit.orientationVideosResponse
                              .data?[index].name ??
                                      "",
                                  textAlign: TextAlign.center,
                                  fontSize: FontSize.s14)),
                        ],
                      ),
                    );
                  }),),
        ]),
    );
  }
}
