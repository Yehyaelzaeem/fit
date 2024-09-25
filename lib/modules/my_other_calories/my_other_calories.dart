
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../config/navigation/routes.dart';
import '../../core/models/day_details_reposne.dart' as dayDetails;
import '../../core/models/my_other_calories_response.dart';
import '../../core/resources/app_colors.dart';
import '../../core/resources/app_values.dart';
import '../../core/services/api_provider.dart';
import '../../core/utils/alerts.dart';
import '../../core/view/widgets/default/CircularLoadingWidget.dart';
import '../../core/view/widgets/default/text.dart';
import '../../core/view/widgets/page_lable.dart';
import '../diary/controllers/diary_controller.dart';
import '../diary/cubits/diary_cubit.dart';
import '../home/view/screens/home_screen.dart';
import '../home/view/widgets/home_appbar.dart';
import '../other_calories/cubits/other_calories_cubit.dart';
import 'add_new_other_calories.dart';
import 'edit_other_calory.dart';

class MyOtherCalories extends StatefulWidget {
  final bool canGoBack;

  const MyOtherCalories({this.canGoBack = false, Key? key}) : super(key: key);

  @override
  _MyOtherCaloriesState createState() => _MyOtherCaloriesState();
}

class _MyOtherCaloriesState extends State<MyOtherCalories> {
  bool isLoading = true;

  late final DiaryCubit diaryCubit;
  late final OtherCaloriesCubit otherCaloriesCubit;


  @override
  void initState() {
    super.initState();
    diaryCubit = BlocProvider.of<DiaryCubit>(context);
    otherCaloriesCubit = BlocProvider.of<OtherCaloriesCubit>(context);
    diaryCubit.fetchOtherCalories();
  }
  // MyOtherCaloriesResponse diaryCubit.otherCaloriesResponse = MyOtherCaloriesResponse();

  void getDiaryData() async {
    await ApiProvider().getOtherCaloreis().then((value) {
      if (value.success == true) {
        setState(() {
          diaryCubit.otherCaloriesResponse = value;
          isLoading = false;
        });
      } else {
        setState(() {
          diaryCubit.otherCaloriesResponse = value;
          isLoading = false;
        });
        // Fluttertoast.showToast(msg: "${value.message}");
        print("error");
      }
    });
  }

