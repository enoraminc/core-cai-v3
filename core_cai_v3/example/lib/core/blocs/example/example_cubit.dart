import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/data.dart';

part 'example_state.dart';

class ExampleCubit extends Cubit<ExampleState> {
  ExampleCubit() : super(ExampleInitial());

  void changeSelectedData(ExampleData data) {
    emit(ChangeSelectedData(selectedData: data));
  }
}
