import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension BlocContextProvider on BuildContext {
  E bloc<E extends StateStreamableSource<Object?>>() {
    return BlocProvider.of<E>(this);
  }
}
