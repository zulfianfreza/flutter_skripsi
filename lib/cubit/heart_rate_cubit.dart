import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:health/health.dart';
import 'package:skripsi/services/health_service.dart';

part 'heart_rate_state.dart';

class HeartRateCubit extends Cubit<HeartRateState> {
  HeartRateCubit() : super(HeartRateInitial());

  Future<void> getHeartRate({
    required DateTime now,
    required DateTime yesterday,
    required List<HealthDataType> types,
  }) async {
    emit(HeartRateLoading());

    List<HealthDataPoint> heartRate =
        await HealthService().fetchData(now, yesterday, types);

    emit(HeartRateSuccess(heartRate));
  }
}
