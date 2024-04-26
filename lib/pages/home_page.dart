import 'package:flutter/material.dart';
import 'package:habittracker/components/drawer.dart';
import 'package:habittracker/components/habbit_tile.dart';
import 'package:habittracker/components/heat_map.dart';
import 'package:habittracker/database/habbit_database.dart';
import 'package:habittracker/models/habbit.dart';
import 'package:habittracker/util/habbit_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<HabbitDatabase>(context, listen: false).readHabbits();
  }

  final TextEditingController textController = TextEditingController();

  void createNewHabbit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: "Enter the habbit name"),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              String habbitName = textController.text;
              context.read<HabbitDatabase>().addHabbit(habbitName);
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text("Save"),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text("Cancel"),
          )
        ],
      ),
    );
  }

  void checkHabbitOnOff(bool? value, Habbit habbit) {
    if (value != null) {
      context.read<HabbitDatabase>().updateHabbitCompletion(habbit.id, value);
    }
  }

  void editHabbitBox(Habbit habbit) {
    textController.text = habbit.name;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              String habbitName = textController.text;
              context
                  .read<HabbitDatabase>()
                  .updateHabbitName(habbit.id, habbitName);
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text("Save"),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text("Cancel"),
          )
        ],
      ),
    );
  }

  void deleteHabbitBox(Habbit habbit) {
    textController.text = habbit.name;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure you want to delete ?"),
        content: TextField(
          controller: textController,
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              context.read<HabbitDatabase>().deleteHabbit(habbit.id);
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text("Delete"),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabbit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      body: ListView(
        children: [
          _buildHeatMap(),
          _buildHabbitList()
        ],
      ),
    );
  }

  Widget _buildHeatMap() {

    final habbitDatabase = context.watch<HabbitDatabase>();

    List<Habbit> currentHabbits = habbitDatabase.currentHabbits;

    return FutureBuilder<DateTime?>(
      future: habbitDatabase.getFirstLaunchDate(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return MyHeatMap(
            startDate: snapshot.data!,
            datasets: prepareMapDataSet(currentHabbits),
          );
        }else{
          return Container();
        }
      },
    );
  }

  Widget _buildHabbitList() {
    final habbitDatabase = context.watch<HabbitDatabase>();

    List<Habbit> currentHabbits = habbitDatabase.currentHabbits;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: currentHabbits.length,
      itemBuilder: (context, index) {
        final habbit = currentHabbits[index];
        bool isCompletedToday = isHabbitCompletedToday(habbit.completedDays);
        return HabbitTile(
          isCompletetd: isCompletedToday,
          text: habbit.name,
          onChanged: (value) => checkHabbitOnOff(value, habbit),
          editPressed: (context) => editHabbitBox(habbit),
          deletePressed: (context) => editHabbitBox(habbit),
        );
      },
    );
  }
}
