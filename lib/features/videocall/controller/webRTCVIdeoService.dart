import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'videoCallChecker.dart';

class WebRTCVideoService {
  Map<String, dynamic> config = {
    'iceServers': [
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
          'stun:stun2.l.google.com:19302'
        ]
      }
    ]
  };
  RTCPeerConnection? peerConnection;
  MediaStream? localStream;
  MediaStream? remoteStream;
  String? roomId;
  void Function(MediaStream)? onAddRemoteStream;

  Future<String> createRoom(RTCVideoRenderer remomteRenderer) async {
    try {
      DocumentReference roomRef =
          FirebaseFirestore.instance.collection("rooms").doc();
      //creating peer connection
      peerConnection = await createPeerConnection(config);
      registerPeerConnection();
      //add local stream tracjs
      localStream?.getTracks().forEach((track) {
        peerConnection?.addTrack(track, localStream!);
      });
      var callerCandidateCollection = roomRef.collection("callerCandidates");
      peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
        callerCandidateCollection.add(candidate.toMap());
      };
      RTCSessionDescription offer = await peerConnection!.createOffer();
      await peerConnection!.setLocalDescription(offer);
      Map<String, dynamic> roomWithOffer = {'offer': offer.toMap()};
      await roomRef.set(roomWithOffer);
      var roomId = roomRef.id;

      peerConnection?.onTrack = (RTCTrackEvent event) {
        event.streams[0].getTracks().forEach((track) {
          remoteStream?.addTrack(track);
        });
      };
      roomRef.snapshots().listen((snapshot) async {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        if (peerConnection?.getRemoteDescription() != null &&
            data['answer'] != null) {
          var answer = RTCSessionDescription(
              data['answer']['sdp'], data['answer']['type']);
          await peerConnection?.setRemoteDescription(answer);
        }
      });
      roomRef.collection('calleeCandidates').snapshots().listen((snapshots) {
        for (var change in snapshots.docChanges) {
          if (change.type == DocumentChangeType.added) {
            Map<String, dynamic> data =
                change.doc.data() as Map<String, dynamic>;
            peerConnection?.addCandidate(RTCIceCandidate(
                data['candidate'], data['sdpMid'], data["sdpMLineIndex"]));
          }
        }
      });
      return roomId;
    } catch (e) {
      throw "Error could not create room ${e.toString()}";
    }
  }

  Future<void> joinRoom(String roomId, RTCVideoRenderer remoteVideo) async {
    try {
      VideoCallChecker.listenCurrentCall();
      DocumentReference roomRef =
          FirebaseFirestore.instance.collection("rooms").doc(roomId);
      var roomSnapshot = await roomRef.get();
      if (roomSnapshot.exists) {
        peerConnection = await createPeerConnection(config);
        registerPeerConnection();
        localStream?.getTracks().forEach((track) {
          peerConnection?.addTrack(track, localStream!);
        });
        var calleeCandidateCollection = roomRef.collection("calleeCandiates");
        peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
          calleeCandidateCollection.add(candidate.toMap());
        };
        peerConnection?.onTrack = (RTCTrackEvent event) {
          event.streams[0].getTracks().forEach((track) {
            remoteStream!.addTrack(track);
            
          });
        };
        var data = roomSnapshot.data() as Map<String, dynamic>;
        var offer = data["offer"];
        await peerConnection?.setRemoteDescription(
            RTCSessionDescription(offer["sdp"], offer["type"]));
        var answer = await peerConnection!.createAnswer();
        await peerConnection!.setLocalDescription(answer);
        Map<String, dynamic> roomWithAnswer = {
          'answer': {'type': answer.type, 'sdp': answer.sdp}
        };
        await roomRef.update(roomWithAnswer);
        roomRef.collection("callerCandidates").snapshots().listen((snapshot) {
          for (var document in snapshot.docChanges) {
            var data = document.doc.data() as Map<String, dynamic>;
            peerConnection!.addCandidate(RTCIceCandidate(
                data["candidate"], data["sdpMid"], data["sdpMLineIndex"]));
          }
        });
      }
    } catch (e) {
      throw "Error joining room ${e.toString()}";
    }
  }

  Future<void> openUserMedia(
      RTCVideoRenderer localVideo, RTCVideoRenderer remoteVideo) async {
    try {
      var stream = await navigator.mediaDevices
          .getUserMedia({'audio': true, 'video': true});
      localVideo.srcObject = stream;
      localStream = stream;
      remoteVideo.srcObject = await createLocalMediaStream("key");
    } catch (e) {
      throw "Could not open Media ${e.toString()}";
    }
  }

  Future<void> hangUp(RTCVideoRenderer localVideo) async {
    try {
      if (localVideo.srcObject != null) {
        List<MediaStreamTrack> tracks = localVideo.srcObject!.getTracks();
        for (var track in tracks) {
          track.stop();
        }
      } else {
        print("localVideo.srcObject is null");
      }

      // Check if remoteStream is not null before stopping tracks
      if (remoteStream != null) {
        remoteStream!.getTracks().forEach((track) {
          track.stop();
        });
      } else {
        print("remoteStream is null");
      }

      // Check if peerConnection is not null before closing
      if (peerConnection != null) {
        peerConnection!.close();
        peerConnection!.dispose();
      } else {
        print("peerConnection is null");
      }

      // Check if roomId is not null before performing Firestore operations
      if (VideoCallChecker.currentCall.value.roomId != '1') {
        print("Delete call called");
        var roomRef =
            FirebaseFirestore.instance.collection("rooms").doc(roomId);

        // Delete callee candidates
        var calleeCandidate =
            await roomRef.collection("calleeCandidates").get();
        for (var doc in calleeCandidate.docs) {
          doc.reference.delete();
        }

        // Delete caller candidates
        var callerCandidate =
            await roomRef.collection("callerCandidates").get();
        for (var doc in callerCandidate.docs) {
          doc.reference.delete();
        }
        // Delete the room
        await roomRef.delete();
      } else {
        print("roomId is null");
      }

      // Dispose of local and remote streams if they are not null
      if (localStream != null) {
        localStream!.dispose();
      } else {
        print("localStream is null");
      }

      if (remoteStream != null) {
        remoteStream!.dispose();
      } else {
        print("remoteStream is null");
      }
      print("Hangup ends here");
    } catch (e) {
      throw "Error hanging up: ${e.toString()}";
    }
  }

  void registerPeerConnection() {
    try {
      peerConnection?.onAddStream = (MediaStream stream) {
        onAddRemoteStream?.call(stream);
        remoteStream = stream;
      };
    } catch (e) {
      throw "Could not register PeerConnection ${e.toString()}";
    }
  }
}
