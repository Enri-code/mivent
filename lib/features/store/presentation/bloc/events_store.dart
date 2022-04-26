import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mivent/features/store/presentation/bloc/base_bloc/bloc.dart';

mixin EventStore on Bloc<StoreEvent, StoreState> {}
