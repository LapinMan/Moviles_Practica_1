part of 'quotebloc_bloc.dart';

@immutable
abstract class QuoteblocState {
  const QuoteblocState();

  @override
  List<Object?> get props => [];
}

class QuoteblocInitial extends QuoteblocState {}

class QuoteblocErrorState extends QuoteblocState {
  final String errorMsg;

  QuoteblocErrorState({required this.errorMsg});
  @override
  List<String?> get props => [errorMsg];
}

class QuoteblocSuccessState extends QuoteblocState {
  var data;

  QuoteblocSuccessState({required this.data});
  @override
  List<Object?> get props => [data];
}
