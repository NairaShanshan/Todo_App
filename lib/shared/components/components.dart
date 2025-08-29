
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/layout/todo_app/cubit/cubit.dart';




Widget defaultButton({
  double width = double.infinity, //double.infinity default value (common use)
  Color background = Colors.pink, //Colors.pink  default value   (common use)
  bool isUppercase = true,
  double radius = 0.0,
  double height = 50.0,
  required Function() function,
  required String text,
}) =>
    Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: background, borderRadius: BorderRadius.circular(radius)),
      child:  MaterialButton(
        onPressed: function,
        child: Padding(
          padding:const EdgeInsetsDirectional.symmetric(
            vertical: 5.0,
          ),
          child: Text(
            isUppercase ? text.toUpperCase() : text,
            style:const TextStyle(
              fontSize: 30.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

Widget defaultTextButton({
  required String text ,
  required Function() function ,
  double size = 10,
  FontWeight fontWeight = FontWeight.bold ,
  Color color = Colors.black,
  bool upperCase = false ,
}) => TextButton(
    autofocus: true,
    onPressed: function,
    child: Text(
      upperCase ? text.toUpperCase() : text  ,
      style: TextStyle(
        fontSize: size ,
        fontWeight: fontWeight ,
        color: color ,
      ),
    )) ;




Widget defaultTextForm({
  required TextEditingController controller,
  required TextInputType keyboardType,
  required String? label,
  required IconData prefix,
  required String? Function(String?)? validate,
  Function(String)? onchange,
  Function(String)? onSubmit,
  Function()? onTap,
  bool isPassword = false,
  IconData? suffix,
  Function()? suffixPressed,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validate,
      obscureText: isPassword,
      onFieldSubmitted: onSubmit,
      onChanged: onchange,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(prefix),
        suffixIcon: IconButton(onPressed: suffixPressed, icon: Icon(suffix)),
      ),
    );




Widget defaultTaskItem(Map model, context) => Dismissible(
  key: Key(model['id'].toString()),
  child: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 40.0,
          child: Text(
            '${model['time']}',
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:const TextStyle(fontSize: 20.0),
          ),
        ),
        const SizedBox(
          width: 15.0,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model['title']}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const
                TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
              Text(
                '${model['date']}',
                style:const TextStyle(fontSize: 20.0, color: Colors.grey),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 15.0,
        ),
        IconButton(
            onPressed: () {
              AppCubit.get(context)
                  .updateDatabase(id: model['id'], status: 'Done');
            },
            icon:const Icon(
              Icons.check_box,
              color: Colors.green,
            )),
        IconButton(
            onPressed: () {
              AppCubit.get(context)
                  .updateDatabase(id: model['id'], status: 'Archived');
            },
            icon:const Icon(
              Icons.archive,
              color: Colors.grey,
            )),
      ],
    ),
  ),
  onDismissed: (direction) {
    AppCubit.get(context).deleteDatabase(id: model['id']);
  },
);



// widget for Empty  tasks screen
Widget  TaskBuilder({
  required List<Map> tasks,
}) =>
    ConditionalBuilder(
        condition:  tasks.isNotEmpty,
        builder: (context) => ListView.separated(
            itemBuilder: (context, index) =>
                defaultTaskItem(tasks[index], context),
            separatorBuilder: (context, index) => mySeparator(),
            itemCount: tasks.length),
        fallback: (context) =>const Padding(
          padding:  EdgeInsets.all(20.0),
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.menu,
                size: 100.0,
                color: Colors.grey,
              ),
              Text(
                'Not Data yet , Please Enter some records',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            ],
          ),
        ));



Widget mySeparator() => Padding(
  padding: const EdgeInsetsDirectional.only(start: 20.0, end: 20.0),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey[400],
  ),
);











void navigateTo(context, widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));


void navigateToAndFinish(context , widget ) =>
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => widget),
            (route) => false) ;
