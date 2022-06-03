import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

//const soundAudioPath = "bellsound.mp3";
class SoundBell extends StatelessWidget {
 static AudioCache player = new AudioCache();
 void playsound(){
   player.play("bellsound.mp3");
   print('it work?');
 }
 Future<AudioPlayer> playLocalAsset() async {
    AudioCache cache = new AudioCache();
   //At the next line, DO NOT pass the entire reference such as assets/yes.mp3. This will not work.
   //Just pass the file name only.
    return await cache.play("bellsound.mp3"); 
}
  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: ()=>playLocalAsset(), icon: Icon(Icons.play_arrow_rounded));
  }
}