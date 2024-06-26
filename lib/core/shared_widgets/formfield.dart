import 'package:flutter/material.dart';

class CSFFormField extends StatefulWidget {
  final String hintText;
  final Function onChanged;
  final bool obscureText;
  final TextEditingController controller;
  final Key? formkey;
  String? fieldName;


  CSFFormField({
    Key? key,
    required this.hintText,
    required this.onChanged,
    required this.obscureText,
    required this.controller,
    this.formkey,
    this.fieldName,
  }) : super(key: key);

  @override
  _CSFFormFieldState createState() => _CSFFormFieldState();
}

class _CSFFormFieldState extends State<CSFFormField> {
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return FormField(
      builder: (FormFieldState state) {
        return TextField(
          obscureText: widget.obscureText,
          key: widget.formkey,
          controller: widget.controller,
          decoration: InputDecoration(
            hintStyle: const TextStyle(color: Colors.black26),
            hintText: widget.hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            errorText: errorText,
          ),
          onChanged: (value) {
            setState(() {
              // Reset error message only if widget.fieldName is not null
              if (widget.fieldName != null) {
                errorText = null;
              }
            });
            widget.onChanged(value);
          },
        );
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          setState(() {
            // Set error message only if widget.fieldName is not null
            if (widget.fieldName != null) {
              errorText = 'This ${widget.fieldName} field is required';
            }
          });
          return 'This ${widget.fieldName} field is required'; // Return error message
        } else {
          setState(() {
            errorText = null; // Reset error message
          });
        }
        return null; // Return null to indicate no error
      },
    );
  }
}