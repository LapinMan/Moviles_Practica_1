import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

import 'bloc/background_bloc.dart';
import 'bloc/clock_bloc.dart';
import 'bloc/quotebloc_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String flag_url = "https://flagcdn.com/16x12/za.png";
  final _paises = [
    ["Mexico", "mx", "America/Mexico_City"],
    ["Serbia", "rs", "Europe/Belgrade"],
    ["Argentina", "ar", "America/Argentina/Buenos_Aires"],
    ["Canada", "ca", "America/Toronto"],
    ["Brasil", "br", "America/Sao_Paulo"],
    ["Estados Unidos", "us", "America/New_York"],
    ["Gales", "gb", "Europe/London"],
    ["Thailandia", "th", "Asia/Bangkok"]
  ];

  var _selectedTimeZone = "America/Mexico_City";
  var _selectedCountry = "Mexico";

  // ignore: prefer_final_fields
  String _quote =
      "Even among monsters and humans, there are only two types.\nThose who undergo suffering and spread it to others.\nAnd those who avoid giving it to others.";
  String _author = "Alice";

  // ignore: prefer_final_fields
  String _hour = "06:12:15";

  final String default_bg =
      "https://static.wikia.nocookie.net/virtualyoutuber/images/f/f0/GENSOKYOholoismB.jpg";

  @override
  Widget build(BuildContext context) {
    return BackdropScaffold(
      appBar: BackdropAppBar(
        backgroundColor: Colors.pink[800],
        leading: const BackdropToggleButton(
          icon: AnimatedIcons.list_view,
        ),
        title: const Text("Frase del Dia"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.view_array))
        ],
      ),
      backLayer: back_body(),
      stickyFrontLayer: true,
      frontLayer: front_body(),
    );
  }

  BlocListener<ClockBloc, ClockState> back_body() {
    return BlocListener<ClockBloc, ClockState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        child: ListView.builder(
            itemCount: _paises.length,
            itemBuilder: (BuildContext context, int index) {
              return TextButton(
                onPressed: () {
                  _selectedTimeZone = _paises[index][2];
                  _selectedCountry = _paises[index][0];
                  BlocProvider.of<BackgroundBloc>(context)
                      .add(BackgroundEventUpdate());
                  BlocProvider.of<ClockBloc>(context).countryCode =
                      _selectedTimeZone;
                  BlocProvider.of<ClockBloc>(context).add(ClockUpdateEvent());
                  BlocProvider.of<QuoteblocBloc>(context)
                      .add(QuoteUpdateEvent());
                },
                child: ListTile(
                  dense: true,
                  leading: load_flag(index),
                  title: Row(
                    children: [
                      Text(_paises[index][0],
                          style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget load_flag(int index) {
    Image img =
        Image.network("https://flagcdn.com/28x21/${_paises[index][1]}.png",
            errorBuilder: (context, error, stackTrace) {
      return Icon(Icons.flag);
    });
    return img;
  }

  BlocConsumer<BackgroundBloc, BackgroundState> front_body() {
    return BlocConsumer<BackgroundBloc, BackgroundState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        try {
          if (state is BackgroundSuccessState) {
            return _on_success_background(state.image);
          } else if (state is BackgroundFailureState) {
            return _on_failure_background();
          } else {
            return _on_loading_background();
          }
        } catch (e) {
          return _on_loading_background();
        }
      },
    );
  }

  Container _on_loading_background() {
    return Container(
      child: CircularProgressIndicator(),
    );
  }

  Container _on_success_background(image) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: image,
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.7), BlendMode.multiply),
        ),
      ),
      child: _container_body(),
    );
  }

  Container _on_failure_background() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
      ),
    );
  }

  Column _container_body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        hour_widget(),
        quote_widget(),
      ],
    );
  }

  Expanded quote_widget() {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: BlocConsumer<QuoteblocBloc, QuoteblocState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          try {
            if (state is QuoteblocSuccessState) {
              return _on_success_quote(state.data);
            } else if (state is QuoteblocErrorState) {
              return _on_error_quote();
            } else {
              return _on_initial_quote();
            }
          } catch (e) {
            return _on_error_quote();
          }
        },
      ),
    ));
  }

  Padding hour_widget() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 40, 0, 30),
      child: Center(
        child: BlocConsumer<ClockBloc, ClockState>(
          listener: (context, state) {},
          builder: (context, state) {
            try {
              if (state is ClockSuccessState) {
                return _on_success_clock(state.data);
              } else if (state is ClockErrorState) {
                return _on_error_clock();
              } else {
                return Text(
                  "Loading",
                  style: TextStyle(color: Colors.white, fontSize: 40),
                );
              }
            } catch (e) {
              return Text("Loading",
                  style: TextStyle(color: Colors.white, fontSize: 40));
            }
          },
        ),
      ),
    );
  }

  Text _on_error_clock() {
    return Text(
      "Could not retrieve hour",
      style: TextStyle(color: Colors.white, fontSize: 45),
    );
  }

  Column _on_success_clock(hour) {
    return Column(
      children: [
        Text(
          _selectedCountry,
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        Text(
          hour,
          style: TextStyle(color: Colors.white, fontSize: 45),
        ),
      ],
    );
  }

  Center _on_success_quote(data) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data[0]["q"],
              style: TextStyle(color: Colors.white, fontSize: 20)),
          Text(
            "-${data[0]["a"]}",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
    );
  }

  Center _on_error_quote() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_quote, style: TextStyle(color: Colors.white, fontSize: 20)),
          Text(
            "-${_author}",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
    );
  }

  Center _on_initial_quote() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
