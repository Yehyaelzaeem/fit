import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../resources/resources.dart';
import '../views.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
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
  final FocusNode? focusNode;

  const CustomTextField({
    this.hintText,
    this.label,
    this.prefix,
    this.suffix,
    this.validator,
    this.readOnly = false,
    this.obscureText = false,
    this.keyBoardType,
    this.controller,
    this.enabled,
    this.formatters,
    this.focusNode,
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
      focusNode: focusNode,
      onSaved: onSaved,
      maxLength: maxLength,
      onFieldSubmitted: onSubmitted,
      initialValue: initialValue,
      keyboardType: keyBoardType,
      maxLines: maxLines ?? 1,
      minLines: minLines ?? 1,
      enabled: enabled,
      textInputAction: textInputAction,
      style: const TextStyle(
        color: AppColors.black,
        // fontFamily: L10n.isAr(context) ? FontConstants.arabicFontFamily : FontConstants.englishFontFamily,
        fontFamily: FontConstants.arabicFontFamily,
        fontSize: FontSize.s14,
        fontWeight: FontWeightManager.medium,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.white,
        isDense: true,
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: FontSize.s12, color: AppColors.grey),
        labelText: label,
        prefixIcon: prefix != null
            ? Padding(
                padding: const EdgeInsetsDirectional.only(start: AppPadding.p12, end: AppPadding.p4),
                child: prefix,
              )
            : null,
        prefixIconConstraints: const BoxConstraints(minWidth: AppSize.s0, minHeight: AppSize.s0),
        suffixIcon: suffix != null ? Padding(padding: const EdgeInsets.all(AppPadding.p12), child: suffix) : null,
        suffixIconConstraints: const BoxConstraints(minWidth: AppSize.s0, minHeight: AppSize.s0),
        border: MyInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(AppSize.s8)),
        enabledBorder: MyInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(AppSize.s8)),
        focusedBorder: MyInputBorder(
          borderSide: const BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.circular(AppSize.s8),
        ),
        focusedErrorBorder: MyInputBorder(
          borderSide: const BorderSide(color: AppColors.red),
          borderRadius: BorderRadius.circular(AppSize.s8),
        ),
        errorBorder: MyInputBorder(
          borderSide: const BorderSide(color: AppColors.red),
          borderRadius: BorderRadius.circular(AppSize.s8),
        ),
      ),
    );
  }
}
