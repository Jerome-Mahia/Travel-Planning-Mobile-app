import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_pixels/image_pixels.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/crossfade_state.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/player_context.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:travel_planner_app_cs_project/main.dart';
import 'package:travel_planner_app_cs_project/screens/planning/saved_plans_screen.dart';
import 'package:travel_planner_app_cs_project/widgets/bottom_navbar_widget.dart';
import 'package:travel_planner_app_cs_project/widgets/play_pause_button.dart';
import 'package:travel_planner_app_cs_project/widgets/sized_icon_button.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:badges/badges.dart' as badges;

class NowPlaying extends ConsumerStatefulWidget {
  const NowPlaying({
    Key? key,
    // required this.closeOpen,
  }) : super(key: key);
  // final VoidCallback closeOpen;

  @override
  _NowPlayingState createState() => _NowPlayingState();
}

class _NowPlayingState extends ConsumerState<NowPlaying> {
  bool isLiked = false;
  bool _loading = false;
  bool _connected = false;

  final Logger _logger = Logger(
    //filter: CustomLogFilter(), // custom logfilter can be used to have logs in release mode
    printer: PrettyPrinter(
      methodCount: 2, // number of method calls to be displayed
      errorMethodCount: 8, // number of method calls if stacktrace is provided
      lineLength: 120, // width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: true,
    ),
  );

