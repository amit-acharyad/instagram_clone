import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/features/personalization/controllers/messagecontroller.dart';
import 'package:instagram_clone/features/personalization/controllers/usercontroller.dart';
import 'package:instagram_clone/features/personalization/data/repositories/userrepository.dart';
import 'package:instagram_clone/features/personalization/screens/navigationscreen.dart';
import 'package:instagram_clone/localizations/app_localizations.dart';
import 'package:instagram_clone/features/personalization/screens/HomeScreen/widgets/story/stories.dart';
import 'package:instagram_clone/utils/helpers/helper_functions.dart';

import '../../../../utils/constants/sizes.dart';
import 'message_tile.dart';

class MessageScreen extends StatelessWidget {
  MessageScreen({super.key});
  final MessageController messageController = Get.put(MessageController());

  @override
  Widget build(BuildContext context) {
    final isDark = AppHelperFunctions.isDarkMode(context);
    final Color color = isDark ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.to(const NavigationBarScreen());
            },
            icon: Icon(
              Icons.arrow_back,
              color: color,
            )),
        title: Text(
          "${UserController.instance.user.value.userName} ",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceBtwItems),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppSearchbar(),
              const SizedBox(
                height: AppSizes.spaceBtwItems,
              ),
              Stories(),
              const SizedBox(
                height: AppSizes.spaceBtwItems,
              ),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context).messages,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const Spacer(),
                  Text(
                    AppLocalizations.of(context).requests,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: Colors.blue),
                  ),
                ],
              ),
              StreamBuilder(
                  stream: messageController.getMessageFriends(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Text("Error");
                    }
                    if (!snapshot.hasData) {
                      return const Text("No data");
                    }

                    final dataSet = snapshot.data!.toSet();
                    return SizedBox(
                      width: AppHelperFunctions.screenWidth(context),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: dataSet.length,
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: ((context, index) {
                            final userList = dataSet.toList();
                            final user = userList[index];
                            print(
                                "user id od current chatting friend is $user");
                            return FutureBuilder(
                                future: UserRepository.instance
                                    .fetchUserWithGivenId(user),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Text("No data");
                                  }
                                  if (snapshot.hasError) {
                                    return const Text("Error");
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }
                                  final user = snapshot.data;
                                  print("user name is ${user!.name}");
                                  return StreamBuilder(
                                      stream: messageController
                                          .getMessagesFromUser(user.id),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return const Text("No data");
                                        }
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Text("Loading");
                                        }
                                        if (snapshot.hasError) {
                                          return const Text("error");
                                        }
                                        final latestMessage =
                                            snapshot.data!.last;
                                        return MessageTile(
                                          user: user,
                                          message: latestMessage,
                                        );
                                      });
                                });
                          })),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
