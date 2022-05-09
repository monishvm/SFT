import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

Column columnOfHeadingInputField({
  required String title,
  required String hint,
  required String suffix,
  bool isname = false,
  Function(String)? onChanged,
  TextEditingController? controller,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: GoogleFonts.openSans(
          fontSize: 17,
          color: Colors.grey.shade900,
        ),
      ),
      SizedBox(height: 5),
      CustomInputField(
        hint: 'eg: ' + hint,
        suffix: suffix,
        isString: isname,
        onChanged: onChanged,
        controller: controller,
      ),
    ],
  );
}

class CustomInputField extends StatelessWidget {
  const CustomInputField({
    Key? key,
    this.onChanged,
    required this.hint,
    required this.suffix,
    required this.isString,
    this.controller,
  }) : super(key: key);

  final Function(String)? onChanged;
  final String hint;
  final String suffix;
  final bool isString;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: GoogleFonts.openSans(
        fontSize: 16,
        color: Colors.grey.shade900,
      ),
      onChanged: onChanged,
      textCapitalization: TextCapitalization.words,
      inputFormatters: !isString
          ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
          : [],
      keyboardType: isString ? TextInputType.text : TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        hintText: hint,
        hintStyle: GoogleFonts.openSans(
          fontSize: 15,
          color: Colors.grey.shade500,
          fontWeight: FontWeight.bold,
        ),
        suffixText: suffix,
        suffixStyle: GoogleFonts.openSans(
          fontSize: 15,
          color: Colors.grey.shade800,
          fontWeight: FontWeight.bold,
        ),
        filled: true,
        fillColor: Colors.grey.shade200,
      ),
    );
  }
}
