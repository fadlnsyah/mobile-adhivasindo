import 'package:flutter/material.dart';

import 'app_text_field.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    this.controller,
    this.hintText = 'Search',
    this.onChanged,
    this.readOnly = false,
    super.key,
  });

  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hintText: hintText,
      onChanged: onChanged,
      prefixIcon: Icons.search_rounded,
      readOnly: readOnly,
    );
  }
}
