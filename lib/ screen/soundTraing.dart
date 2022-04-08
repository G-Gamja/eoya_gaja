import 'package:flutter/material.dart';

import '../widgets/bellSound.dart';

class SoundTraingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SoundBell(),
      ),
    );
  }
}
