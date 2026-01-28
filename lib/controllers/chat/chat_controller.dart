import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pmayard_app/app/helpers/photo_picker_helper.dart';
import 'package:pmayard_app/models/chat/chat_model_data.dart';
import 'package:pmayard_app/models/chat/group_chat_model_data.dart';
import 'package:pmayard_app/models/chat/inbox_model_data.dart';
import 'package:pmayard_app/services/api_client.dart';
import 'package:pmayard_app/services/api_urls.dart';
import 'package:pmayard_app/widgets/custom_tost_message.dart';
import 'package:record/record.dart';

class ChatController extends GetxController {
  final TextEditingController searchController = TextEditingController();

  RxBool isLoadingChat = false.obs;

  var chatData = <ChatModelData>[].obs;
  var groupChatData = <GroupModelData>[].obs;


  var filteredChatData = <ChatModelData>[].obs;


  void filterChats(String query) {
    if (query.isEmpty) {
      filteredChatData.value = List.from(chatData);
    } else {
      filteredChatData.value = chatData
          .where((chat) => chat.otherUser?.roleId?.name
          ?.toLowerCase()
          .contains(query.toLowerCase()) ?? false)
          .toList();
    }
  }


  final chatType = [
    {'label': 'Chat', 'value': 'individual'},
    {'label': 'Announcement', 'value': 'group'},
  ];


  RxString selectedValueType = 'individual'.obs;

  void onTapChatType(String value) {
    if (value == 'group') {
      chatData.clear();
      update();
    } else {
      groupChatData.clear();
      update();
    }
    selectedValueType.value = value;
    getChat(selectedValueType.value);
    print('Selected chat type: $value');
  }

  Future<void> getChat(String type) async {
    chatData.clear();
    groupChatData.clear();
    isLoadingChat.value = true;
    update();

    final response = await ApiClient.getData(ApiUrls.conversations(type));
    if (response.statusCode == 200) {
      final List data = response.body['data'] ?? [];

      if (selectedValueType.value == 'individual') {
        final chats = data.map((item) => ChatModelData.fromJson(item)).toList();
        chatData.addAll(chats);
        filteredChatData.value = List.from(chatData);
      } else if (selectedValueType.value == 'group') {
        final chats = data
            .map((item) => GroupModelData.fromJson(item))
            .toList();
        groupChatData.addAll(chats);
      }
    }
    isLoadingChat.value = false;
    update();
  }

  bool isLoadingInbox = false;
  InboxModelData? inboxData;

  Future<void> getInbox(String chatID) async {
    isLoadingInbox = true;
    update();

    final response = await ApiClient.getData(ApiUrls.inbox(chatID));
    if (response.statusCode == 200) {
      final data = response.body['data'];

      if (data != null) {
        inboxData = InboxModelData.fromJson(data);
      }
    }
    isLoadingInbox = false;
    update();
  }

  final TextEditingController messageController = TextEditingController();


  Future<void> sendMessage(String conversationID) async {
    final response = await ApiClient.postData(
      ApiUrls.sendMessage(conversationID),
      {"message_text": messageController.text.trim()},
    );
    if (response.statusCode == 200) {}
  }




  File? selectedImage;

  bool isLoadingImage = false;

  void onTapImageShow(context,String conversationID) {
    PhotoPickerHelper.showPicker(
      context: context,
      onImagePicked: (image) {
        selectedImage = File(image.path);
        update();
        if(selectedImage != null){
          sendAttachments(conversationID,'attachments');
        }

      },
    );
  }

  Future<void> sendAttachments(String conversationID,String type) async {
    isLoadingImage = true;
    update();

    List<MultipartBody>? multipartBody;
    if (selectedImage != null) {
      multipartBody = [MultipartBody('images', selectedImage ?? File(''))];
    }

    final response = await ApiClient.postMultipartData(
      multipartBody: multipartBody,
      ApiUrls.sendAttachments(conversationID),

      {"data": jsonEncode({
        "message_type": type
      })},
    );
    if (response.statusCode == 200) {}

    isLoadingImage = false;
    update();
  }



  // ==================== VOICE RECORDING (BEST APPROACH) ====================

