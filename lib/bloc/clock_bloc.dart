import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart';

import 'package:meta/meta.dart';

part 'clock_event.dart';
part 'clock_state.dart';

class ClockBloc extends Bloc<ClockEvent, ClockState> {
  String countryCode = "America/Mexico_City";
  ClockBloc() : super(ClockInitial()) {
    on<ClockUpdateEvent>(_clock_update);
  }

  void _clock_update(ClockUpdateEvent event, Emitter emit) async {
    try {
      Response? data = await _getData();
      if (data != null && data.statusCode == 200) {
        var result = jsonDecode(data.body);
        String datetime = result["datetime"].toString();
        datetime = datetime.substring(11, 19);
        emit(ClockSuccessState(data: datetime));
      } else {
        emit(ClockErrorState(errorMsg: "Received Null"));
      }
    } catch (e) {
      print(e);

      emit(ClockErrorState(errorMsg: "An unknown error has happened"));
    }
  }

  Future<Response?> _getData() async {
    final String url = "http://worldtimeapi.org/api/timezone/${countryCode}";
    try {
      var response = await get(Uri.parse(url));
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
