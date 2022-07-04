part of 'blood_oxygen_cubit.dart';

abstract class BloodOxygenState extends Equatable {
  const BloodOxygenState();

  @override
  List<Object> get props => [];
}

class BloodOxygenInitial extends BloodOxygenState {}

class BloodOxygenLoading extends BloodOxygenState {}

class BloodOxygenSuccess extends BloodOxygenState {
  final List<HealthDataPoint> bloodOxygen;

  const BloodOxygenSuccess(this.bloodOxygen);

  @override
  List<Object> get props => [bloodOxygen];
}

class BloodOxygenFailed extends BloodOxygenState {
  final String error;

  const BloodOxygenFailed(this.error);

  @override
  List<Object> get props => [error];
}
