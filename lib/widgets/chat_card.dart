import 'package:chat_bubbles/bubbles/bubble_normal_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pmayard_app/app/helpers/time_format.dart';
import 'package:pmayard_app/app/utils/app_colors.dart';
import 'package:pmayard_app/services/api_urls.dart';
import 'package:pmayard_app/widgets/widgets.dart';
import 'package:audioplayers/audioplayers.dart';

class ChatBubbleMessage extends StatelessWidget {
  final String time;
  final String? text;
  final List<String>? images;
  final List<String>? audioUrls; // List হিসেবে নিন
  final bool isSeen;
  final bool isMe;
  final String status;
  final String? profileImage;

  const ChatBubbleMessage({
    super.key,
    required this.time,
    this.text,
    this.images,
    this.audioUrls,
    required this.isMe,
    this.isSeen = false,
    this.status = 'offline',
    this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
      child: Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe)
                CustomImageAvatar(
                  image: profileImage,
                  right: 8.w,
                  radius: 15.r,
                ),
              Flexible(
                child: CustomContainer(
                  paddingAll: 10.r,
                  color: isMe ? const Color(0xff666978) : const Color(0xffE8E9EB),
                  bottomRight: 10.r,
                  bottomLeft: 10.r,
                  topLeftRadius: isMe ? 10.r : 0,
                  topRightRadius: !isMe ? 10.r : 0,
                  child: _buildMessageContent(),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              left: isMe ? 0 : 44.w,
              right: isMe ? 10.w : 0,
              top: 3.h,
            ),
            child: CustomText(
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              text: TimeFormatHelper.timeFormat(time),
              color: AppColors.appGreyColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageContent() {
    // অডিও মেসেজ শো করার জন্য
    if (audioUrls != null && audioUrls!.isNotEmpty) {
      return AudioPlayerWidget(audioUrls: audioUrls!, isMe: isMe);
    }
    // টেক্সট মেসেজ শো করার জন্য
    else if (text?.isNotEmpty == true) {
      return CustomText(
        maxline: 10,
        fontSize: 12.sp,
        textAlign: TextAlign.left,
        fontWeight: FontWeight.w400,
        color: isMe ? Colors.white : Colors.grey.shade800,
        text: text!,
      );
    }
    // ইমেজ মেসেজ শো করার জন্য
    else if (images != null && images!.isNotEmpty) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: images!.map((url) {
            return Padding(
              padding: EdgeInsets.only(right: 5.h),
              child: SizedBox(
                width: 188.w,
                child: BubbleNormalImage(
                  id: url ?? '',
                  image: CustomNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.cover,
                  ),
                  color: Colors.transparent,
                  tail: true,
                ),
              ),
            );
          }).toList(),
        ),
      );
    }
    return const SizedBox();
  }
}

// অডিও প্লেয়ার উইজেট (একাধিক অডিওর জন্য আপডেটেড)
class AudioPlayerWidget extends StatefulWidget {
  final List<String> audioUrls;
  final bool isMe;

  const AudioPlayerWidget({
    super.key,
    required this.audioUrls,
    required this.isMe,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  int _currentAudioIndex = 0;

  @override
  void initState() {
    super.initState();
    _setupAudioPlayer();
  }

  void _setupAudioPlayer() async {
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _isPlaying = false;
        _position = Duration.zero;

        // পরবর্তী অডিওতে যান যদি থাকে
        if (_currentAudioIndex < widget.audioUrls.length - 1) {
          _currentAudioIndex++;
          _playAudio();
        }
      });
    });
  }

  Future<void> _playAudio() async {
    if (widget.audioUrls.isNotEmpty && _currentAudioIndex < widget.audioUrls.length) {
      await _audioPlayer.play(UrlSource(widget.audioUrls[_currentAudioIndex]));
    }
  }

  Future<void> _playPauseAudio() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      if (_position.inSeconds == 0) {
        await _playAudio();
      } else {
        await _audioPlayer.resume();
      }
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.w,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // প্লে/পজ বাটন
              GestureDetector(
                onTap: _playPauseAudio,
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: widget.isMe ? Colors.white.withOpacity(0.2) : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: widget.isMe ? Colors.white : Colors.grey.shade800,
                    size: 18.r,
                  ),
                ),
              ),

              // অডিও সংখ্যা (যদি একাধিক হয়)
              if (widget.audioUrls.length > 1)
                Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: CustomText(
                    text: '${_currentAudioIndex + 1}/${widget.audioUrls.length}',
                    fontSize: 10.sp,
                    color: widget.isMe ? Colors.white.withOpacity(0.7) : Colors.grey.shade600,
                  ),
                ),

              // অডিও ডুরেশন
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: CustomText(
                    text: '${_formatDuration(_position)} / ${_formatDuration(_duration)}',
                    fontSize: 10.sp,
                    color: widget.isMe ? Colors.white.withOpacity(0.7) : Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),

          // প্রোগ্রেস বার
          SizedBox(height: 8.h),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 2.h,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 10.r),
            ),
            child: Slider(
              min: 0,
              max: _duration.inSeconds.toDouble(),
              value: _position.inSeconds.toDouble(),
              onChanged: (value) async {
                final position = Duration(seconds: value.toInt());
                await _audioPlayer.seek(position);
              },
              activeColor: widget.isMe ? Colors.white : Colors.grey.shade600,
              inactiveColor: widget.isMe ? Colors.white.withOpacity(0.3) : Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}