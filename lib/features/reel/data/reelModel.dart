import 'package:cloud_firestore/cloud_firestore.dart';

class ReelModel {
  String reelId;
  String uploaderName;
  String uploaderId;
  String reelUrl;
  ReelModel(
      {required this.reelId,
      required this.uploaderId,
      required this.uploaderName,
      required this.reelUrl});
  static ReelModel empty() =>
      ReelModel(reelId: '', uploaderId: '', uploaderName: '', reelUrl: '');
  factory ReelModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.exists) {
      final data = snapshot.data();
      return ReelModel(
          reelId: data?['reelId'],
          uploaderId: data?['uploaderId'],
          uploaderName: data?['uploaderName'],
          reelUrl: data?['reelUrl']);
    } else {
      return ReelModel.empty();
    }
  }
  Map<String, dynamic> json() {
    return {
      'reelId': reelId,
      'reelUrl': reelUrl,
      'uploaderId': uploaderId,
      'uploaderName': uploaderName
    };
  }
}
