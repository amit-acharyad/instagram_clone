import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/features/personalization/screens/HomeScreen/widgets/posts/postuploader.dart';

import '../../../../../../common/widgets/searchbar.dart';
import '../../../../../../localizations/app_localizations.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../profileimagewidget.dart';

Future<dynamic> showSharePost(BuildContext context) {
  return showModalBottomSheet(
    scrollControlDisabledMaxHeightRatio: 0.8,
    context: context,
    builder: (context) {
      final UserController userController = Get.put(UserController());
      return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spaceBtwItems),
            child: Column(
              children: [
                // AppSearchbar(),
                SizedBox(
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 8,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) => DmTile(checkBoxController: userController.users[index],))),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Obx(
          () {
            print(" in Obx ${userController.isAnySelected}");
            if (userController.isAnySelected) {
              return BottomAppBar(
                  height: 110,
                  elevation: AppSizes.cardElevation,
                  child: SizedBox(
                      height: 40,
                      child: ListView(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: Icon(FontAwesomeIcons.copy)),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(FontAwesomeIcons.share)),
                            IconButton(
                                onPressed: () {},
                                icon:
                                    Icon(FontAwesomeIcons.facebookMessenger)),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(FontAwesomeIcons.whatsapp)),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(FontAwesomeIcons.facebook)),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(FontAwesomeIcons.snapchat)),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(FontAwesomeIcons.xTwitter)),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(FontAwesomeIcons.message)),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(FontAwesomeIcons.threads)),
                          ])));
            } else {
              return BottomAppBar(
                height: 100,
                child: Column(
                  children: [
                    SizedBox(
                      height: 24,
                      width: double.maxFinite,
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            labelText:
                                AppLocalizations.of(context).writeAMessage,
                            floatingLabelBehavior:
                                FloatingLabelBehavior.never),
                      ),
                    ),
                    SizedBox(
                      height: AppSizes.spaceBtwItems / 2,
                    ),
                    SizedBox(
                      height: 40,
                      width: double.maxFinite,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          onPressed: () {},
                          child: Text(
                            AppLocalizations.of(context).send,
                            style: Theme.of(context).textTheme.bodyLarge,
                          )),
                    )
                  ],
                ),
              );
            }
          },
        ),
      );
    });
}

class CheckBoxController extends GetxController {
  RxBool checked = false.obs;
  static CheckBoxController get instance => Get.find();

  void toggleCheck() {
    checked.value = !checked.value;
  }
}

class UserController extends GetxController {
  var users = <CheckBoxController>[].obs;
  UserController() {
    users.addAll(List.generate(8,
        (index) => Get.put(CheckBoxController(), tag: UniqueKey().toString())));
  }
  bool get isAnySelected => users.any((controller) => controller.checked.value);
}

class DmTile extends StatelessWidget {
  DmTile({super.key, required this.checkBoxController});
  final CheckBoxController checkBoxController;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: PostUploader(image: '',size: 8,),
      title: Text('No Next Question(NNQ)'),
      subtitle: Text('nonextquestion'),
      trailing: Obx(
        () => Checkbox(
          value: checkBoxController.checked.value,
          onChanged: (value) => checkBoxController.toggleCheck(),
        ),
      ),
    );
  }
}