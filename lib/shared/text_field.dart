import 'package:flutter/material.dart';

getTextField(TextEditingController controller, String text, bool obscureText,
    IconData? prefix, IconData? suffix, Function? onPressed) {
  return Column(
    children: [
      const SizedBox(
        height: 10,
      ),
      TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(10),
          )),
          hintText: text,
          prefixIcon: Icon(prefix),
          suffixIcon: onPressed != null
              ? IconButton(
                  onPressed: () => onPressed(),
                  icon: Icon(
                    obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                )
              : Icon(suffix),
        ),
      )
    ],
  );
}
