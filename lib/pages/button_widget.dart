import 'package:flutter/material.dart';

class ButtonHeaderWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonHeaderWidget({
    Key? key,
    required this.text,
    required this.onClicked, required TextEditingController controller,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) => HeaderWidget(
    child: ButtonWidget(
      text: text,
      onClicked: onClicked,
    ),
  );
}

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
  style: ElevatedButton.styleFrom(
  onPrimary: Colors.black87,
  primary: Colors.grey[100],
  minimumSize: Size(95, 55),
  padding: EdgeInsets.symmetric(horizontal: 130),
    shape:new RoundedRectangleBorder(
      borderRadius: new BorderRadius.circular(88.28),
  side: BorderSide(
  color: Colors.grey,
  width: 1.0,
    ),

  ),
  ),

    child: FittedBox(
      child: Text(
        text,
        style: TextStyle(fontSize: 20, color: Colors.black),
      ),
    ),
    onPressed: onClicked,
  );
}

class HeaderWidget extends StatelessWidget {

  final Widget child;

  const HeaderWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      child,
    ],
  );
}