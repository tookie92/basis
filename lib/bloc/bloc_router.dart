import 'package:berlin/bloc/bloc_home.dart';
import 'package:berlin/bloc/bloc_provider.dart';
import 'package:berlin/main.dart';

class BlocRouter {
  BlocProvider home() =>
      BlocProvider<BlocHome>(bloc: BlocHome(), child: MyHomePage());
}
