part of 'example_cubit.dart';

abstract class ExampleState extends Equatable {
  final ExampleData? selectedData;
  const ExampleState({
    required this.selectedData,
  });

  @override
  List<Object?> get props => [
        selectedData,
      ];
}

class ExampleInitial extends ExampleState {
  ExampleInitial() : super(selectedData: null);
}

class ChangeSelectedData extends ExampleState {
  ChangeSelectedData({required super.selectedData});
}
