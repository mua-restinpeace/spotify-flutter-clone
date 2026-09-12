import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:spotify/common/widgets/favorite_button/favorite_button.dart';
import 'package:spotify/domain/entities/song/songs.dart';

class SongInformation extends StatefulWidget {
  final SongEntity song;
  const SongInformation(
      {super.key,
      required this.song});

  @override
  State<SongInformation> createState() => _SongInformationState();
}

class _SongInformationState extends State<SongInformation> {
  bool _isOverflowing = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOverflow());
  }

  void _checkOverflow() {
    final renderBox = context.findRenderObject() as RenderBox?;

    if (renderBox == null) return;

    final maxWidth = renderBox.size.width;

    final textPainter = TextPainter(
        text: TextSpan(
          text: widget.song.title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(maxWidth: maxWidth);

    setState(() {
      _isOverflowing = textPainter.didExceedMaxLines;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _isOverflowing
                ? SizedBox(
                    height: 24,
                    child: Marquee(
                      text: widget.song.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                      blankSpace: 20,
                      scrollAxis: Axis.horizontal,
                      velocity: 30,
                      pauseAfterRound: const Duration(seconds: 3),
                      startPadding: 10,
                      accelerationDuration: const Duration(seconds: 1),
                      accelerationCurve: Curves.linear,
                      decelerationDuration: const Duration(milliseconds: 500),
                      decelerationCurve: Curves.easeOut,
                    ),
                  )
                : Text(
                    widget.song.title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
            const SizedBox(
              height: 4,
            ),
            Text(
              widget.song.artist,
              style: const TextStyle(fontSize: 18),
            )
          ],
        )),
        FavoriteButton(
          song: widget.song,
        )
      ],
    );
  }
}
