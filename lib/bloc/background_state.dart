part of 'background_bloc.dart';

@immutable
abstract class BackgroundState {
  const BackgroundState();

  @override
  List<Object?> get props => [];
}

class BackgroundInitial extends BackgroundState {}

class BackgroundSuccessState extends BackgroundState {
  late NetworkImage? image;

  BackgroundSuccessState({required this.image});
  @override
  List<NetworkImage?> get props => [image];
}

class BackgroundFailureState extends BackgroundState {
  final String errorMsg;

  BackgroundFailureState({required this.errorMsg});
  @override
  List<String?> get props => [errorMsg];
}
