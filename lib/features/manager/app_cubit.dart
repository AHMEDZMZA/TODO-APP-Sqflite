import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/network/sql_database.dart';
import '../data/database_model.dart';
part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(GetDataInitial());

  getData() async {
    emit(GetDataLoading());
    try {
      await createDatabase();
      final tasks = await getDatabase();
      final data =
          tasks.map((e) {
            return DatabaseModel.fromMap(e);
          }).toList();
      emit(GetDataSuccess(data));
    } catch (e) {
      emit(GetDataError(e.toString()));
    }
  }

  editData(DatabaseModel model) async {
    emit(GetDataLoading());
    try {
      await editDatabase(model);
      final tasks = await getDatabase();
      final data =
          tasks.map((e) {
            return DatabaseModel.fromMap(e);
          }).toList();
      emit(GetDataSuccess(data));
    } catch (e) {
      emit(GetDataError(e.toString()));
    }
  }

  removeData(int? id) async {
    emit(GetDataLoading());
    try {
      await deleteDatabase(id);
      final allTasks = await getDatabase();
      final data = allTasks.map((e) => DatabaseModel.fromMap(e)).toList();
      emit(GetDataSuccess(data));
    } catch (e) {
      emit(GetDataError(e.toString()));
    }
  }
}
