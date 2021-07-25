import 'package:app/app/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

bool obscurePassword = true;

class EditTextPassword extends StatefulWidget {
  final String? suffixText;
  final String hint;
  final String value;
  final bool enable;
  final bool label;
  final bool autoValidate;
  final int lines;
  final Function? updateFunc;
  final Function? validateFunc;
  final IconData? iconData;
  final double fontSize;

  EditTextPassword({
    this.iconData,
    required this.value,
    required this.hint,
    this.autoValidate = false,
    this.enable = true,
    this.label = false,
    this.lines = 1,
    this.fontSize = 14,
    this.updateFunc,
    this.validateFunc,
    this.suffixText,
  });

  @override
  _EditTextState createState() => _EditTextState();
}

class _EditTextState extends State<EditTextPassword> {
  void changePasswordVisibility() {
    setState(() {
      obscurePassword = !obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      child: TextFormField(
        obscureText: obscurePassword,
        autovalidateMode: widget.autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
        initialValue: widget.value,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(64),
              borderSide: BorderSide(color: Colors.grey, width: 1.5),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(64),
              borderSide: BorderSide(color: Colors.grey, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(64),
              borderSide: BorderSide(color: kColorPrimary, width: 2),
            ),
            errorStyle: TextStyle(fontSize: 10),
            labelStyle: TextStyle(fontSize: widget.fontSize,color: kColorAccent),
            hintStyle: TextStyle(fontSize: widget.fontSize, color: Colors.black, fontWeight: FontWeight.w300),
            labelText: widget.hint,
            hintText: widget.hint,
            counterStyle: TextStyle(color: Colors.green),
            suffixIcon: GestureDetector(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  obscurePassword ? Icons.remove_red_eye : Icons.security,
                  color: Colors.grey,
                ),
              ),
              onTap: changePasswordVisibility,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0)),
        validator: (text) {
          if (widget.validateFunc != null) return widget.validateFunc!(text);
          return null;
        },
        enabled: widget.enable,
        maxLines: widget.lines,
        onChanged: (newValue) {
          if (widget.updateFunc != null) return widget.updateFunc!(newValue);
          return null;
        },
        onSaved: (newValue) {
          if (widget.updateFunc != null) return widget.updateFunc!(newValue);
          return null;
        },
      ),
    );
  }
}
