import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

part 'quotebloc_event.dart';
part 'quotebloc_state.dart';

class QuoteblocBloc extends Bloc<QuoteblocEvent, QuoteblocState> {
  QuoteblocBloc() : super(QuoteblocInitial()) {
    on<QuoteUpdateEvent>(_quote_update);
  }

  void _quote_update(QuoteUpdateEvent event, Emitter emit) async {
    try {
      Response? data = await _getData();
      if (data != null && data.statusCode == 200) {
        var result = jsonDecode(data.body);
        emit(QuoteblocSuccessState(data: result));
      } else {
        emit(QuoteblocErrorState(errorMsg: "Recieved Null"));
      }
    } catch (e) {
      print(e);
      emit(QuoteblocErrorState(errorMsg: "An unknown error has happened"));
    }
  }

  Future<Response?> _getData() async {
    final String _quoteUrl = "https://zenquotes.io/api/random";
    try {
      var response = await get(Uri.parse(_quoteUrl));
      return response != null ? response : null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
