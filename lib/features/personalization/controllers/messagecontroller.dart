import 'dart:core';

import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/data/models/messageModel.dart';
import 'package:instagram_clone/data/repositories/messagerepository.dart';
import 'package:instagram_clone/features/personalization/data/models/usermodel.dart';

import '../../authentication/data/authenticationrepository.dart';

class MessageController extends GetxController {
  static MessageController get instance => Get.find();
  final MessageRepository messageRepository = Get.put(MessageRepository());
  RxInt count = 0.obs;

  @override
  onInit() async {
    super.onInit();
    await countUnseenMessages();
  }

  countUnseenMessages() async {
    try {
      // Get the first stream of friends or users
      final stream1 = messageRepository.getMessageFriends();
      print("sream1 ${stream1} ");
      // Use await forEach to handle the stream asynchronously
      await stream1.forEach((friends) async {
        print("freinds are${friends.length} ");
        // Iterate over each friend in the list
        for (var friend in friends) {
          // Get messages from each user (stream2)

          final stream2 = messageRepository.getMessageStream(friend);

          // Process each message stream asynchronously
          await stream2.forEach((messages) {
            // Check the last message's seen status
            print("Message length is ${messages.length}");
            for (int i = 0; i < messages.length; i++) {
              print("seen status ${messages[i].seen}");
              print('friend no ${messages[i].senderId}');
              print("last is ${messages.last.message}. ${messages.last.seen}");
            }
            if (!(messages.last.senderId ==
                AuthenticationRepository.instance.authUser!.uid)) {
              if (!messages.last.seen) {
                count.value++;
              }
            }

            print("count became $count");
          });
        }
        print('count is $count');
      });

      // Now the count should be correct
      print("New message count is $count");
    } catch (e) {
      throw "error is ${e.toString()}";
    }
  }

  Stream<List<String>> getMessageFriends() {
    try {
      return messageRepository.getMessageFriends();
    } catch (E) {
      throw "Error is ${E.toString()}";
    }
  }

  Stream<List<MessageModel>> getMessagesFromUser(String senderId) {
    try {
      return messageRepository.getMessageStream(senderId);
    } catch (e) {
      throw "Message stream error in controller${e.toString()}";
    }
  }

  Future<void> sendMessage(String message, String receiverId) async {
    try {
      await messageRepository.sendMessage(message, receiverId);
    } catch (e) {
      throw "Error sending message${e.toString()}";
    }
  }

  Future<void> updateSeen(String messageId) async {
    try {
      await messageRepository.updateSeen(messageId);
    } catch (e) {
      throw "eerror updating seen ${e.toString()}";
    }
  }
}
