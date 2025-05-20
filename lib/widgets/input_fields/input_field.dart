import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:on_the_spot/theme/app_colors.dart';
import 'package:on_the_spot/widgets/text/body_text.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength; 

  const InputField({
    required this.controller,
    required this.hintText,
    this.labelText,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.maxLength, 
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double inputWidth = constraints.maxWidth;
        double inputHeight = inputWidth * 0.2;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (labelText != null && labelText!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: BodyText(
                  text: labelText!,
                ),
              ),
            SizedBox(
              width: inputWidth,
              height: inputHeight,
              child: TextField(
                controller: controller,
                keyboardType: keyboardType,
                inputFormatters: inputFormatters,
                maxLength: maxLength, 
                autofocus: true,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    fontSize: 32,
                    color: AppColors.lightGrey,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  counterText: '', // Hide the default counter text
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}