
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/layout/todo_app/cubit/cubit.dart';
import 'package:todo_app/layout/todo_app/cubit/states.dart';

import '../../shared/components/components.dart';

class HomeLayout extends StatelessWidget {
  HomeLayout({super.key});


  final scaffoldKey = GlobalKey<ScaffoldState>();
  final taskController = TextEditingController();
  final timeController = TextEditingController();
  final dateController = TextEditingController();

  final formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) =>
        AppCubit()
          ..createDataBase(),
        child: BlocConsumer<AppCubit, AppStates>
          (
          listener: (BuildContext context, AppStates state) {
            if (state is AppInsertDatabaseState) {
              Navigator.pop(context);
            }
          },
          builder: (BuildContext context, AppStates state) {
            AppCubit cubit = AppCubit.get(context);

            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: Text(
                  cubit.titles[cubit.currentIndex],
                ),

              ),
              body: ConditionalBuilder(
                  condition: state is! AppLoadingState,
                  builder: (context) => cubit.screens[cubit.currentIndex],
                  fallback: (context) =>
                  const Center(child: CircularProgressIndicator())),
              bottomNavigationBar: BottomNavigationBar(
                onTap: (index) {
                  cubit.changeIndex(index);
                },
                currentIndex: cubit.currentIndex,
                elevation: 10.0,
                type: BottomNavigationBarType.fixed,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.menu), label: 'Tasks'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.done), label: 'Done'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive), label: 'Archived'),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (cubit.isBottomSheetShown) {
                    if (formKey.currentState!.validate()) {
                      cubit.insertToDatabase(
                          title: taskController.text,
                          date: dateController.text,
                          time: timeController.text);
                    }
                  } else {
                    scaffoldKey.currentState?.showBottomSheet((context) =>
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultTextForm(
                                    controller: taskController,
                                    keyboardType: TextInputType.text,
                                    label: "Task Title",
                                    prefix: Icons.title,
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return "Task Title can't be empty";
                                      }

                                      return null;
                                    }),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                defaultTextForm(
                                    controller: dateController,
                                    keyboardType: TextInputType.datetime,
                                    label: "Task Date",
                                    prefix: Icons.date_range_outlined,
                                    onTap: () {
                                      showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.parse('2030-12-06')
                                      ).then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return "Task Date can't be empty";
                                      }

                                      return null;
                                    }),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                defaultTextForm(
                                    controller: timeController,
                                    keyboardType: TextInputType.datetime,
                                    label: "Task Time",
                                    prefix: Icons.watch_later_outlined,
                                    onTap: () {
                                      showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now()
                                      ).then((value) {
                                        timeController.text =
                                            value!.format(context).toString();
                                      });
                                    },
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return "Task Time can't be empty";
                                      }

                                      return null;
                                    }),
                              ],
                            ),
                          ),
                        ), elevation: 10.0).closed.then((value) {
                      cubit.changeBottomSheetState(
                          isShow: false, icon: Icons.edit);
                    });

                    cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                  }
                },
                child: Icon(cubit.fabIcon),
              ),
            );
          },

        )
    );
  }


}
