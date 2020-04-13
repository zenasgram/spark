import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  SignInButton({
    @required this.onPressed,
    @required this.imageName,
    @required this.buttonColour,
    @required this.textColour,
    @required this.signinText,
  });

  final Function onPressed;
  final String imageName;
  final Color buttonColour;
  final Color textColour;
  final String signinText;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: buttonColour,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      highlightElevation: 0,
//      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("images/$imageName.png"), height: 25.0),
            SizedBox(
              width: 25.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                signinText,
                style: TextStyle(
                  fontSize: 17,
                  color: textColour,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
