import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spotify/common/helpers/is_dark_mode.dart';
import 'package:spotify/common/helpers/url_fetch.dart';
import 'package:spotify/common/widgets/appbar/basic_appbar.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/song/songs.dart';
import 'package:spotify/presentation/song_player/bloc/song_player_cubit.dart';
import 'package:spotify/presentation/song_player/bloc/song_player_state.dart';
import 'package:spotify/presentation/song_player/widget/song_information.dart';

class SongPlayerPage extends StatelessWidget {
  final SongEntity song;

  const SongPlayerPage({
    required this.song,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(
        actions: Icon(
          Icons.more_vert,
          size: 30,
        ),
        title: Text(
          'Now Playing',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocProvider(
        create: (_) => SongPlayerCubit()
          ..loadSong(songUrl('${song.title} - ${song.artist}.mp3')),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              _songCover(context),
              const SizedBox(
                height: 16,
              ),
              SongInformation(
                song: song
              ),
              const SizedBox(
                height: 20,
              ),
              _songPlayer(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _songCover(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.3,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                  songCoverUrl('${song.title} by ${song.artist}.jpg')))),
    );
  }

  Widget _songPlayer(BuildContext context) {
    return BlocBuilder<SongPlayerCubit, SongPlayerState>(
        builder: (context, state) {
      if (state is SongPlayerLoading) {
        return Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator());
      }

      if (state is SongPlayerLoaded) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  durationFormat(context.read<SongPlayerCubit>().songPosition),
                  style: const TextStyle(fontSize: 12),
                ),
                Flexible(
                  child: Slider(
                      value: context
                          .read<SongPlayerCubit>()
                          .songPosition
                          .inSeconds
                          .toDouble(),
                      min: 0,
                      max: context
                          .read<SongPlayerCubit>()
                          .songDuration
                          .inSeconds
                          .toDouble(),
                      onChanged: (value) {}),
                ),
                Text(
                  durationFormat(context.read<SongPlayerCubit>().songDuration),
                  style: const TextStyle(fontSize: 12),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      FontAwesomeIcons.repeat,
                      color: context.isDarkMode
                          ? const Color(0xffA7A7A7)
                          : const Color(0xff363636),
                      size: 22,
                    )),
                const SizedBox(
                  width: 16,
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.skip_previous_rounded,
                      color: context.isDarkMode
                          ? const Color(0xffA7A7A7)
                          : const Color(0xff363636),
                      size: 35,
                    )),
                const SizedBox(
                  width: 16,
                ),
                GestureDetector(
                  onTap: () {
                    context.read<SongPlayerCubit>().playOrPauseSong();
                  },
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                    child: Icon(
                      context.read<SongPlayerCubit>().audioPlayer.playing
                          ? Icons.pause
                          : Icons.play_arrow_rounded,
                      size: 45,
                      color: const Color(0xffFFFFFF),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.skip_next_rounded,
                      color: context.isDarkMode
                          ? const Color(0xffA7A7A7)
                          : const Color(0xff363636),
                      size: 35,
                    )),
                const SizedBox(
                  width: 16,
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(FontAwesomeIcons.shuffle,
                        color: context.isDarkMode
                            ? const Color(0xffA7A7A7)
                            : const Color(0xff363636),
                        size: 22))
              ],
            )
          ],
        );
      }

      return Container();
    });
  }

  String durationFormat(Duration duration) {
    final minute = duration.inMinutes.remainder(60);
    final second = duration.inSeconds.remainder(60);
    return '${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}';
  }
}
