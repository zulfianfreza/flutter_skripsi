import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:health/health.dart';
import 'package:skripsi/services/health_service.dart';

part 'health_state.dart';

class HealthCubit extends Cubit<HealthState> {
  HealthCubit() : super(HealthInitial());

  Future<void> getHeartRate({
    required DateTime now,
    required DateTime yesterday,
    required List<HealthDataType> types,
  }) async {
    emit(HealthLoading());

    List<HealthDataPoint> health =
        await HealthService().fetchData(now, yesterday, types);

    emit(HealthSuccess(health));
  }

  Future<void> getBloodOxygen({
    required DateTime now,
    required DateTime yesterday,
    required List<HealthDataType> types,
  }) async {
    emit(HealthLoading());

    List<HealthDataPoint> health =
        await HealthService().fetchData(now, yesterday, types);
    emit(HealthSuccess(health));
  }
}
