import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/layout/todo_app/cubit/states.dart';

import '../../../modules/done_tasks/archived_tasks/archived_tasks_screen.dart';
import '../../../modules/done_tasks/done_tasks_screen.dart';
import '../../../modules/done_tasks/new_tasks/new_tasks_screen.dart';


class AppCubit extends Cubit<AppStates>
{
  AppCubit () : super (AppInitialState()) ;

  static AppCubit get(context) => BlocProvider.of(context ) ;

  int currentIndex = 0;

  List<Widget> screens =
  [
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen(),
  ];

  List<String> titles =
  [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  Database? database;

  List<Map> newTasks = [] ;
  List<Map> doneTasks = [] ;
  List<Map> archivedTasks= [] ;



  void changeIndex ( int index)
  {
    currentIndex = index ;
    emit(AppBottomNavBarState());
  }



  void createDataBase() {
     openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
            'create Table tasks (id integer primary key , title text ,date text ,time text, status text )')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error when create table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database) ;

        print('database opened');
      },
    ).then((value)
     {
       database =value ;
       emit(AppCreateDatabaseState()) ;
     });
  }



  // method to insert to Database
  Future  insertToDatabase
      ( {
    required String title ,
    required String date ,
    required String time ,

  }) async {
    return await database?.transaction((txn) {
      txn
          .rawInsert(
          'Insert into tasks (title , date, time, status) values ("$title" , "$date" , "$time" , "new")')
          .then((value) {
        print('$value is insert successfully ');
      }).catchError((error) {
        print('error when inserting ${error.toString()}');
      });

      return Future.value();
    }).then((value)
    {
      emit(AppInsertDatabaseState()) ;

      getDataFromDatabase(database) ;

    });
  }


   getDataFromDatabase (database)
  {
     newTasks=[];
     doneTasks=[];
     archivedTasks=[];
     emit(AppLoadingState()) ;
     database?.rawQuery('Select * From tasks  ')
         .then((value)
     {

       for (var element in value) {
         String status = element['status'].toString().trim().toLowerCase();

         if (status == 'new') {
           newTasks.add(element);
         } else if (status == 'done') {
           doneTasks.add(element);
         } else {
           archivedTasks.add(element);
         }
       }
      // trim() :removes any leading or trailing spaces in the status value.
    // toLowerCase():  ensures that the comparison is case-insensitive (e.g., it will match 'Done', 'done', 'DONE', etc.).



       // newTasks=value ;
     print(newTasks);
     print(doneTasks);
     print(archivedTasks);

      //print(tasksList[0]['title']);

      emit(AppGetDatabaseState()) ;
     } );

  }


   updateDatabase ({
    required int id ,
    required String status,
}) async
  {
    database!.rawUpdate(
        'UPDATE tasks SET status = ?  WHERE id = ? ',
        [' $status', id]).then((value)
    {
      getDataFromDatabase(database) ;
      emit(AppUpdateDatabaseState()) ;
    } );

  }

  void deleteDatabase({
    required int id ,
})
  {
    database!.rawDelete('DELETE FROM tasks WHERE id =? ' ,
       [id]).then((value)
    {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    }) ;
  }


  bool isBottomSheetShown = false;

  IconData fabIcon = Icons.edit;

  void changeBottomSheetState ({
    required bool isShow ,
    required IconData icon ,
})
  {
    isBottomSheetShown = isShow ;
    fabIcon = icon ;
    emit(AppBottomSheetState()) ;
  }


}