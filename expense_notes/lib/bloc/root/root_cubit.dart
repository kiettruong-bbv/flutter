import 'package:expense_notes/bloc/root/root_state.dart';
import 'package:expense_notes/constants/storage_key.dart';
import 'package:expense_notes/utils/storage_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RootCubit extends Cubit<RootState> {
  RootCubit() : super(Uninitialized());

  Future initRoot() async {
    final String? auth = await StorageUtils.getItem(StorageKey.auth);
    bool isAuthenticated = auth != null;

    if (isAuthenticated) {
      emit(Authenticated());
    } else {
      emit(Unauthenticated());
    }
  }

  void onAuthenticated() {
    emit(Authenticated());
  }

  Future signOut() async {
    await StorageUtils.deleteItem(StorageKey.auth);
    emit(Unauthenticated());
  }
}
