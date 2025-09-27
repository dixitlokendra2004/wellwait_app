import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final Color borderColor;
  final Color textFieldColor;
  final double borderRadius;
  final bool obscureText;
  final bool showPasswordToggle;
  final String? title;
  final double borderWidth;
  final Color? hintTextColor;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Color? iconColor;
  final double? iconSize;
  final Color? titleColor;
  final double titleFontSize;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged; // Added onChanged
  final EdgeInsets contentPadding;
  final int? maxLength;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.title,
    this.validator,
    this.borderColor = Colors.black,
    this.textFieldColor = Colors.white,
    this.borderRadius = 10.0,
    this.obscureText = false,
    this.showPasswordToggle = false,
    this.borderWidth = 2,
    this.hintTextColor,
    this.prefixIcon,
    this.suffixIcon,
    this.iconColor = Colors.grey,
    this.iconSize = 24,
    this.titleColor,
    this.titleFontSize = 16,
    this.onSubmitted,
    this.onChanged, // Initialize onChanged
    this.contentPadding = const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    this.maxLength,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Text(
            widget.title!,
            style: TextStyle(
              fontSize: widget.titleFontSize,
              fontWeight: FontWeight.w500,
              
              color: widget.titleColor ?? Colors.black,
            ),
          ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          obscureText: _isObscured,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            
          ),
          maxLength: widget.maxLength,
          onChanged: widget.onChanged, // Added onChanged callback
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontWeight: FontWeight.w300,
              
              color: widget.hintTextColor,
            ),
            filled: true,
            fillColor: widget.textFieldColor,
            contentPadding: widget.contentPadding,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: widget.borderColor, width: widget.borderWidth),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: widget.borderColor, width: widget.borderWidth),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: widget.borderColor, width: widget.borderWidth),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: Colors.red, width: widget.borderWidth),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: Colors.red, width: widget.borderWidth),
            ),
            prefixIcon: widget.prefixIcon != null
                ? Icon(
              widget.prefixIcon,
              color: widget.iconColor,
              size: widget.iconSize,
            )
                : null,
            suffixIcon: widget.showPasswordToggle
                ? SizedBox(
              width: widget.iconSize,
              child: IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility_off : Icons.visibility,
                  color: widget.iconColor ?? Colors.grey,
                  size: widget.iconSize,
                ),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              ),
            )
                : widget.suffixIcon != null
                ? Icon(
              widget.suffixIcon,
              color: widget.iconColor,
              size: widget.iconSize,
            )
                : null,
          ),
          validator: widget.validator,
          onFieldSubmitted: widget.onSubmitted,
        ),
      ],
    );
  }
}
