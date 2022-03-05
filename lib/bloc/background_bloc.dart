import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

part 'background_event.dart';
part 'background_state.dart';

class BackgroundBloc extends Bloc<BackgroundEvent, BackgroundState> {
  BackgroundBloc() : super(BackgroundInitial()) {
    on<BackgroundEventUpdate>(_background_update);
  }

  void _background_update(BackgroundEventUpdate event, Emitter emit) async {
    NetworkImage? img = await get_data();
    print("Running Background Event Update");
    if (img != null) {
      emit(BackgroundSuccessState(image: img));
    } else {
      emit(BackgroundFailureState(errorMsg: "Got nothing"));
    }
  }

  Future<NetworkImage?> get_data() async {
    print("fetching image");
    int seed = Random().nextInt(999);
    String url = "http://picsum.photos/seed/${seed}/400/600/";
    try {
      NetworkImage img = NetworkImage(url);
      if (img == null) {
        print("Returned null");
      }
      return img;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
