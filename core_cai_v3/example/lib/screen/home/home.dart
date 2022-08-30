import 'dart:typed_data';

import 'package:core_cai_v3/base/base_chat_screen.dart';
import 'package:core_cai_v3/functions/custom_function.dart';
import 'package:core_cai_v3/model/chat_user.dart';
import 'package:core_cai_v3/widgets/chat_item_screen.dart';
import 'package:core_cai_v3/widgets/chat_message/chat_message_header.dart';
import 'package:example/core/blocs/example/example_cubit.dart';
import 'package:example/core/model/data.dart';
import 'package:flutter/material.dart';
import 'package:core_cai_v3/base/base_cai_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import '../../core/blocs/main_screen/main_screen_bloc.dart';
import '../../core/blocs/sidebar/sidebar_bloc.dart';
import '../../core/utils/app_colors.dart';

part 'ui/home_screen.dart';

part 'widget/sidebar_list_widget.dart';
part 'widget/main_chat_screen.dart';
