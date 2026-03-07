import 'package:Nuweli/app/res/fonts/fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../res/assets/imageassets.dart';
import '../widgets/streaming_wdiget.dart';

class MusicVideo extends StatelessWidget {
  const MusicVideo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "No documentaries available yet.\nComing soon.",
          style: AppTextStyles.montserratBold,
          textAlign: TextAlign.center,
        ),

      ),
    );
  }
}
