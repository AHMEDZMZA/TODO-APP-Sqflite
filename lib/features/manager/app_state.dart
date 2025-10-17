part of 'app_cubit.dart';

@immutable
sealed class AppState {}

final class GetDataInitial extends AppState {}

final class GetDataLoading extends AppState {}

final class GetDataSuccess extends AppState {
  final List<DatabaseModel> databaseModel;
  GetDataSuccess(this.databaseModel);
}

final class GetDataError extends AppState {
  final String error;
  GetDataError(this.error);
}
