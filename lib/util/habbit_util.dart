import 'package:habittracker/models/habbit.dart';

bool isHabbitCompletedToday(List<DateTime> completedDays){
  final today = DateTime.now();
  return completedDays.any((date) => 
    date.year == today.year && date.month == today.month && date.day == today.day
  );
}

Map<DateTime, int> prepareMapDataSet(List<Habbit> habbits){
  Map<DateTime, int> datasets = {};

  for(var habbit in habbits){
    for(var date in habbit.completedDays){
      final normalizedDate = DateTime(date.year, date.month, date.day);
      if(datasets.containsKey(normalizedDate)){
        datasets[normalizedDate] = datasets[normalizedDate]! + 1;
      }else{
        datasets[normalizedDate] = 1;
      }
    }
  }

  return datasets;

}