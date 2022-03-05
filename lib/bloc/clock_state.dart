part of 'clock_bloc.dart';

@immutable
abstract class ClockState {
  const ClockState();

  @override
  List<Object?> get props => [];
}

class ClockInitial extends ClockState {}

class ClockErrorState extends ClockState {
  final String errorMsg;

  ClockErrorState({required this.errorMsg});
  @override
  List<String?> get props => [errorMsg];
}

class ClockSuccessState extends ClockState {
  final String data;

  ClockSuccessState({required this.data});
  @override
  List<String?> get props => [data];
}
