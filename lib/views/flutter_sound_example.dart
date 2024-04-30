import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AoudiPlayerTestView extends StatefulWidget {
  const AoudiPlayerTestView({super.key});

  @override
  State<AoudiPlayerTestView> createState() => _AoudiPlayerTestViewState();
}

class _AoudiPlayerTestViewState extends State<AoudiPlayerTestView>
    with TickerProviderStateMixin {
  late AnimationController _animationIconController1;

  late AudioCache audioCache;

//important
  late AudioPlayer audioPlayer;
  Duration duration = const Duration();
  Duration position = const Duration();

  Duration slider = const Duration(seconds: 0);

  late double durationvalue;

  bool issongplaying = false;
  @override
  void initState() {
    super.initState();
    position = slider;
    _animationIconController1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
      reverseDuration: const Duration(milliseconds: 750),
    );
    audioPlayer = AudioPlayer();
    audioCache = AudioCache();
// To update new playing state

    audioPlayer.onPlayerStateChanged.listen((event) {
      issongplaying = event == PlayerState.playing;
      setState(() {});
    });

// To update new duration
    audioPlayer.onDurationChanged.listen((newDuration) {
      duration = newDuration;
      setState(() {});
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      position = newPosition;
      setState(() {});
    });
    audioPlayer.onPlayerComplete.listen((event) {
      issongplaying = true;
      _animationIconController1.reverse();
    });
    setAudio();
  }

  setAudio() async {
    var url =
        'https://everyayah.com/data/Alafasy_128kbps/002003.mp3'; //"https://on.soundcloud.com/BvXufZW1UWhsWQFz6";
    // await audioPlayer.setSourceUrl((url));
    await audioPlayer.play(UrlSource(url));

    _animationIconController1.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ClipOval(
              child: Image(
                image: const NetworkImage(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSho3GhEd21-EjJ-LwGQmlyilk0miEKGeEKJoUgQC6Mig&s"),
                width: (MediaQuery.of(context).size.width) - 200,
                height: (MediaQuery.of(context).size.width) - 200,
                fit: BoxFit.fill,
              ),
            ),
            Slider(
              activeColor: Colors.white,
              inactiveColor: Colors.grey,
              value: position.inSeconds.toDouble(),
              max: duration.inSeconds.toDouble(),
              onChanged: (double value) async {
                final position = Duration(seconds: value.toInt());
                await audioPlayer.seek(position);
                await audioPlayer.resume();
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "$position",
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                  "${duration - position}",
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(
                  Icons.navigate_before,
                  size: 55,
                  color: Colors.white,
                ),
                GestureDetector(
                  onTap: () async {
                    setState(
                      () {
                        if (issongplaying) {
                          audioPlayer.pause();
                        } else {
                          audioPlayer.resume();
                        }
                        issongplaying
                            ? _animationIconController1.reverse()
                            : _animationIconController1.forward();
                        issongplaying = !issongplaying;
                      },
                    );
                  },
                  child: ClipOval(
                    child: Container(
                      color: Colors.pink[600],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AnimatedIcon(
                          icon: AnimatedIcons.play_pause,
                          size: 55,
                          progress: _animationIconController1,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const Icon(
                  Icons.navigate_next,
                  size: 55,
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
