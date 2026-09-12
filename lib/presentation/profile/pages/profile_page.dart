import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/bloc/favorite_button/favorite_cubit_manager.dart';
import 'package:spotify/common/helpers/is_dark_mode.dart';
import 'package:spotify/common/helpers/url_fetch.dart';
import 'package:spotify/common/widgets/appbar/basic_appbar.dart';
import 'package:spotify/presentation/profile/bloc/favorite_song_cubit.dart';
import 'package:spotify/presentation/profile/bloc/favorite_song_state.dart';
import 'package:spotify/presentation/profile/bloc/profile_cubit.dart';
import 'package:spotify/presentation/profile/bloc/profile_state.dart';
import 'package:spotify/presentation/song_player/pages/song_player_page.dart';
import 'package:spotify/service_locator.dart';

class ProfilePage extends StatelessWidget {
  final favoriteCubitManager = sl<FavoriteCubitManager>();
  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert_rounded,
              size: 30,
            )),
        backgroundColor: context.isDarkMode
            ? const Color(0xff2C2B2B)
            : const Color(0xffFFFFFF),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _profileInfo(context),
            const SizedBox(
              height: 20,
            ),
            _favoriteSongList()
          ],
        ),
      ),
    );
  }

  Widget _profileInfo(BuildContext context) {
    return Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 3,
        decoration: BoxDecoration(
            color: context.isDarkMode
                ? const Color(0xff2C2B2B)
                : const Color(0xffFFFFFF),
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30))),
        child:
            BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
          if (state is ProfileLoading) {
            return Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            );
          }

          if (state is ProfileLoaded) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(state.userEntity.imageURL!))),
                  height: 90,
                  width: 90,
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  state.userEntity.email!,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.normal),
                ),
                Text(
                  state.userEntity.fullName!,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          state.userEntity.followers!.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const Text(
                          'followers',
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 14),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 120,
                    ),
                    Column(
                      children: [
                        Text(
                          state.userEntity.following!.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const Text(
                          'following',
                          style: const TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 14),
                        )
                      ],
                    )
                  ],
                )
              ],
            );
          }

          if (state is ProfileLoadFailure) {
            return const Text('An error occurred. Please try again later');
          }
          return Container();
        }));
  }

  Widget _favoriteSongList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Favorite Song',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          BlocBuilder<FavoriteSongCubit, FavoriteSongState>(
              builder: (context, state) {
            if (state is FavoriteSongLoading) {
              return Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
            }

            if (state is FavoriteSongLoaded) {
              return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.favSongList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final song = state.favSongList[index];

                    return ListTile(
                      leading: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(songCoverUrl(
                                    '${song.title} by ${song.artist}.jpg')))),
                      ),
                      title: Text(
                        song.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      subtitle: Text(
                        song.artist,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.more_horiz_rounded)),
                      onTap: () async {
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => SongPlayerPage(
                                    song: song)));
                        if(context.mounted){
                          debugPrint('context is mounted');
                        }

                        if (result == true) {
                          debugPrint('result is true, emitting a new favoriteSongLoaded');
                          context
                              .read<FavoriteSongCubit>()
                              .getUserFavoriteSongs();
                        }
                      },
                    );
                  });
            }

            if (state is FavoriteSongLoadFail) {
              return const Text('An Error Occurred. Please try again later.');
            }
            return Container();
          })
        ],
      ),
    );
  }
}
