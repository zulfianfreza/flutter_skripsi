import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:health/health.dart';
import 'package:skripsi/services/health_service.dart';

part 'blood_oxygen_state.dart';

class BloodOxygenCubit extends Cubit<BloodOxygenState> {
  BloodOxygenCubit() : super(BloodOxygenInitial());

  Future<void> getBloodOxygen({
    required DateTime now,
    required DateTime yesterday,
    required List<HealthDataType> types,
  }) async {
    emit(BloodOxygenLoading());

    List<HealthDataPoint> bloodOxygen =
        await HealthService().fetchData(now, yesterday, types);

    emit(BloodOxygenSuccess(bloodOxygen));
  }
}
