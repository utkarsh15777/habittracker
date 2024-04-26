import 'package:isar/isar.dart';

// run : dart run build_runner build
part 'habbit.g.dart';
@Collection()
class Habbit {
  Id id = Isar.autoIncrement;

  late String name;

  List<DateTime> completedDays= [];

}