import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/layout/todo_app/cubit/cubit.dart';
import 'package:todo_app/layout/todo_app/cubit/states.dart';
import 'package:todo_app/shared/components/components.dart';



class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit , AppStates>
      (
      listener: (context , state) {},
      builder:  (context , state)
      {
        var tasks = AppCubit.get(context).archivedTasks ;

        return TaskBuilder(tasks: tasks);
      },

    );
  }
}
