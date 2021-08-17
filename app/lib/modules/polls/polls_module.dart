import 'package:flutter/material.dart';

import '../../core/module/module.dart';

/*

Poll:

title
description

option
votesPerPlayer
 */

@Module('poll')
class PollsModule {
  @ModuleItem('poll')
  ContentSegment? getPoll(BuildContext context, String? id) {}
}
