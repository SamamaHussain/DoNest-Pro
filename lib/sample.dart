// class NoteEditScreen extends StatefulWidget {
//   final Note note;

//   const NoteEditScreen({super.key, required this.note});

//   @override
//   State<NoteEditScreen> createState() => _NoteEditScreenState();
// }

// class _NoteEditScreenState extends State<NoteEditScreen> {
//   late TextEditingController _titleController;
//   late TextEditingController _contentController;

//   @override
//   void initState() {
//     super.initState();
//     _titleController = TextEditingController(text: widget.note.title);
//     _contentController = TextEditingController(text: widget.note.content);
//   }

//   Future<void> _updateNote() async {
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(/* your user UID */)
//         .collection('notes')
//         .doc(widget.note.id)
//         .update({
//       'title': _titleController.text,
//       'content': _contentController.text,
//     });

//     Navigator.pop(context); // Return to home after saving
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text('Edit Note'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.check),
//             onPressed: _updateNote,
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _titleController,
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               decoration: const InputDecoration(border: InputBorder.none, hintText: 'Title'),
//             ),
//             Expanded(
//               child: TextField(
//                 controller: _contentController,
//                 maxLines: null,
//                 expands: true,
//                 decoration: const InputDecoration(border: InputBorder.none, hintText: 'Note'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
