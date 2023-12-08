import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mindful Meal Timer',
      home: const MyHomePage(title: 'Mindful Meal Timer'),
      themeMode: ThemeMode.system,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int _duration = 30;
  final CountDownController _controller = CountDownController();
  final _audioPlayer = AudioPlayer();
  bool _isSoundOn = true;

  @override
  void inintState(){
    super.initState();
    _playAudio();
  }
  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(widget.title!),
        ),
      ),
      body: Center( // Wrap the Column with Center widget
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Time to eat mindfully',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center, // Align the text to the center
            ),
            Text(
              'It\'s simple: eat slowly for ten minutes, rest for five, then finish your meal',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.center, // Align the text to the center
            ),
            SizedBox(height: 20),
            Center(
              child: CircularCountDownTimer(
                duration: _duration,
                initialDuration: 0,
                controller: _controller,
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 2,
                ringColor: Colors.grey[300]!,
                fillColor: Colors.green,
                backgroundColor: Colors.grey,
                strokeWidth: 20.0,
                strokeCap: StrokeCap.round,
                textStyle: const TextStyle(
                  fontSize: 33.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textFormat: CountdownTextFormat.S,
                isReverse: true,
                isReverseAnimation: true,
                isTimerTextShown: true,
                autoStart: false,
                onStart: () {
                  debugPrint('Countdown Started');
                  if (_isSoundOn) {
                    // Play sound when countdown starts
                    // Add your sound playing logic here
                  }
                },
                onComplete: () {
                  debugPrint('Countdown Ended');
                  if (_isSoundOn) {
                    // Play sound when countdown ends
                    // Add your sound playing logic here
                  }
                },
                onChange: (String elapsed) {
                  // Parse the elapsed time string to a Duration
                  Duration remainingTime = Duration(seconds: int.parse(elapsed));

                  // Access _duration from the surrounding class or widget
                  if (_duration - remainingTime.inSeconds <= 5) {
                    // Play audio file
                    _playAudio();
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sound ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch(
                  value: _isSoundOn,
                  onChanged: (value) {
                    setState(() {
                      _isSoundOn = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: 150,
              height: 60,
              child: _button(title: "Start", onPressed: () => _controller.start()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _button({required String title, VoidCallback? onPressed}) {
    return ElevatedButton(
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.lightGreen),
      ),
      onPressed: onPressed,
    );
  }
  Future<void> _playAudio() async {
    try {
      await _audioPlayer.play(UrlSource('audio/countdown_tick.mp3'));
    }
    catch (e) {
      debugPrint("Error playing audio: $e");
    }
  }
}
