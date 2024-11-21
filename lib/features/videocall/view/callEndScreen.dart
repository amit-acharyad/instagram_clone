import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/features/profile/controller/usercontroller.dart';

import '../../authentication/data/authenticationrepository.dart';
import '../../home/homescreen.dart';



class CallEndScreen extends StatelessWidget {
  const CallEndScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () {
                    Get.to(HomeScreen());
                  },
                  icon: Icon(Icons.cancel_outlined)),
            ),
            SizedBox(height: 150,),
            CircleAvatar(
              radius: 36,
              backgroundImage: NetworkImage(UserController
                  .instance.user.value.photoUrl),
            ),
            SizedBox(height: 24,),
            Text("Call Ended."),
            Spacer()
          ],
        ),
      ),
    ));
  }
}
