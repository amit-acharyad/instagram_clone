import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String type;
  final Timestamp time;
  final String postId;
  final String userId;
  NotificationModel({required this.id,required this.time,required this.type,required this.userId, this.postId=''});
}
