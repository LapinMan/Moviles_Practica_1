part of 'background_bloc.dart';

abstract class BackgroundEvent {
  const BackgroundEvent();
  @override
  List<Object?> get props => [];
}

class BackgroundEventUpdate extends BackgroundEvent {}
