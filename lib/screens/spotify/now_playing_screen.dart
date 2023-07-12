import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/crossfade_state.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/player_context.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:travel_planner_app_cs_project/widgets/sized_icon_button.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({
    Key? key,
    // required this.closeOpen,
  }) : super(key: key);
  // final VoidCallback closeOpen;

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
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
          return Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(stops: const [
                0.4,
                //0.4,
                1
              ], colors: [
                Color.fromRGBO(255, 69, 91, 1),
                Colors.black.withOpacity(0.00001)
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Scaffold(
                  //backgroundColor: nowPlaying["playerColor"],
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    leading: IconButton(
                      onPressed: () {
                        // widget.closeOpen();
                      },
                      icon: const FaIcon(
                        FontAwesomeIcons.chevronDown,
                        size: 16,
                      ),
                    ),
                    // title: Text(
                    //   track.album.name,
                    //   style: const TextStyle(fontSize: 14, color: Colors.white70),
                    // ),
                    actions: [
                      _connected
                          ? IconButton(
                              onPressed: disconnect,
                              icon: const Icon(Icons.exit_to_app,color: Colors.white),
                            )
                          : Container()
                    ],
                  ),
                  body: _sampleFlowWidget(context),
                ),
              ));
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

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: _connected
                      ? spotifyImageWidget(track.imageUri)
                      : const Text('Connect to see an image...'),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.loose,
              child: Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 20),
                      child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            '${track.name}',
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                          subtitle: Text(
                            '${track.artist.name}',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white60),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                isLiked = !isLiked;
                              });
                            },
                            icon: isLiked
                                ? FaIcon(
                                    FontAwesomeIcons.heart,
                                    size: 16,
                                    color: Theme.of(context).primaryColor,
                                  )
                                : const FaIcon(
                                    FontAwesomeIcons.heart,
                                    size: 16,
                                    color: Colors.white54,
                                  ),
                          )),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SliderTheme(
                        data: const SliderThemeData(
                            trackHeight: 3,
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 6)),
                        child: Slider(
                          activeColor: Colors.white,
                          inactiveColor: Colors.white30,
                          divisions: 100,
                          value: 20,
                          onChanged: (value) {},
                          min: 0,
                          max: 100,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${playerState.playbackPosition} ms',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white54),
                              ),
                            ),
                            Text(
                              '${track.duration} ms',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.white54),
                            )
                          ],
                        )),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () => skipNext,
                              icon: FaIcon(
                                FontAwesomeIcons.forward,
                                size: 16,
                                color: Colors.white54,
                              ),
                            ),
                            IconButton(
                              onPressed: () => skipPrevious,
                              icon: FaIcon(
                                FontAwesomeIcons.backward,
                                size: 16,
                                color: Colors.white54,
                              ),
                            ),
                            playerState.isPaused
                                ? IconButton(
                                    onPressed: () => resume,
                                    icon: FaIcon(
                                      FontAwesomeIcons.play,
                                      size: 16,
                                      color: Colors.white54,
                                    ),
                                  )
                                : IconButton(
                                    onPressed: () => pause,
                                    icon: FaIcon(
                                      FontAwesomeIcons.pause,
                                      size: 16,
                                      color: Colors.white54,
                                    ),
                                  ),
                            // IconButton(
                            //   onPressed: () {},
                            //   icon: const Icon(FluentIcons.next_20_filled),
                            //   iconSize: 28,
                            // ),
                            IconButton(
                              onPressed: () {},
                              icon: FaIcon(
                                FontAwesomeIcons.random,
                                size: 16,
                                color: Colors.white54,
                              ),
                            )
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

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Title: ${playerContext.title}'),
            Text('Subtitle: ${playerContext.subtitle}'),
            Text('Type: ${playerContext.type}'),
            Text('Uri: ${playerContext.uri}'),
          ],
        );
      },
    );
  }

  Widget _sampleFlowWidget(BuildContext context2) {
    return SizedBox(
      height: MediaQuery.of(context2).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _loading
              ? Container(
                  color: Colors.black12,
                  child: const Center(child: CircularProgressIndicator()))
              : const SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextButton(
                onPressed: connectToSpotifyRemote,
                child: const Icon(Icons.settings_remote),
              ),
              TextButton(
                onPressed: getAccessToken,
                child: const Text('get auth token '),
              ),
            ],
          ),
          _connected
              ? _buildPlayerStateWidget()
              : const Center(
                  child: Text('Not connected'),
                ),
        ],
      ),
    );
  }

  Widget spotifyImageWidget(ImageUri image) {
    return FutureBuilder(
        future: SpotifySdk.getImage(
          imageUri: image,
          dimension: ImageDimension.medium,
        ),
        builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          if (snapshot.hasData) {
            return Image.memory(snapshot.data!);
          } else if (snapshot.hasError) {
            setStatus(snapshot.error.toString());
            return SizedBox(
              width: ImageDimension.large.value.toDouble(),
              height: ImageDimension.large.value.toDouble(),
              child: const Center(child: Text('Error getting image')),
            );
          } else {
            return SizedBox(
              width: ImageDimension.large.value.toDouble(),
              height: ImageDimension.large.value.toDouble(),
              child: const Center(child: CircularProgressIndicator()),
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

  Future<void> addToLibrary() async {
    try {
      await SpotifySdk.addToLibrary(
          spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
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
