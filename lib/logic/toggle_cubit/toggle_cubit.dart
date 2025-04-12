import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

class ToggleCubit extends Cubit<double> {
  ToggleCubit() : super(1);

  refreshScreen() {
    emit(Random().nextDouble());
  }
}
