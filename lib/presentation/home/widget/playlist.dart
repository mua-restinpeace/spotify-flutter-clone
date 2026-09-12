import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/bloc/favorite_button/favorite_button_cubit.dart';
import 'package:spotify/common/bloc/favorite_button/favorite_button_state.dart';
import 'package:spotify/common/bloc/favorite_button/favorite_cubit_manager.dart';
import 'package:spotify/common/helpers/is_dark_mode.dart';
import 'package:spotify/common/widgets/favorite_button/favorite_button.dart';
import 'package:spotify/presentation/home/bloc/playlist_cubit.dart';
import 'package:spotify/presentation/home/bloc/playlist_state.dart';
import 'package:spotify/presentation/song_player/pages/song_player_page.dart';
import 'package:spotify/service_locator.dart';

class Playlist extends StatelessWidget {
  final favoriteManager = sl<FavoriteCubitManager>();
  Playlist({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => PlaylistCubit()..getPlaylist())],
      child:
          BlocBuilder<PlaylistCubit, PlaylistState>(builder: (context, state) {
        if (state is PlaylistLoaded) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 36),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Playlist',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'See More',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    )
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: state.songs.length,
                    itemBuilder: (context, index) {
                      final song = state.songs[index];
                      final favoriteCubit =
                          favoriteManager.getCubit(song.songId);

                      return BlocProvider.value(
                          value: favoriteCubit,
                          child: BlocBuilder<FavoriteButtonCubit,
                                  FavoriteButtonState>(
                              builder: (context, favState) {

                            return ListTile(
                              title: Text(
                                song.title,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                song.artist,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal),
                              ),
                              trailing: FavoriteButton(
                                song: song
                              ),
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: context.isDarkMode
                                        ? const Color(0xff2C2C2C)
                                        : const Color(0xffE6E6E6)),
                                child: Icon(
                                  Icons.play_arrow_rounded,
                                  color: context.isDarkMode
                                      ? const Color(0xff959595)
                                      : const Color(0xff555555),
                                  size: 30,
                                ),
                              ),
                              onTap: () async {
                                final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => SongPlayerPage(
                                              song: song
                                            )));
                                if (result == true) {
                                  debugPrint('songPlayerPage result true, load initial favorite status ${song.title}');
                                  favoriteCubit
                                      .loadInitialsFavoriteStatus(song.songId);
                                }
                              },
                            );
                          }));
                    }),
              ],
            ),
          );
        }
        return Container(
          alignment: Alignment.center,
          child: const CircularProgressIndicator(),
        );
      }),
    );
  }
}