  bool isRecording = false;
  bool showGlowEffect = false;
  AudioRecorder? audioRecorder;
  String? audioPath;
  Timer? recordingTimer;
  Timer? glowTimer;
  Duration recordingDuration = Duration.zero;

  final AudioPlayer audioPlayer = AudioPlayer();

  Future<void> startRecording() async {
    try {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {

        showToast(
          'Microphone permission is needed to record audio',
        );
        return;
      }

      if (Platform.isAndroid) {
        if (await _getAndroidVersion() >= 33) {
        } else {
          var storageStatus = await Permission.storage.request();
          if (storageStatus != PermissionStatus.granted) {
            showToast(
              'Permission Required',
            );
            return;
          }
        }
      }


      audioRecorder = AudioRecorder();

      if (await audioRecorder!.hasPermission() == false) {
        showToast('Recording permission denied');
        return;
      }

      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;


      audioPath = '${directory.path}/recording_$timestamp.m4a';

      final config = RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
        numChannels: 1,
      );

      await audioRecorder!.start(config, path: audioPath!);

      isRecording = true;
      showGlowEffect = true;
      glowTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
        if (isRecording) {
          showGlowEffect = !showGlowEffect;
          update();
        }
      });

      recordingDuration = Duration.zero;
      recordingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (isRecording) {
          recordingDuration += Duration(seconds: 1);
          update();
        }
      });

      update();
      print('Recording started (AAC format): $audioPath');

    } catch (e) {
      print('Recording error: $e');
      isRecording = false;
      showGlowEffect = false;
      update();
    }
  }


  Future<void> stopRecording(String conversationID) async {
    try {
      if (!isRecording || audioRecorder == null) return;


      final path = await audioRecorder!.stop();

      isRecording = false;
      showGlowEffect = false;


      recordingTimer?.cancel();
      recordingTimer = null;
      glowTimer?.cancel();
      glowTimer = null;

      update();


      if (path != null && File(path).existsSync()) {
        final audioFile = File(path);
        final fileSize = await audioFile.length();


        if (fileSize > 1000 && fileSize < 10 * 1024 * 1024) {
          await sendAudioFile(conversationID, audioFile);
        } else {
          if (await audioFile.exists()) {
            await audioFile.delete();
          }
        }
      }

      audioRecorder?.dispose();
      audioRecorder = null;

    } catch (e) {
      isRecording = false;
      showGlowEffect = false;
      recordingTimer?.cancel();
      glowTimer?.cancel();
      audioRecorder?.dispose();
      audioRecorder = null;
      update();
    }
  }


  bool isLoadingAudio = false;

  Future<void> sendAudioFile(String conversationID, File audioFile) async {

    isLoadingAudio = true;
    update();
    try {
      print('Sending audio file: ${audioFile.path}');

      List<MultipartBody> multipartBody = [
        MultipartBody('images', audioFile),
      ];

      final response = await ApiClient.postMultipartData(
        multipartBody: multipartBody,
        ApiUrls.sendAttachments(conversationID),
        {
          "data": jsonEncode({
            "message_type": "audio",
          })
        },
      );

      if (response.statusCode == 200) {

        if (await audioFile.exists()) {
          await audioFile.delete();
        }
        audioPath = null;
        recordingDuration = Duration.zero;

      } else {

      }
    } catch (e) {
      print('Send audio error: $e');
    }

    isLoadingAudio = false;
    update();
  }

  Future<void> cancelRecording() async {
    try {
      if (audioRecorder != null) {
        await audioRecorder!.stop();
        audioRecorder?.dispose();
        audioRecorder = null;
      }

      isRecording = false;
      showGlowEffect = false;
      recordingTimer?.cancel();
      recordingTimer = null;
      glowTimer?.cancel();
      glowTimer = null;
      recordingDuration = Duration.zero;

      if (audioPath != null && File(audioPath!).existsSync()) {
        await File(audioPath!).delete();
      }

      audioPath = null;
      update();

    } catch (e) {
      print('Cancel recording error: $e');
    }
  }

  Future<int> _getAndroidVersion() async {
    if (Platform.isAndroid) {
      return 33;
    }
    return 0;
  }

  @override
  void onClose() {
    recordingTimer?.cancel();
    glowTimer?.cancel();
    audioRecorder?.dispose();
    audioPlayer.dispose();
    super.onClose();
  }

}
