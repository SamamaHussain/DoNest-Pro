import 'dart:developer' as dev;
import 'package:do_nest/Providers/auth_provider.dart';
import 'package:do_nest/Providers/firestore_provider.dart';
import 'package:do_nest/Utils/Widgets/color_pciker.dart';
import 'package:do_nest/Utils/Widgets/snackbar_widget.dart';
import 'package:do_nest/Views/note_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<FirebaseAuthProvider>(
      context,
      listen: true,
    );

    final dataProvider = Provider.of<FirestoreDataProvider>(
      context,
      listen: true,
    );
    dev.log('Tasks: ${dataProvider.tasks.length}');

    String? userName = authProvider.userModel?.firstName ?? 'No user logged in';
    print(userName);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              authProvider.signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Center(
        //  child: dataProvider.isLoading
        //     ? const CircularProgressIndicator()
        //     : dataProvider.tasks.isEmpty ? Center(
        //       child: Text(
        //         'No tasks available. Please add a task.',
        //         style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        //       ),
        //     ) :
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            itemCount: dataProvider.tasks.length,
            itemBuilder: (context, index) {
              final task = dataProvider.tasks[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditNoteScreen(taskDoc: task),
                    ),
                  );
                },
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Options'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(Icons.delete, color: Colors.red),
                              title: Text('Delete'),
                              onTap: () {
                                // Perform delete action
                                dataProvider
                                    .deleteTask(
                                      uid: authProvider.userModel!.uId!,
                                      taskId: task.id,
                                    )
                                    .then((_) {
                                      showMessage(
                                        context,
                                        'Task deleted successfully',
                                      );
                                      Navigator.of(context).pop();
                                    });
                              },
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.color_lens,
                                color: Colors.blue,
                              ),
                              title: Text('Change Color'),
                              onTap: () {
                                 Navigator.of(context).pop();
                                final selectedColorCode= pickColor(context, task.id);
                                dataProvider.updateNoteColor(authProvider.userModel!.uId!, task.id,selectedColorCode).then((_) {
                                  showMessage(
                                    context,
                                    'Note color updated successfully',
                                  );
                                });
                                // Show color picker dialog or perform color change action
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(task['color']),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task['title'] ?? 'No title provided',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        task['descp'] ?? 'No description provided',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 6),
                      Text(
                        // 'Created at: ${task['createdAt']?.toDate().toString() ?? 'Unknown'}',
                        '${timeago.format(task['lastUpdated']?.toDate() ?? DateTime.now())}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/newNote');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
