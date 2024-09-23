import 'package:flutter/material.dart';

import '../../resources/resources.dart';
import '../views.dart';

class CustomDropDownField<T> extends StatelessWidget {
  final String? hintText;
  final String? label;
  final List<DropdownMenuItem<T>>? items;
  final void Function(T?)? onChanged;
  final void Function()? onTap;
  final String? Function(T?)? validator;
  final Widget? prefix;
  final Widget? suffix;
  final T? value;
  final TextInputType? keyBoardType;
  final AutovalidateMode? autoValidateMode;
  final double iconSize;
  final bool isLoadingValues;

  const CustomDropDownField({
    this.hintText,
    this.onChanged,
    this.label,
    this.onTap,
    this.items,
    this.prefix,
    this.suffix,
    this.validator,
    this.keyBoardType,
    this.value,
    this.autoValidateMode,
    this.iconSize = AppSize.s24,
    this.isLoadingValues = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      items: isLoadingValues ? null : items,
      onChanged: onChanged,
      validator: validator,
      value: isLoadingValues ? null : value,
      onTap: onTap,
      icon: isLoadingValues
          ? const SizedBox(
              height: AppSize.s16,
              width: AppSize.s16,
              child: CircularProgressIndicator(strokeWidth: AppSize.s1_5),
            )
          : const CustomIcon(Icons.keyboard_arrow_down_sharp),
      iconSize: iconSize,
      elevation: AppSize.s0.toInt(),
      hint: hintText != null ? CustomText(hintText!,height: AppSize.s1) : null,
      isDense: true,
      isExpanded: true,
      autovalidateMode: autoValidateMode,
      dropdownColor: AppColors.lightGrey,
      decoration: InputDecoration(
        fillColor: AppColors.white,
        filled: true,
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppPadding.p8),
        prefixIcon: prefix != null
            ? Padding(
                padding: const EdgeInsetsDirectional.only(start: AppPadding.p12, end: AppPadding.p4),
                child: prefix,
              )
            : null,
        prefixIconConstraints: const BoxConstraints(minWidth: AppSize.s0, minHeight: AppSize.s0),
        suffixIcon: suffix != null ? Padding(padding: const EdgeInsets.all(AppPadding.p12), child: suffix) : null,
        suffixIconConstraints: const BoxConstraints(minWidth: AppSize.s0, minHeight: AppSize.s0),
        border: MyInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(AppSize.s12)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.grey.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(AppSize.s4),
        ),
        focusedBorder: MyInputBorder(
          borderSide: BorderSide(color: AppColors.grey.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(AppSize.s4),
        ),
        focusedErrorBorder: MyInputBorder(
          borderSide: const BorderSide(color: AppColors.red),
          borderRadius: BorderRadius.circular(AppSize.s4),
        ),
        errorBorder: MyInputBorder(
          borderSide: const BorderSide(color: AppColors.red),
          borderRadius: BorderRadius.circular(AppSize.s4),
        ),
      ),
    );
  }
}
