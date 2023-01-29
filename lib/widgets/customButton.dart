import 'package:flutter/material.dart';

Widget CustomButton(
    {required String title,
    required IconData i,
    required VoidCallback onCLick}) {
  return Container(
    width: 200,
    child: ElevatedButton(
        onPressed: onCLick,
        child: Row(
          children: <Widget>[
            Icon(i),
            const SizedBox(
              width: 5,
            ),
            Text(title),
          ],
        )),
  );
}
