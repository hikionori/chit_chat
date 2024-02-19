import 'dart:io';

import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.inputType});

  final TextEditingController controller;
  final String hintText;
  final TextInputType inputType;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (Platform.isAndroid || Platform.isIOS) {
        return Container(
          width: 360,
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(
              width: 3,
              color: Theme.of(context).colorScheme.secondary,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 16),
            child: Center(
              child: TextField(
                keyboardType: inputType,
                controller: controller,
                style: Theme.of(context).textTheme.labelLarge,
                decoration: InputDecoration.collapsed(
                  hintText: hintText,
                  hintStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            ),
          ),
        );
      } else {
        return Container(
          width: 400,
          height: 60,
          decoration: BoxDecoration(
              border: Border.all(width: 3),
              borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 16),
            child: Center(
              child: TextField(
                keyboardType: inputType,
                controller: controller,
                style: Theme.of(context).textTheme.labelLarge,
                decoration: InputDecoration.collapsed(
                  hintText: hintText,
                  hintStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            ),
          ),
        );
      }
    });
  }
}