  void deleteItem(int id) async {

      await ApiProvider()
          .deleteCalorie("delete_other_calories", id)
          .then((value) {
        if (value.success == true) {
          setState(() {
            isLoading = false;
          });
          getDiaryData();
          Fluttertoast.showToast(msg: "${value.message}");
        } else {
          setState(() {
            isLoading = false;
          });
          print("error");
        }
      });

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.canGoBack) {
          return true;
        } else {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (c) => HomeScreen()), (route) => false);
          return false;
        }
      },
      child: Scaffold(
        body: BlocConsumer<DiaryCubit, DiaryState>(
            listener: (context, state) {
              if (state is DiaryFailure) {
                Alerts.showSnackBar(context, state.failure.message,duration: Time.t2s*2);
              }

              if (state is DiaryLoaded) {
                Alerts.closeAllSnackBars(context);

              }
            },
            builder: (context, state) =>
              state is DiaryLoading
                  ? CircularLoadingWidget()
                  : ListView(
                children: [
                  HomeAppbar(
                    type: null,
                    onBack: widget.canGoBack
                        ? null
                        : () {
                      Get.offAndToNamed(Routes.homeScreen);
                    },
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: PageLable(name: "My other calories"),
                      ),
                    ],
                  ),
                  rowWithProgressBar("Proteins", 1),
                  staticBar(),
                  diaryCubit.otherCaloriesResponse.data!.proteins!.isEmpty
                      ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          SizedBox(height: 24),
                          Text("No Proteins Added Yet"),
                        ],
                      ),
                    ),
                  )
                      : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount:
                      diaryCubit.otherCaloriesResponse.data!.proteins!.length,
                      itemBuilder: (context, indedx) {
                        return rowItem(
                            diaryCubit.otherCaloriesResponse.data!.proteins![indedx],
                            1);
                      }),
                  SizedBox(height: 20),
                  rowWithProgressBar("Carbs", 2),
                  staticBar(),
                  diaryCubit.otherCaloriesResponse.data!.carbs!.isEmpty
                      ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          SizedBox(height: 24),
                          Text("No Carbs Added Yet"),
                        ],
                      ),
                    ),
                  )
                      : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: diaryCubit.otherCaloriesResponse.data!.carbs!.length,
                      itemBuilder: (context, i) {
                        return rowItem(
                            diaryCubit.otherCaloriesResponse.data!.carbs![i], 2);
                      }),
                  SizedBox(height: 20),
                  rowWithProgressBar("Fats", 3),
                  staticBar(),
                  diaryCubit.otherCaloriesResponse.data!.fats!.isEmpty
                      ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          SizedBox(height: 24),
                          Text("No Fats Added Yet"),
                        ],
                      ),
                    ),
                  )
                      : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: diaryCubit.otherCaloriesResponse.data!.fats!.length,
                      itemBuilder: (context, j) {
                        return rowItem(
                            diaryCubit.otherCaloriesResponse.data!.fats![j], 3);
                      }),
                ],
              )
            ),
      ),
    );
  }

  Widget rowItem(Proteins item, int type) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (c) => EditNewCalorie(
                    type: type,
                    proteins: item,
                  ))),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 3.1,
                  child: Container(
                      padding: EdgeInsets.all(4),
                      child: Center(
                          child: kTextbody('${item.title}',
                              color: Colors.black, bold: false, size: 16))),
                ),
                Container(width: 2, color: Colors.grey, height: 25),
                Container(
                    width: MediaQuery.of(context).size.width / 4,
                    padding: EdgeInsets.all(4),
                    child: kTextbody('${item.qty}',
                        color: Colors.black, bold: false, size: 16)),
                Container(width: 2, color: Colors.grey, height: 25),
                Container(
                    width: MediaQuery.of(context).size.width / 4,
                    padding: EdgeInsets.all(4),
                    child: kTextbody('${item.calories}',
                        color: Colors.black, bold: false, size: 16)),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    width: 2,
                    color: Colors.grey,
                    height: 25),
                InkWell(
                  onTap: () async{
                    final result = await Connectivity().checkConnectivity();
                    if (result != ConnectivityResult.none) {
                      deleteItem(item.id!);
                    }else{
                      if(item.id!=null) {
                        await ApiProvider().deleteOtherCalorieLocally(item.id!);
                      }else{

                      }
                      if(type==1){
                        diaryCubit.otherCaloriesResponse.data!.proteins!.remove(item);
                      }else if(type==2){
                        diaryCubit.otherCaloriesResponse.data!.carbs!.remove(item);
                      }else if(type==3){
                        diaryCubit.otherCaloriesResponse.data!.fats!.remove(item);
                      }
                      setState(() {

                      });
                    }
                  },
                  child: Icon(Icons.delete, color: Colors.redAccent, size: 24),
                ),
                SizedBox(width: 4),
              ],
            ),
          ),
          Divider(thickness: 2, color: Colors.grey),
        ],
      ),
    );
  }

  Widget rowWithProgressBar(String Title, int type) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: InkWell(
        onTap: () async {
          dynamic result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddNewCalorie(type: type)));
          if (result == null) getDiaryData();
          if(result!=null){

            if (type == 1)diaryCubit.otherCaloriesResponse.data!.proteins!.add(result);
            if (type == 2) diaryCubit.otherCaloriesResponse.data!.carbs!.add(result);
            if (type == 3) diaryCubit.otherCaloriesResponse.data!.fats!.add(result);

            // final controllerDiary = Get.find<DiaryController>(tag: 'diary');
            Proteins a = result;
            print("MYNEW");
            print(a.toJson());
            ItemResponse itemResponse =calculateItemDetails(a.qty!,int.parse(a.calories));
            print(itemResponse.caloriesPerUnit);
            print(itemResponse.units);
            if (type == 1)
              BlocProvider.of<DiaryCubit>(context).dayDetailsResponse!.data!.proteins!.food!.add(dayDetails.Food(
                id: 9999,
              title: a.title,
              unit: itemResponse.units??a.qty,
              qty: 1.0,
              caloriePerUnit: double.parse(itemResponse.caloriesPerUnit??a.calories),
              color: 'F00000'

            ));
            if (type == 2) BlocProvider.of<DiaryCubit>(context).dayDetailsResponse!.data!.carbs!.food!.add(dayDetails.Food(
                id: 9999,
                title: a.title,
                unit: itemResponse.units??a.qty,
                qty: 1.0,
                caloriePerUnit: double.parse(itemResponse.caloriesPerUnit??a.calories),
                color: 'F00000'
            ));
            if (type == 3)
              BlocProvider.of<DiaryCubit>(context).dayDetailsResponse!.data!.fats!.food!.add(dayDetails.Food(
                id: 9999,
                title: a.title,
                unit: itemResponse.units??a.qty,
                qty: 1.0,
                caloriePerUnit: double.parse(itemResponse.caloriesPerUnit??a.calories),
                color: 'F00000'
            ));
            await ApiProvider().saveDairyLocally(BlocProvider.of<DiaryCubit>(context).dayDetailsResponse!,BlocProvider.of<DiaryCubit>(context).lastSelectedDate.value);

            await ApiProvider().saveMyOtherCaloriesLocally(diaryCubit.otherCaloriesResponse);
          }

          setState(() {});
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${Title}',
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.w800),
            ),
            Row(
              children: [
                SizedBox(width: 10),
                Icon(Icons.add_box, color: kColorPrimary, size: 30)
              ],
            ),
          ],
        ),
      ),
    );
  }

  ItemResponse calculateItemDetails(String qty, int calories) {
    String? caloriesPerUnit;
    String? units;

    // Splitting the qty string into quantity and unit
    List<String> qtyParts = qty.split(" ");
    if (qtyParts.length == 2) {
      String quantity = qtyParts[0];
      String unit = qtyParts[1];
      // Calculating calories per unit
      double quantityValue = double.tryParse(quantity) ?? 1.0;
      double caloriesPerUnitValue = calories / quantityValue;
      caloriesPerUnit = caloriesPerUnitValue.toStringAsFixed(2);
      units = unit;
    }

    return ItemResponse(caloriesPerUnit: caloriesPerUnit, units: units);
  }

  Widget staticBar() {
    return Container(
        color: Color(0xFF414042),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 3.1,
              child: Container(
                  padding: EdgeInsets.all(4),
                  child: Center(
                      child: kTextbody('Title',
                          color: Colors.white, bold: false, size: 16))),
            ),
            Container(width: 2, color: Color(0xFF414042), height: 25),
            Container(
                width: MediaQuery.of(context).size.width / 4,
                padding: EdgeInsets.all(4),
                child: kTextbody('Unit',
                    color: Colors.white, bold: false, size: 16)),
            Container(width: 2, color: Color(0xFF414042), height: 25),
            Container(
                width: MediaQuery.of(context).size.width / 4,
                padding: EdgeInsets.all(4),
                child: kTextbody('Calories',
                    color: Colors.white, bold: false, size: 16)),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              width: 2,
              color: Color(0xFF414042),
              height: 25,
            ),
            InkWell(
              onTap: () {
                // deleteItem(item.id!);
              },
              child: Icon(
                Icons.delete,
                color: Color(0xFF414042),
                size: 24,
              ),
            ),
            SizedBox(
              width: 4,
            ),
          ],
        ));
  }
}

class ItemResponse {
  final String? caloriesPerUnit;
  final String? units;

  ItemResponse({this.caloriesPerUnit, this.units});
}