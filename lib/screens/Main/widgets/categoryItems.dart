import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final image;
  final label;
  final color;
  final onTap;
  CategoryItem(this.image, this.label, this.color, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.only(left: 20, top: 20),
        height: 120,
        width: 150,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              image!,
              width: 40,
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              label,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: "League Spartan"),
            )
          ],
        ),
      ),
    );
  }
}
