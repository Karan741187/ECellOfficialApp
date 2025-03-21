import 'package:flutter/material.dart';
import 'package:ecellapp/core/res/colors.dart';
import 'package:ecellapp/core/res/strings.dart';
import 'package:ecellapp/models/speaker.dart';

import '../../widgets/UI2023widgets/HomeScreen.dart';

class SpeakerCard extends StatelessWidget {
  final Speaker? speaker;

  const SpeakerCard({Key? key, this.speaker}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double ratio = MediaQuery.of(context).size.aspectRatio;
    double height = MediaQuery.of(context).size.height;
    print(speaker);
    return SpeakerImageSection(
      height: height,
      image: S.assetSpeakerBackdrop,
      speaker: speaker!,
      elementColor: C.menuButtonColor,
      gradientColor: C.backgroundTop,
    );
  }
}
