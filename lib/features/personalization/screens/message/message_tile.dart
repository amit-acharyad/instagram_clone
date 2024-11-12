import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/common/styles/dateTimeformatter.dart';
import 'package:instagram_clone/data/models/messageModel.dart';
import 'package:instagram_clone/features/authentication/data/authenticationrepository.dart';
import 'package:instagram_clone/features/personalization/controllers/messagecontroller.dart';
import 'package:instagram_clone/features/personalization/data/models/usermodel.dart';
import 'package:instagram_clone/features/personalization/screens/HomeScreen/widgets/posts/postuploader.dart';
import 'package:instagram_clone/features/personalization/screens/HomeScreen/widgets/profileimagewidget.dart';
import 'package:instagram_clone/utils/constants/colors.dart';
import 'package:instagram_clone/utils/constants/enums.dart';

import 'chatscreen.dart';

class MessageTile extends StatelessWidget {
  MessageTile({super.key, required this.user, required this.message});
  final UserModel? user;
  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    print("received user is ${user!.name}");
    return ListTile(
        leading: PostUploader(
          size: 10,
          image: user!.photoUrl,
        ),
        title: Text(
          user!.name,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        subtitle: Row(
          children: [
            Flexible(
                flex: 8,
                child: Text(
                  message.message,
                  overflow: TextOverflow.ellipsis,
                  style: message.seen ||
                          message.senderId ==
                              AuthenticationRepository.instance.authUser!.uid
                      ? Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: AppColors.darkerGrey)
                      : Theme.of(context).textTheme.titleSmall,
                )),
            Spacer(),
            Flexible(
                flex: 2,
                child: Text(
                  formatTimeDifference(message.timeStamp.toDate()),
                  overflow: TextOverflow.ellipsis,
                  style: message.seen ||
                          message.senderId ==
                              AuthenticationRepository.instance.authUser!.uid
                      ? Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: AppColors.darkerGrey)
                      : Theme.of(context).textTheme.titleSmall,
                )),
          ],
        ),
        trailing:
            IconButton(onPressed: () {}, icon: Icon(Icons.camera_alt_outlined)),
        onTap: () {
          if ((message.receiverId ==
              AuthenticationRepository.instance.authUser!.uid)) {
            MessageController.instance.updateSeen(message.messageId);
          }
          Get.to(ChatScreen(user: user));
        });
  }
}
