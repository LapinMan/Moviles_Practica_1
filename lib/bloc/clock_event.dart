part of 'clock_bloc.dart';

abstract class ClockEvent {
  const ClockEvent();
  @override
  List<Object?> get props => [];
}

class ClockUpdateEvent extends ClockEvent {}
