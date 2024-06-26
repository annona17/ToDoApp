import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todoapp/screens/home/home.dart';
import 'bloc/addtask/addtask_bloc.dart';
import 'bloc/home/home_bloc.dart';
import 'data/model/task.dart';
import 'screens/add_task/add_task.dart';

Future <void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Box <Task> box ;
  if (Hive.isBoxOpen('tasks')) {
    box = Hive.box<Task>('tasks');
  } else {
    box = await Hive.openBox<Task>('tasks');
  }
  if (box.isEmpty) {
    var task1 = Task(
      id: "1",
      title: 'Task 1',
      description: 'Description 1',
      date: DateTime.now(),
      startTime: "08:00",
      endTime: "10:00",
      priority: "high",
      color: Colors.red.withOpacity(0.5).value,
    );
    await Future.delayed(const Duration(seconds: 1));
    var task2 = Task(
      id: "2",
      title: 'Task 2',
      description: 'Description 2',
      date: DateTime.now(),
      startTime: "10:00",
      endTime: "12:00",
      priority: "medium",
      color: Colors.green.withOpacity(0.5).value,
    );
    await Future.delayed(const Duration(seconds: 1));
    var task3 = Task(
      id: "3",
      title: 'Task 3',
      description: 'Description 3',
      date: DateTime.now(),
      startTime: "14:00",
      endTime: "16:00",
      priority: "low",
      color: Colors.blue.withOpacity(0.5).value,
    );

    await box.put(task1.id, task1);
    await box.put(task2.id, task2);
    await box.put(task3.id, task3);

  }
  runApp(
      MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => HomeBloc()..add(const HomeLoadTasks()),
            ),
            BlocProvider(
              create: (context) => AddTaskBloc(),
            ),
          ],
          child: const MyApp())
  );
}
final navigatorKey = GlobalKey<NavigatorState>();
class MyApp extends StatelessWidget {

  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'My Tasks App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      routes: {
        '/add_task': (context) => const AddTask(),
      },
    );
  }
}


