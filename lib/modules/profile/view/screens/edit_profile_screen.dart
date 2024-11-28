import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/localization/l10n/l10n.dart';
import '../../../../config/navigation/navigation_services.dart';
import '../../../../config/navigation/routes.dart';
import '../../../../core/database/shared_pref.dart';
import '../../../../core/enums/http_request_state.dart';
import '../../../../core/resources/resources.dart';
import '../../../../core/utils/alerts.dart';
import '../../../../core/utils/globals.dart';
import '../../../../core/view/components/confirmation_dialog.dart';
import '../../../../core/view/views.dart';
import '../../../auth/cubit/auth_cubit/auth_cubit.dart';
import '../../cubits/profile_cubit.dart';
import '../../models/requests/update_profile_body.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final ProfileCubit profileCubit;
  final UpdateProfileBody updateProfileBody = UpdateProfileBody();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileCubit = BlocProvider.of<ProfileCubit>(context);
    updateProfileBody.copyWith(
      name: currentUser?.data!.name,
      phone: currentUser?.data!.phone,
      email: currentUser?.data!.email,
    );

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppbar(title: 'Edit profile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.p16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p8, vertical: AppPadding.p16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSize.s8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(L10n.tr(context).fullName, color: AppColors.grey),
                  TextFormField(initialValue: currentUser!.data!.name,
                    onChanged: (value) => updateProfileBody.copyWith(name: value),
                  ),
                ],
              ),
            ),
            const VerticalSpace(AppSize.s16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p8, vertical: AppPadding.p16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSize.s8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(L10n.tr(context).email, color: AppColors.grey),
                  TextFormField(initialValue: currentUser!.data!.email,
                      onChanged: (value) => updateProfileBody.copyWith(email: value),
    ),
                ],
              ),
            ),
            const VerticalSpace(AppSize.s16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p8, vertical: AppPadding.p16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSize.s8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(L10n.tr(context).phoneNumber, color: AppColors.grey),
                  TextFormField(initialValue: currentUser!.data!.phone,
                    onChanged: (value) => updateProfileBody.copyWith(phone: value),
                  ),
                ],
              ),
            ),
            const VerticalSpace(AppSize.s16),
            BlocConsumer<ProfileCubit, ProfileState>(
              listenWhen: (prevState, state) => state.profileRequestType == ProfileRequestType.updateProfile,
              listener: (context, state) {
                if (state.httpRequestState == HttpRequestState.failure) {
                  Alerts.showToast(state.failure!.message);
                }
                if (state.httpRequestState == HttpRequestState.success) {
                  Alerts.showToast('Your Account has been updated Successfully');

                }
              },
              buildWhen: (prevState, state) => state.profileRequestType == ProfileRequestType.updateProfile,
              builder: (context, state) => state.httpRequestState == HttpRequestState.loading
                  ? const LoadingSpinner(color: AppColors.primary)
                  : CustomButton(text: L10n.tr(context).save, onPressed: () => profileCubit.updateProfile(updateProfileBody)),
            ),
            const VerticalSpace(AppSize.s32),



            BlocListener<ProfileCubit, ProfileState>(
              listenWhen: (prevState, state) => state.profileRequestType == ProfileRequestType.deleteAccount,
              listener: (context, state) {
                if (state.httpRequestState == HttpRequestState.success ) {
                  Alerts.showToast(state.message!);
                  if(state.profileRequestType == ProfileRequestType.deleteAccount) {
                    BlocProvider.of<AuthCubit>(context).clearCache();
                    NavigationService.pushReplacementAll(
                        context, Routes.splashScreen);
                  }
                }
                if (state.httpRequestState == HttpRequestState.failure) {
                  NavigationService.goBack(context);
                  Alerts.showSnackBar(context, state.failure!.message);
                }
              },
              child: InkWell(
                  onTap: (){
                    showDialog(
                      context: context,
                      builder: (context) => ConfirmationDialog(
                        title: 'هل أنت متأكد من حذف الحساب؟',
                        // title: L10n.tr(context).areYouSure,
                        onConfirm: () {
                          profileCubit.deleteAccount();
                          YemenyPrefs prefs = YemenyPrefs();
                          prefs.logout();
                          NavigationService.pushReplacementAll(context, Routes.authScreen);
                        },
                      ),
                    );
                  },
                  child: CustomText('حذف الحساب',color: AppColors.primary,)),
            )
          ],
        ),
      ),
    );
  }
}
