part of 'quotebloc_bloc.dart';

abstract class QuoteblocEvent {
  const QuoteblocEvent();
  @override
  List<Object?> get props => [];
}

class QuoteUpdateEvent extends QuoteblocEvent {}
