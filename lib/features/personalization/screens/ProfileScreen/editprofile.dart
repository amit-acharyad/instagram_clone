import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_clone/common/widgets/myappbar.dart';
import 'package:instagram_clone/features/personalization/controllers/usercontroller.dart';
import 'package:instagram_clone/features/personalization/screens/HomeScreen/widgets/posts/postuploader.dart';
import 'package:instagram_clone/localizations/app_localizations.dart';
import 'package:instagram_clone/utils/constants/sizes.dart';
import 'package:instagram_clone/utils/helpers/helper_functions.dart';

class EditProfile extends StatelessWidget {
  EditProfile({super.key});
  final UserController userController = UserController.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        showBackArrow: true,
        title: Text(
          AppLocalizations.of(context).editProfile,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceBtwItems),
          child: Column(
            children: [
              Center(
                child: PostUploader(size: 30,image: userController.user.value.photoUrl,),
              ),
              TextButton(
                child: const Text('Edit Picture',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold)),
                onPressed: () {
                  _showModalbottomSheer(context);
                },
              ),
              Form(
                  key: userController.editProfileKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: userController.nameController,
                          decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelText: "Name",
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppSizes.inputFieldRadius),
                                  borderSide: const BorderSide(color: Colors.blue))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: userController.usernameController,
                          decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelText: "Username",
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppSizes.inputFieldRadius),
                                  borderSide: const BorderSide(color: Colors.blue))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: userController.bioController,
                          decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelText: "Bio",
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppSizes.inputFieldRadius),
                                  borderSide: const BorderSide(color: Colors.blue))),
                        ),
                      ),
                      DropdownButtonFormField(
                          value: "Male",
                          items: ["Male", "Female", "Prefer Not to Say"]
                              .map((option) => DropdownMenuItem(
                                    value: option,
                                    child: Text(option),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            userController.updateUserGender(value!);
                          })
                    ],
                  ))
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
          width: 80,
          height: 60,
          child: ElevatedButton(
              onPressed: () {
                userController.updateUser();
              },
              child: const Text(
                "Save",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ))),
    );
  }

  _showModalbottomSheer(context) {
    showModalBottomSheet(
        context: context,
        builder: (context) => SizedBox(
              height: AppHelperFunctions.screenHeight(context) * 0.3,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(FontAwesomeIcons.image),
                    title: const Text("New Profile Picture"),
                    onTap: ()async {
                     await userController.uploadImage();
                    },
                  ),
                  const ListTile(
                    leading: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    title: Text(
                      "Remove current picture",
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                ],
              ),
            ));
  }
}