  CrossfadeState? crossfadeState;
  late ImageUri? currentTrackImageUri;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Nunito',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.light().copyWith(
          surface: Colors.white, // Specify your desired surface color here
        ),
        primaryColor: const Color.fromRGBO(255, 69, 91, 1),
      ),
      home: StreamBuilder<ConnectionStatus>(
        stream: SpotifySdk.subscribeConnectionStatus(),
        builder: (context, snapshot) {
          _connected = false;
          var data = snapshot.data;
          if (data != null) {
            _connected = data.connected;
          }
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Scaffold(
              //backgroundColor: nowPlaying["playerColor"],
              backgroundColor: Colors.transparent,
              body: _sampleFlowWidget(context),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlayerStateWidget() {
    return StreamBuilder<PlayerState>(
      stream: SpotifySdk.subscribePlayerState(),
      builder: (BuildContext context, AsyncSnapshot<PlayerState> snapshot) {
        var track = snapshot.data?.track;
        currentTrackImageUri = track?.imageUri;
        var playerState = snapshot.data;

        if (playerState == null || track == null) {
          return Center(
            child: Container(),
          );
        }

        int updatedPlaybackPosition = playerState.playbackPosition;

        String formatMilliseconds(int milliseconds) {
          int seconds = (milliseconds / 1000).floor();
          int minutes = (seconds / 60).floor();
          seconds -= minutes * 60;
          String formattedSeconds = seconds.toString().padLeft(2, '0');
          return '$minutes:$formattedSeconds';
        }

        return Expanded(
          child: Stack(
            children: [
              spotifyBackgroundColor(track.imageUri),
              // _buildPlayerContextWidget(),
              Positioned.fill(
                top: MediaQuery.of(context).size.height * 0.03,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: BottomNavBar(),
                          pageTransitionAnimation:
                              PageTransitionAnimation.scale,
                        );
                      },
                      child: FaIcon(
                        FontAwesomeIcons.chevronDown,
                        color: Colors.white54,
                        size: 40,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: _connected
                              ? spotifyImageWidget(track.imageUri)
                              : const Text('Connect to see an image...'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.loose,
                      child: Column(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 30.0, right: 20),
                              child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    '${track.name}',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    '${track.artist.name}',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white60,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isLiked = !isLiked;
                                      });
                                    },
                                    icon: isLiked
                                        ? SizedIconButton(
                                            width: 50,
                                            onPressed: addToLibrary,
                                            icon: FaIcon(
                                              FontAwesomeIcons.solidHeart,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          )
                                        : SizedIconButton(
                                            width: 50,
                                            onPressed: addToLibrary,
                                            icon: FaIcon(
                                              FontAwesomeIcons.heart,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ),
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Wrap(
                                children: [
                                  SliderTheme(
                                    data: const SliderThemeData(
                                        trackHeight: 3,
                                        thumbShape: RoundSliderThumbShape(
                                            enabledThumbRadius: 6)),
                                    child: Slider(
                                      activeColor: Colors.white,
                                      inactiveColor: Colors.white30,
                                      divisions: 100,
                                      value: updatedPlaybackPosition.toDouble(),
                                      onChanged: (value) {
                                        // Update the separate variable with the new slider value
                                        setState(() {
                                          updatedPlaybackPosition =
                                              value.toInt();
                                        });
                                      },
                                      min: 0.0,
                                      max: track.duration.toDouble(),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 30.0, right: 30),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          child: Text(
                                            formatMilliseconds(
                                                playerState.playbackPosition),
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white54),
                                          ),
                                        ),
                                        Text(
                                          formatMilliseconds(track.duration),
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white54),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Flexible(
                            flex: 1,
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20, top: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedIconButton(
                                      width: 50,
                                      icon: playerState
                                              .playbackOptions.isShuffling
                                          ? FaIcon(
                                              FontAwesomeIcons.random,
                                              size: 28,
                                              color: Colors.white,
                                            )
                                          : FaIcon(
                                              FontAwesomeIcons.random,
                                              size: 28,
                                              color: Colors.white54,
                                            ),
                                      onPressed: toggleShuffle,
                                    ),
                                    SizedIconButton(
                                        width: 50,
                                        icon: FaIcon(
                                          FontAwesomeIcons.backward,
                                          size: 28,
                                          color: Colors.white,
                                        ),
                                        onPressed: skipPrevious),
                                    playerState.isPaused
                                        ? Container(
                                            height: 60,
                                            width: 60,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            child: SizedIconButton(
                                                width: 60,
                                                icon: FaIcon(
                                                  FontAwesomeIcons.play,
                                                  size: 25,
                                                  color: Colors.black,
                                                ),
                                                onPressed: resume),
                                          )
                                        : Container(
                                            height: 60,
                                            width: 60,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            child: SizedIconButton(
                                                width: 60,
                                                icon: FaIcon(
                                                  FontAwesomeIcons.pause,
                                                  size: 28,
                                                  color: Colors.black,
                                                ),
                                                onPressed: pause),
                                          ),
                                    SizedIconButton(
                                        width: 50,
                                        icon: FaIcon(
                                          FontAwesomeIcons.forward,
                                          size: 28,
                                          color: Colors.white,
                                        ),
                                        onPressed: skipNext),
                                    SizedIconButton(
                                      width: 50,
                                      icon: playerState.playbackOptions
                                                      .repeatMode.index ==
                                                  1 ||
                                              playerState.playbackOptions
                                                      .repeatMode.index ==
                                                  2
                                          ? FaIcon(
                                              FontAwesomeIcons.repeat,
                                              size: 28,
                                              color: Colors.white,
                                            )
                                          : FaIcon(
                                              FontAwesomeIcons.repeat,
                                              size: 28,
                                              color: Colors.white54,
                                            ),
                                      onPressed: toggleRepeat,
                                    ),
                                  ],
                                )),
                          ),
                          // Flexible(
                          //   flex: 1,
                          //   child: Padding(
                          //       padding: const EdgeInsets.only(left: 20.0, right: 20),
                          //       child: Row(
                          //         //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //         children: [
                          //           IconButton(
                          //               onPressed: () {},
                          //               icon: const Icon(FluentIcons
                          //                   .device_meeting_room_remote_20_regular)),
                          //           const Spacer(),
                          //           IconButton(
                          //             onPressed: () {},
                          //             icon: const Icon(
                          //                 FluentIcons.share_ios_20_regular),
                          //           ),
                          //           IconButton(
                          //             onPressed: () {},
                          //             icon: const Icon(FluentIcons.list_20_regular),
                          //           ),
                          //         ],
                          //       )),
                          // ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlayerContextWidget() {
    return StreamBuilder<PlayerContext>(
      stream: SpotifySdk.subscribePlayerContext(),
      initialData: PlayerContext('', '', '', ''),
      builder: (BuildContext context, AsyncSnapshot<PlayerContext> snapshot) {
        var playerContext = snapshot.data;
        if (playerContext == null) {
          return const Center(
            child: Text('Not connected'),
          );
        }
        ref.read(songUriProvider.notifier).state = playerContext.uri;
        // return Column(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: <Widget>[
        //     Text('Title: ${playerContext.title}'),
        //     Text('Subtitle: ${playerContext.subtitle}'),
        //     Text('Type: ${playerContext.type}'),
        //     Text('Uri: ${playerContext.uri}'),
        //   ],
        // );
        return Container();
      },
    );
  }

  Future<void> addToLibrary() async {
    try {
      String songUri = ref.watch(songUriProvider);
      await SpotifySdk.addToLibrary(spotifyUri: songUri);
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Widget _sampleFlowWidget(BuildContext context2) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _loading
              ? Center(
                  child: LoadingAnimationWidget.inkDrop(
                    color: Colors.white,
                    size: MediaQuery.of(context).size.height * 0.1,
                  ),
                )
              : _connected
                  ? _buildPlayerStateWidget()
                  : Center(
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () => connectToSpotifyRemote(),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              onPrimary: Colors.white,
                              onSurface: Colors.grey,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.spotify,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Connect to Spotify',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => getAccessToken,
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              onPrimary: Colors.white,
                              onSurface: Colors.grey,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.spotify,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Get Authentication Token',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
        ],
      ),
    );
  }

  Widget spotifyBackgroundColor(ImageUri image) {
    return FutureBuilder(
        future: SpotifySdk.getImage(
          imageUri: image,
        ),
        builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          if (snapshot.hasData) {
            ImageProvider imageProvider = MemoryImage(snapshot.data!);
            return ImagePixels(
              imageProvider: imageProvider,
              builder: (context, img) {
                Color backgroundColor =
                    img.pixelColorAtAlignment!(Alignment.center);
                return Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      stops: const [0.5, 1],
                      colors: [
                        backgroundColor,
                        Colors.black.withOpacity(0.1),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                );
              },
            );
          } else {
            return Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  stops: const [0.5, 1],
                  colors: [
                    Colors.grey,
                    Colors.black.withOpacity(0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            );
          }
        });
  }

  Widget spotifyImageWidget(ImageUri image) {
    return FutureBuilder(
        future: SpotifySdk.getImage(
          imageUri: image,
          dimension: ImageDimension.large,
        ),
        builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              width: ImageDimension.large.value.toDouble(),
              height: ImageDimension.large.value.toDouble(),
              child: Center(
                child: Shimmer.fromColors(
                  baseColor: Colors.green,
                  highlightColor: Colors.greenAccent,
                  child: Container(
                    color: Colors.white,
                  ),
                ),
              ),
            );
          } else if (snapshot.hasData) {
            return Image.memory(snapshot.data!);
          } else if (snapshot.hasError) {
            setStatus(snapshot.error.toString());
            return SizedBox(
              width: ImageDimension.large.value.toDouble(),
              height: ImageDimension.large.value.toDouble(),
              child: Center(
                child: Shimmer.fromColors(
                  baseColor: Colors.red,
                  highlightColor: Colors.redAccent,
                  child: Container(
                    color: Colors.white,
                  ),
                ),
              ),
            );
          } else {
            return SizedBox(
              width: ImageDimension.large.value.toDouble(),
              height: ImageDimension.large.value.toDouble(),
              child: Center(
                child: Shimmer.fromColors(
                  baseColor: Colors.white,
                  highlightColor: Colors.grey[300]!,
                  child: Container(
                    color: Colors.white,
                  ),
                ),
              ),
            );
          }
        });
  }

  Future<void> disconnect() async {
    try {
      setState(() {
        _loading = true;
      });
      var result = await SpotifySdk.disconnect();
      setStatus(result ? 'disconnect successful' : 'disconnect failed');
      setState(() {
        _loading = false;
      });
    } on PlatformException catch (e) {
      setState(() {
        _loading = false;
      });
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setState(() {
        _loading = false;
      });
      setStatus('not implemented');
    }
  }

  Future<void> connectToSpotifyRemote() async {
    try {
      setState(() {
        _loading = true;
      });
      var result = await SpotifySdk.connectToSpotifyRemote(
          clientId: dotenv.env['CLIENT_ID'].toString(),
          redirectUrl: dotenv.env['REDIRECT_URL'].toString());
      setStatus(result
          ? 'connect to spotify successful'
          : 'connect to spotify failed');
      setState(() {
        _loading = false;
      });
    } on PlatformException catch (e) {
      setState(() {
        _loading = false;
      });
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setState(() {
        _loading = false;
      });
      setStatus('not implemented');
    }
  }

  Future<String> getAccessToken() async {
    try {
      var authenticationToken = await SpotifySdk.getAccessToken(
          clientId: dotenv.env['CLIENT_ID'].toString(),
          redirectUrl: dotenv.env['REDIRECT_URL'].toString(),
          scope: 'app-remote-control, '
              'user-modify-playback-state, '
              'playlist-read-private, '
              'playlist-modify-public,user-read-currently-playing');
      setStatus('Got a token: $authenticationToken');
      return authenticationToken;
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
      return Future.error('$e.code: $e.message');
    } on MissingPluginException {
      setStatus('not implemented');
      return Future.error('not implemented');
    }
  }

  Future getPlayerState() async {
    try {
      return await SpotifySdk.getPlayerState();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future getCrossfadeState() async {
    try {
      var crossfadeStateValue = await SpotifySdk.getCrossFadeState();
      setState(() {
        crossfadeState = crossfadeStateValue;
      });
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> queue() async {
    try {
      await SpotifySdk.queue(
          spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> toggleRepeat() async {
    try {
      await SpotifySdk.toggleRepeat();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> setRepeatMode(RepeatMode repeatMode) async {
    try {
      await SpotifySdk.setRepeatMode(
        repeatMode: repeatMode,
      );
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> setShuffle(bool shuffle) async {
    try {
      await SpotifySdk.setShuffle(
        shuffle: shuffle,
      );
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> toggleShuffle() async {
    try {
      await SpotifySdk.toggleShuffle();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> play() async {
    try {
      await SpotifySdk.play(spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> pause() async {
    try {
      await SpotifySdk.pause();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> resume() async {
    try {
      await SpotifySdk.resume();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> skipNext() async {
    try {
      await SpotifySdk.skipNext();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> skipPrevious() async {
    try {
      await SpotifySdk.skipPrevious();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> seekTo() async {
    try {
      await SpotifySdk.seekTo(positionedMilliseconds: 20000);
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> seekToRelative() async {
    try {
      await SpotifySdk.seekToRelativePosition(relativeMilliseconds: 20000);
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> checkIfAppIsActive(BuildContext context) async {
    try {
      var isActive = await SpotifySdk.isSpotifyAppActive;
      final snackBar = SnackBar(
          content: Text(isActive
              ? 'Spotify app connection is active (currently playing)'
              : 'Spotify app connection is not active (currently not playing)'));

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  void setStatus(String code, {String? message}) {
    var text = message ?? '';
    _logger.i('$code$text');
  }
}
