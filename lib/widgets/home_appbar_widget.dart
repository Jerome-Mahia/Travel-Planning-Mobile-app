import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String greeting() {
      var hour = DateTime.now().hour;
      if (hour < 12) {
        return 'morning';
      }
      if (hour < 17) {
        return 'afternoon';
      }
      return 'evening';
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good ${greeting()} 👋',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18.0,
                ),
              ),
              Text(
                'John Doe',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 19.0,
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 10.0,
              ),
              GestureDetector(
                onTap: () {},
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    "assets/images/joseph-gonzalez-iFgRcqHznqg-unsplash.jpg",
                    width: 45,
                    height: 45,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
