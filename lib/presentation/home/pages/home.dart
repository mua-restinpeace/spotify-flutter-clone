import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spotify/common/helpers/is_dark_mode.dart';
import 'package:spotify/common/widgets/appbar/basic_appbar.dart';
import 'package:spotify/core/configs/assets/app_images.dart';
import 'package:spotify/core/configs/assets/app_vectors.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/presentation/home/widget/news_song.dart';
import 'package:spotify/presentation/home/widget/playlist.dart';
import 'package:spotify/presentation/profile/bloc/favorite_song_cubit.dart';
import 'package:spotify/presentation/profile/bloc/profile_cubit.dart';
import 'package:spotify/presentation/profile/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});
  // final FavoriteCubitManager favoriteManager = FavoriteCubitManager();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        hideBackButton: true,
        leadingIcon: Icons.search_sharp,
        actions: IconButton(
            onPressed: () {
              try {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                  create: (_) => ProfileCubit()..getUser()),
                              BlocProvider(
                                  create: (_) => FavoriteSongCubit()
                                    ..getUserFavoriteSongs())
                            ],
                            child: ProfilePage())));
              } catch (e, stackTrace) {
                debugPrint("Navigation error: $e");
                debugPrintStack(stackTrace: stackTrace);
              }
            },
            icon: const Icon(
              FontAwesomeIcons.user,
            )),
        title: SvgPicture.asset(
          AppVectors.logo,
          height: 40,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _topHomeCard(),
              const SizedBox(
                height: 30,
              ),
              _tabBar(),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 260,
                child: TabBarView(controller: _tabController, children: [
                  NewsSong(),
                  Container(),
                  Container(),
                  Container(),
                ]),
              ),
              Playlist()
            ],
          ),
        ),
      ),
    );
  }

  Widget _topHomeCard() {
    return SizedBox(
      height: 180,
      child: Stack(children: [
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Stack(
                  children: [
                    const Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'New Album',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Happier Than Ever',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Bilie Eilish',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Spacer()
                      ],
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: SvgPicture.asset(AppVectors.topPattern),
                    )
                  ],
                ),
              ),
            )),
        Align(
          alignment: Alignment.bottomRight,
          child: Image.asset(AppImages.homeArtist),
        )
      ]),
    );
  }

  Widget _tabBar() {
    return TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: context.isDarkMode ? Colors.white : Colors.black,
        indicatorColor: AppColors.primary,
        dividerColor: Colors.transparent,
        tabAlignment: TabAlignment.center,
        tabs: const [
          Text(
            'News',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            'Videos',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            'Artists',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            'Podcasts',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ]);
  }
}
