// import 'package:flutter/material.dart';

// class Bubble extends StatefulWidget {
//   final String text;
//   final Color color;
//   int index = 0;

//   Bubble({
//     Key? key,
//     required this.text,
//     required this.color,
//     required this.index,
//   }) : super(key: key);

//   @override
//   State<Bubble> createState() => _BubbleState();
// }

// class _BubbleState extends State<Bubble> {
//   int selectedIndex = 0;
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedIndex = widget.index;
//         });
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//         margin: const EdgeInsets.symmetric(horizontal: 4),
//         decoration: BoxDecoration(
//           color: selectedIndex == widget.index ? Colors.black : widget.color,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Text(widget.text, style: const TextStyle(color: Colors.white)),
//       ),
//     );
//   }
// }
