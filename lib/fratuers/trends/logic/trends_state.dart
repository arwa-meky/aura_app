abstract class TrendsState {}

class TrendsInitial extends TrendsState {}

class TrendsLoading extends TrendsState {}

class TrendsLoaded extends TrendsState {}

class TrendsError extends TrendsState {
  final String error;
  TrendsError(this.error);
}
