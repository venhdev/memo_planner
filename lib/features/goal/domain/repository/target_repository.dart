import '../../../../core/constants/typedef.dart';
import '../entities/target_entity.dart';

abstract class TargetRepository {
  ResultVoid addTarget(TargetEntity target);
  ResultVoid updateTarget(TargetEntity target);
  ResultVoid deleteTarget(TargetEntity target);
  ResultEither<SQuerySnapshot> getTargetStream(String uid);
}
