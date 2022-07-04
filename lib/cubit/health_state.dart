part of 'health_cubit.dart';

abstract class HealthState extends Equatable {
  const HealthState();

  @override
  List<Object> get props => [];
}

class HealthInitial extends HealthState {}

class HealthLoading extends HealthState {}

class HealthSuccess extends HealthState {
  final List<HealthDataPoint> health;

  const HealthSuccess(this.health);

  @override
  List<Object> get props => [health];
}

class HealthFailed extends HealthState {
  final String error;

  const HealthFailed(this.error);

  @override
  List<Object> get props => [error];
}
