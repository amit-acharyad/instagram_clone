import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/features/authentication/data/authenticationrepository.dart';
import 'package:instagram_clone/features/profile/data/model/usermodel.dart';
import 'package:instagram_clone/features/posts/view/posts/postuploader.dart';
import 'package:instagram_clone/features/message/view/widgets/videocall.dart';
import 'package:instagram_clone/features/message/view/widgets/webRTCVideoCall.dart';
import 'package:instagram_clone/features/message/view/widgets/webrtcVideoScreen.dart';
import 'package:instagram_clone/utils/constants/colors.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../videocall/model/videocallModel.dart';
import '../../../videocall/view/webRTCVideoCallScreen.dart';
import '../../controller/messagecontroller.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key, required this.user});
  final UserModel? user;
  final MessageController messageController = Get.put(MessageController());
  final TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print("Reveived user is ${user!.id} with name ${user!.name}");
    final bool isDark = AppHelperFunctions.isDarkMode(context);

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              )),
          title: Row(
            children: [
              PostUploader(size: 15, image: user!.photoUrl),
              Text(
                user!.name,
                style: Theme.of(context).textTheme.titleMedium,
              )
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(WebRTCVideoCallScreen(receiverId: user!.id,roomId: '1',));
                },
                icon: const Icon(Icons.call)),
            IconButton(
                onPressed: () {
                  Get.to(const VideoCall());
                },
                icon: const Icon(Icons.video_call_rounded))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppSizes.defaultSpace),
          child: StreamBuilder(
              stream: messageController.getMessagesFromUser(user!.id),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error.toString());
                  return Text("Error ${snapshot.error.toString()}");
                }
                if (!snapshot.hasData) {
                  return const Text("NO data");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final message = snapshot.data?[index];
                      final isOwn = message!.senderId ==
                          AuthenticationRepository.instance.authUser!.uid;
                      final lastMessageSeen = snapshot.data!.last;
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: ChatMessageTile(
                          message: message.message,
                          isOwn: isOwn,
                        ),
                      );
                    });
              }),
        ),
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              right: 24,
              left: 24),
          child: SizedBox(
            height: 48,
            child: TextFormField(
              controller: textEditingController,
              decoration: InputDecoration(
                labelText: "Your Message",
                floatingLabelBehavior: FloatingLabelBehavior.never,
                suffix: IconButton(
                  onPressed: () async {
                    await messageController.sendMessage(
                        textEditingController.text.trim(), user!.id);
                    textEditingController.clear();
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.blue,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(20), // Add rounded corners
                  borderSide: BorderSide.none, // Remove the default border
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Colors.blue, // Change the border color when focused
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

class ChatMessageTile extends StatelessWidget {
  ChatMessageTile({super.key, required this.message, required this.isOwn});
  String message;
  bool isOwn;

  @override
  Widget build(BuildContext context) {
    // return Align(
    //   alignment: isOwn ? Alignment.topRight : Alignment.topLeft,
    //   child: Material(
    //     color: isOwn ? Colors.lightBlue : AppColors.darkGrey,
    //     elevation: 2,
    //     borderRadius: BorderRadius.only(
    //         bottomLeft: Radius.circular(10),
    //         bottomRight:isOwn?Radius.zero: Radius.circular(10),
    //         topLeft:isOwn? Radius.circular(10):Radius.zero,
    //         topRight: Radius.circular(10)),

    //     child: Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: Text(
    //         message,
    //         style: Theme.of(context).textTheme.bodyMedium,
    //       ),
    //     ),
    //   ),
    // );
    return Align(
        alignment: isOwn ? Alignment.topRight : Alignment.topLeft,
        child: Container(
          decoration: BoxDecoration(
            color: isOwn
                ? Colors.lightBlue.withOpacity(0.8)
                : AppColors.darkGrey, // Adjust opacity as needed
            borderRadius: BorderRadius.only(
              topLeft: isOwn ? const Radius.circular(10) : Radius.zero,
              topRight: const Radius.circular(10),
              bottomLeft: const Radius.circular(10),
              bottomRight: isOwn ? Radius.zero : const Radius.circular(10),
            ),
            boxShadow: [
              // Optional subtle shadow for depth
              BoxShadow(
                color: Colors.grey
                    .withOpacity(0.2), // Adjust shadow color and opacity
                spreadRadius: 1, // Adjust spread for softer shadow
                blurRadius: 3, // Adjust blur for smoother shadow
                offset: const Offset(0, 2), // Adjust offset for shadow direction
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ));
    // return Align(
    //   alignment: isOwn ? Alignment.topRight : Alignment.topLeft,
    //   child: Padding(
    //     padding: EdgeInsets.all(2.0),
    //     child: Material(
    //       shadowColor: Colors.grey,
    //       borderRadius: isOwn
    //           ? BorderRadius.only(
    //               topLeft: Radius.circular(30),
    //               bottomLeft: Radius.circular(30),
    //               bottomRight: Radius.circular(30))
    //           : BorderRadius.only(
    //               topRight: Radius.circular(30),
    //               bottomLeft: Radius.circular(30),
    //               bottomRight: Radius.circular(30)),
    //       child: Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: Text(
    //           message,
    //           style: TextStyle(fontSize: 15, color: Colors.white),
    //         ),
    //       ),
    //       color: isOwn ? Colors.blueAccent : Colors.black54,
    //     ),
    //   ),
    // );
  }
}
