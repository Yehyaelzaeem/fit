import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../config/localization/l10n/l10n.dart';
import '../../resources/resources.dart';

class CustomTextFieldNoShadow extends StatelessWidget {
  final bool isRequired;
  final String? label;
  final Widget? customLabelIcon;
  final String? hintText;
  final Widget? prefix;
  final Widget? suffix;
  final bool readOnly;
  final bool obscureText;
  final bool? enabled;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final String? initialValue;
  final TextInputType? keyBoardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(String?)? onSaved;
  final void Function(String)? onSubmitted;
  final TextEditingController? controller;
  final List<TextInputFormatter>? formatters;
  final AutovalidateMode? autoValidateMode;
  final TextInputAction? textInputAction;
  final Color? fillColor;

  const CustomTextFieldNoShadow({
    this.isRequired = false,
    this.hintText,
    this.label,
    this.customLabelIcon,
    this.prefix,
    this.suffix,
    this.validator,
    this.readOnly = false,
    this.obscureText = false,
    this.keyBoardType,
    this.controller,
    this.enabled,
    this.formatters,
    this.onChanged,
    this.onTap,
    this.onSaved,
    this.onSubmitted,
    this.textInputAction,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.initialValue,
    this.autoValidateMode,
    this.fillColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: autoValidateMode,
      cursorColor: AppColors.primary,
      textCapitalization: TextCapitalization.sentences,
      obscureText: obscureText,
      readOnly: readOnly,
      validator: validator,
      controller: controller,
      inputFormatters: formatters,
      onChanged: onChanged,
      onTap: onTap,
      onSaved: onSaved,
      maxLength: maxLength,
      onFieldSubmitted: onSubmitted,
      initialValue: initialValue,
      keyboardType: keyBoardType,
      maxLines: maxLines ?? 1,
      minLines: minLines ?? 1,
      enabled: enabled,
      textInputAction: textInputAction,
      style: TextStyle(
        color: AppColors.black,
        fontFamily: L10n.isAr(context) ? FontConstants.arabicFontFamily : FontConstants.englishFontFamily,
        fontSize: FontSize.s14,
        fontWeight: FontWeightManager.medium,
        height: AppSize.s1_5,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppColors.grey,
          fontFamily: L10n.isAr(context) ? FontConstants.arabicFontFamily : FontConstants.englishFontFamily,
          fontSize: FontSize.s12,
          fontWeight: FontWeightManager.regular,
          height: AppSize.s1_5,
        ),
        isDense: true,
        filled: true,
        fillColor: fillColor ?? AppColors.white,
        prefixIcon: prefix != null
            ? Padding(
                padding: const EdgeInsetsDirectional.only(start: AppPadding.p12, end: AppPadding.p4),
                child: prefix,
              )
            : null,
        prefixIconConstraints: const BoxConstraints(minWidth: AppSize.s0, minHeight: AppSize.s0),
        suffixIcon: suffix != null ? Padding(padding: const EdgeInsets.all(AppPadding.p12), child: suffix) : null,
        suffixIconConstraints: const BoxConstraints(minWidth: AppSize.s0, minHeight: AppSize.s0),
        border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(AppSize.s8)),
        disabledBorder:
            OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(AppSize.s8)),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(AppSize.s8)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(AppSize.s8)),
        focusedErrorBorder:
            OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(AppSize.s8)),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.red),
          borderRadius: BorderRadius.circular(AppSize.s8),
        ),
      ),
    );
  }
}
