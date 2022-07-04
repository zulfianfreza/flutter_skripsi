part of 'heart_rate_cubit.dart';

abstract class HeartRateState extends Equatable {
  const HeartRateState();

  @override
  List<Object> get props => [];
}

class HeartRateInitial extends HeartRateState {}

class HeartRateLoading extends HeartRateState {}

class HeartRateSuccess extends HeartRateState {
  final List<HealthDataPoint> heartRate;

  const HeartRateSuccess(this.heartRate);

  @override
  List<Object> get props => [heartRate];
}

class HeartRateFailed extends HeartRateState {
  final String error;

  const HeartRateFailed(this.error);

  @override
  List<Object> get props => [error];
}
