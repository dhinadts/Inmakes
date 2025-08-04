import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../components/BMCommonCardComponent.dart';
import '../components/BMFloatingActionComponent.dart';
import '../fragments/BMSearchFragment.dart';
import '../main.dart';
import '../models/BMCommonCardModel.dart';
import '../utils/BMColors.dart';
import '../utils/BMDataGenerator.dart';
import '../utils/BMWidgets.dart';

class BMTopOffersScreen extends StatefulWidget {
  const BMTopOffersScreen({Key? key}) : super(key: key);

  @override
  State<BMTopOffersScreen> createState() => _BMTopOffersScreenState();
}

class _BMTopOffersScreenState extends State<BMTopOffersScreen> {
  List<BMCommonCardModel> topOffersList = getSpecialOffersList();

  @override
  void initState() {
    setStatusBarColor(appStore.isDarkModeOn ? appStore.scaffoldBackground! : bmLightScaffoldBackgroundColor);
    super.initState();
  }

  @override
  void dispose() {
    setStatusBarColor(bmSpecialColor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.isDarkModeOn ? appStore.scaffoldBackground! : bmLightScaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: appStore.isDarkModeOn ? appStore.scaffoldBackground! : bmLightScaffoldBackgroundColor,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 30, color: bmPrimaryColor),
          onPressed: () {
            finish(context);
          },
        ),
        title: titleText(title: 'Top Offers'),
        actions: [
          IconButton(
            icon: Icon(Icons.search_sharp, size: 30, color: bmPrimaryColor),
            onPressed: () {
              BMSearchFragment().launch(context);
            },
          ),
          8.width,
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: topOffersList.map((e) {
            return BMCommonCardComponent(fullScreenComponent: true, element: e, isFavList: false).paddingSymmetric(vertical: 10);
          }).toList(),
        ).paddingOnly(top: 16, bottom: 70, left: 16, right: 16),
      ),
      floatingActionButton: BMFloatingActionComponent(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
