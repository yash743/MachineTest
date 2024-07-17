import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String name;
  final String name1;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final TextInputType inputType;
  final double? height;
  final double? width;
  final int? length;
  final int color;
  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    this.controller,
    required this.name,
    required this.name1,
    this.prefixIcon,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    required this.inputType,
    required String hintText,
    this.height,
    this.width,
    this.length,
    this.suffixIcon,
    required this.color,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        enabled: true,
        controller: controller,
        textCapitalization: textCapitalization,
        maxLength: length,
        maxLines: 1,
        obscureText: obscureText,
        keyboardType: inputType,
        textAlign: TextAlign.start,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          isDense: true,
          labelText: name,
          hintText: name1,
          hintStyle: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500,fontSize:15),
          counterText: "",
          labelStyle: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          errorStyle: TextStyle(color: Colors.red, fontSize: 12),
        ),
        validator: validator,
      ),
    );
  }
}
