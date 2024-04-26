import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabbitTile extends StatelessWidget {
  final bool isCompletetd;
  final String text;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? editPressed;
  final void Function(BuildContext)? deletePressed;

  const HabbitTile({super.key, required this.isCompletetd, required this.text, required this.onChanged, required this.editPressed, required this.deletePressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: editPressed,
              backgroundColor: Colors.grey.shade800,
              icon: Icons.settings,
              borderRadius: BorderRadius.circular(8),
            ),
            SlidableAction(
              onPressed: deletePressed,
              backgroundColor: Colors.red.shade800,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            if(onChanged!=null){
              onChanged!(!isCompletetd);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: isCompletetd?Colors.green:Theme.of(context).colorScheme.secondary,
            ),
            padding: const EdgeInsets.all(12),
            child: ListTile(
              title: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isCompletetd?Colors.white:Theme.of(context).colorScheme.inversePrimary
                ),
              ),
              leading: Checkbox(
                activeColor: Colors.green,
                value: isCompletetd,
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ),
    );
  }
}