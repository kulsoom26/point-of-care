import 'package:flutter/material.dart';

class myButton extends StatelessWidget {
  myButton(this.text, this.login);
  String text;
  Function login;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        login();
      },
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
      child: Ink(
        decoration: BoxDecoration(
            gradient: const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFFB9A0E6),
                  Color(0xFF8587DC),
                ]),
            borderRadius: BorderRadius.circular(50)),
        child: Container(
          width: 150,
          height: 50,
          alignment: Alignment.center,
          child: Row(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 16, top: 18, left: 30, right: 10),
              child: Text(
                text,
                style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'League Spartan',
                    fontWeight: FontWeight.w400),
              ),
            ),
            const Image(image: AssetImage('assets/images/right-arrow.png')),
          ]),
        ),
      ),
    );
  }
}

class myButton1 extends StatelessWidget {
  final onTap;
  final title;
  const myButton1(this.onTap, this.title);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFFB9A0E6),
              Color(0xFF8587DC),
            ],
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Container(
          height: 55,
          width: 400,
          alignment: Alignment.center,
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
