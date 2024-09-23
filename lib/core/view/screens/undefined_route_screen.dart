import 'package:flutter/material.dart';

import '../../../config/localization/l10n/l10n.dart';
import '../../resources/app_strings.dart';
import '../../resources/font_manager.dart';
import '../widgets/custom_text.dart';
import '../widgets/status_bar.dart';

class UndefinedRouteScreen extends StatelessWidget {
  const UndefinedRouteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatusBar(
      child: Scaffold(
        body: Center(
          child: CustomText(L10n.tr(context).noRouteFound, fontSize: FontSize.s20, fontWeight: FontWeightManager.bold),
        ),
      ),
    );
  }
}
