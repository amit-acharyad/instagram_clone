import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instagram_clone/common/widgets/myappbar.dart';
import 'package:instagram_clone/features/personalization/controllers/postcontroller.dart';
import 'package:instagram_clone/utils/constants/enums.dart';
import 'package:instagram_clone/utils/constants/sizes.dart';

class AddPost extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        showBackArrow: true,
        actions: [
          IconButton(
              onPressed: () async {
                print("Pressed Post");
                await Postcontroller.instance.post();
              },
              icon: Text(
                "POST",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.blue),
              ))
        ],
        title: Text(
          "Create Post",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceBtwItems),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 500,
                width: 400,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image:
                            FileImage(File(Postcontroller.instance.image[0]!.path)),
                        fit: BoxFit.contain)),
              ),
              SizedBox(
                height: AppSizes.spaceBtwItems,
              ),
              Text(
                "Caption",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextFormField(
                controller: Postcontroller.instance.captionController,
                maxLines: 2,
                maxLength: 50,
                decoration: InputDecoration(
                    labelText: "Your Caption Here",
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1))),
              )
            ],
          ),
        ),
      )),
    );
  }
}
