// Custom TextInputFormatter to enforce a max value
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class MaxValueInputFormatter extends TextInputFormatter {
  final int maxValue;

  MaxValueInputFormatter(this.maxValue);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Try to parse the input as an integer
    final int? enteredValue = int.tryParse(newValue.text);

    if (enteredValue != null && enteredValue > maxValue) {
      // If the entered value exceeds the max value, revert to the old value
      return oldValue;
    }

    // Otherwise, accept the new value
    return newValue;
  }
}