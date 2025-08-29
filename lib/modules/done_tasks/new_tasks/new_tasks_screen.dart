import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/layout/todo_app/cubit/cubit.dart';
import 'package:todo_app/layout/todo_app/cubit/states.dart';
import 'package:todo_app/shared/components/components.dart';


class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit , AppStates>
      (
      listener: (context , state) {},
      builder:  (context , state)
      {
        var tasks = AppCubit.get(context).newTasks ;

        return TaskBuilder(tasks: tasks);
      },

    );
  }
}
