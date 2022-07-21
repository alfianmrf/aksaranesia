import 'package:flutter/material.dart';

Color primary = Color(0xff106A8D);
Color secondary = Color(0xff2196F3);
Color accent = Color(0xFF9DC9EC);

class Input extends StatelessWidget {
  Input({
    this.controller,
    this.hintText,
    this.icon,
    this.secure = false,
    this.maxLength = 20000
  });

  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final bool secure;
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: secure,
      maxLength: maxLength,
      style: TextStyle(fontSize: 14),
      decoration: InputDecoration(
          filled: true,
          counterText: "",
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14,
            color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor.withOpacity(0.5),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(vertical:10, horizontal: 15),
            child: Icon(icon, color: secondary),
          ),
          disabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.transparent)
          ),
          enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.transparent)
          ),
          focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.transparent)
          ),
          errorBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.transparent)
          ),
          focusedErrorBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.transparent)
          )
      ),
    );
  }
}

class InputChanged extends StatelessWidget {
  InputChanged({
    this.controller,
    this.hintText,
    this.icon,
    this.changed,
    this.secure = false,
    this.maxLength = 20000,
    this.suffixIcon,
    this.color,
  });

  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final bool secure;
  final int maxLength;
  final void Function(String) changed;
  final Widget suffixIcon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 5,
      onChanged: changed,
      controller: controller,
      obscureText: secure,
      maxLength: maxLength,
      style: TextStyle(fontSize: 14),
      decoration: InputDecoration(
        filled: true,
        counterText: "",
        fillColor: color,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14,
          color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor.withOpacity(0.5),
        ),
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.all(15),
        prefixIcon: icon == null ? null : Padding(
          padding: EdgeInsets.symmetric(vertical:10, horizontal: 15),
          child: Icon(icon, color: secondary),
        ),
        disabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.transparent)
        ),
        enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.transparent)
        ),
        focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.transparent)
        ),
        errorBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.transparent)
        ),
        focusedErrorBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.transparent)
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  Button({this.color, this.text, this.onPressed});
  final Color color;
  final String text;
  final void Function() onPressed;
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            elevation: MaterialStateProperty.all<double>(0),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed))
                    return color;
                  else if (states.contains(MaterialState.disabled))
                    return color.withOpacity(0.3);
                  return color; // Use the component's default.
                }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                )
            )
        ),
        onPressed: onPressed,
        child: Center(
            heightFactor: 2.5,
            child: Text(text)
        )
    );
  }
}

class Select extends StatelessWidget {
  Select({this.onChanged, this.items, this.currentSelectedValue, this.icon, this.text});
  final String currentSelectedValue, text;
  final IconData icon;
  final List<Map<String, dynamic>> items;
  final void Function(String) onChanged;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FormField<String>(
        builder: (FormFieldState<String> state) {
          return InputDecorator(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: Text(text),
                value: currentSelectedValue,
                isDense: true,
                onChanged: onChanged,
                items: items.map((Map<String, dynamic> value) {
                  return DropdownMenuItem<String>(
                    value: value["value"].toString(),
                    child: Text(value["label"].toString()),
                  );
                }).toList(),
              ),
            ),
            decoration: InputDecoration(
                filled: true,
                counterText: "",
                fillColor: Colors.lightBlue.withOpacity(0.1),
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor.withOpacity(0.5),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical:10, horizontal: 15), // add padding to adjust icon
                  child: Icon(icon, color: Colors.blue),
                ),
                disabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.transparent)
                ),
                enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.transparent)
                ),
                focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.transparent)
                ),
                errorBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.transparent)
                ),
                focusedErrorBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.transparent)
                )
            ),
          );
        },
      ),
    );
  }
}