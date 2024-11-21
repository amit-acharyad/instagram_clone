import 'package:cloud_firestore/cloud_firestore.dart';

class Storyviewer {
  final String viewerId;
  final String storyId;
  Storyviewer({required this.viewerId,required this.storyId});
  static Storyviewer empty() => Storyviewer(viewerId: '',storyId: '');
  factory Storyviewer.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.exists) {
      final data = document.data();
      return Storyviewer(viewerId: data?['viewerId'], storyId: data?['storyId']);
    } else {
      return Storyviewer.empty();
    }
  }
  Map<String, dynamic> toJson() {
    return {'viewerId': viewerId,'storyId':storyId};
  }
}
