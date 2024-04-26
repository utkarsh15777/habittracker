import 'package:flutter/material.dart';
import 'package:habittracker/models/app_settings.dart';
import 'package:habittracker/models/habbit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabbitDatabase extends ChangeNotifier{
  static late Isar isar;
  final List<Habbit> currentHabbits = [];

  static Future<void> initialize() async{
    final dir = await getApplicationCacheDirectory();
    isar = await Isar.open(
      [HabbitSchema,AppSettingsSchema], 
      directory: dir.path
    ); 
  }

  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();

    if(existingSettings ==  null){
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  Future<DateTime?> getFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    return existingSettings?.firstLaunchDate;
  }

  Future<void> addHabbit(String habbitName) async {
    final newHabbit = Habbit();
    newHabbit.name = habbitName;
    await isar.writeTxn(() => isar.habbits.put(newHabbit));
    readHabbits();
  }

  Future<void> readHabbits() async {
    List<Habbit> fetchedHabbits = await isar.habbits.where().findAll();
    currentHabbits.clear();
    currentHabbits.addAll(fetchedHabbits);
    notifyListeners();
  }

  Future<void> updateHabbitCompletion(int id, bool isCompleted) async {
    final habbit = await isar.habbits.get(id);
    if(habbit != null){
      await isar.writeTxn(() async {
        if(isCompleted && !habbit.completedDays.contains(DateTime.now())){
          final today = DateTime.now();
          habbit.completedDays.add(
            DateTime(
              today.year,
              today.month,
              today.day
            )
          );
        }else{
          habbit.completedDays.removeWhere((date) => date.year == DateTime.now().year && date.month == DateTime.now().month && date.day == DateTime.now().day);
        }
        await isar.habbits.put(habbit);
      });
    }
    readHabbits();
  }

  Future<void> updateHabbitName(int id, String newName) async {
    final habbit = await isar.habbits.get(id);
    if(habbit != null){
      await isar.writeTxn(() async {
        habbit.name = newName;
        await isar.habbits.put(habbit);
      });
    }
    readHabbits();
  }

  Future<void> deleteHabbit(int id) async {
    final habbit = await isar.habbits.get(id);
    if(habbit != null){
      await isar.writeTxn(() async {
        await isar.habbits.delete(id);
      });
    }
    readHabbits();
  }
}