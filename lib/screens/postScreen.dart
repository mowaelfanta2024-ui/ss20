
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/post_model.dart';

class PostScreen extends StatefulWidget {
const PostScreen({super.key});

@override
State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
final TextEditingController controller = TextEditingController();

static const int maxLength = 500;

@override
void dispose() {
controller.dispose();
super.dispose();
}

Future<void> addPost() async {
if (controller.text.trim().isEmpty) {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: const Row(
children: [
Icon(
Icons.warning_amber_rounded,
color: Colors.white,
),
SizedBox(width: 10),
Text('Please write something first.'),
],
),
backgroundColor: const Color(0xFF6366F1),
behavior: SnackBarBehavior.floating,
margin: const EdgeInsets.all(16),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(14),
),
),
);
return;
}

final user = FirebaseAuth.instance.currentUser;

if (user == null) {
return;
}

final postContent = PostModel(
authorId: user.uid,
authorEmail: user.email,
content: controller.text.trim(),
likes: [],
);

await FirebaseFirestore.instance
    .collection('posts')
    .add(postContent.toFirestore());

if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: const Row(
children: [
Icon(
Icons.check_circle_rounded,
color: Colors.white,
),
SizedBox(width: 10),
Text('Post published successfully!'),
],
),
backgroundColor: const Color(0xFF6366F1),
behavior: SnackBarBehavior.floating,
margin: const EdgeInsets.all(16),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(14),
),
),
);

controller.clear();
}

@override
Widget build(BuildContext context) {
final user = FirebaseAuth.instance.currentUser;

final String email = user?.email ?? 'Developer';

final String firstLetter =
email.isNotEmpty ? email[0].toUpperCase() : 'D';

return Scaffold(
backgroundColor: const Color(0xFFF7F8FC),

appBar: AppBar(
elevation: 0,
backgroundColor: Colors.white,
surfaceTintColor: Colors.white,
centerTitle: false,
toolbarHeight: 75,

leading: Padding(
padding: const EdgeInsets.only(
left: 12,
top: 10,
bottom: 10,
),
child: Container(
decoration: BoxDecoration(
color: const Color(0xFFF3F4F6),
borderRadius: BorderRadius.circular(13),
),
child: IconButton(
onPressed: () {
Navigator.pop(context);
},
icon: const Icon(
Icons.arrow_back_ios_new_rounded,
size: 19,
color: Color(0xFF374151),
),
),
),
),

title: const Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'Create Post',
style: TextStyle(
fontSize: 22,
fontWeight: FontWeight.w800,
color: Color(0xFF111827),
),
),
SizedBox(height: 2),
Text(
'Share with the community',
style: TextStyle(
fontSize: 11,
color: Color(0xFF9CA3AF),
fontWeight: FontWeight.w500,
),
),
],
),
),

body: SafeArea(
child: SingleChildScrollView(
keyboardDismissBehavior:
ScrollViewKeyboardDismissBehavior.onDrag,

padding: const EdgeInsets.fromLTRB(
16,
22,
16,
30,
),

child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Container(
padding: const EdgeInsets.all(20),

decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(24),
border: Border.all(
color: const Color(0xFFEDEEF2),
),
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(0.035),
blurRadius: 20,
offset: const Offset(0, 7),
),
],
),

child: Column(
children: [
Row(
children: [
Container(
width: 52,
height: 52,

decoration: BoxDecoration(
gradient: const LinearGradient(
begin: Alignment.topLeft,
end: Alignment.bottomRight,
colors: [
Color(0xFF6366F1),
Color(0xFF8B5CF6),
],
),
borderRadius:
BorderRadius.circular(16),
),

alignment: Alignment.center,

child: Text(
firstLetter,
style: const TextStyle(
color: Colors.white,
fontSize: 21,
fontWeight: FontWeight.w800,
),
),
),

const SizedBox(width: 13),

Expanded(
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Text(
email,
maxLines: 1,
overflow:
TextOverflow.ellipsis,
style: const TextStyle(
fontSize: 15,
fontWeight:
FontWeight.w700,
color:
Color(0xFF111827),
),
),

const SizedBox(height: 5),

Row(
children: [
Container(
width: 6,
height: 6,
decoration:
const BoxDecoration(
color:
Color(0xFF22C55E),
shape: BoxShape.circle,
),
),

const SizedBox(width: 6),

const Text(
'Developer',
style: TextStyle(
fontSize: 11,
color:
Color(0xFF9CA3AF),
fontWeight:
FontWeight.w500,
),
),
],
),
],
),
),
],
),

const SizedBox(height: 24),

Align(
alignment: Alignment.centerLeft,
child: Row(
children: [
Container(
padding:
const EdgeInsets.all(8),
decoration: BoxDecoration(
color: const Color(0xFFEDE9FE),
borderRadius:
BorderRadius.circular(10),
),
child: const Icon(
Icons.edit_rounded,
size: 18,
color: Color(0xFF6366F1),
),
),

const SizedBox(width: 10),

const Text(
'What\'s on your mind?',
style: TextStyle(
fontSize: 15,
fontWeight: FontWeight.w700,
color: Color(0xFF374151),
),
),
],
),
),

const SizedBox(height: 14),

TextField(
controller: controller,
maxLines: 10,
minLines: 7,
maxLength: maxLength,

textCapitalization:
TextCapitalization.sentences,

onChanged: (_) {
setState(() {});
},

style: const TextStyle(
fontSize: 15,
height: 1.6,
color: Color(0xFF374151),
),

decoration: InputDecoration(
hintText:
'Share your project, idea, coding tip, or something interesting...',
hintStyle: const TextStyle(
color: Color(0xFFB0B3BA),
fontSize: 14,
height: 1.5,
),

filled: true,

fillColor:
const Color(0xFFF8F8FA),

counterText: '',

contentPadding:
const EdgeInsets.all(17),

border: OutlineInputBorder(
borderRadius:
BorderRadius.circular(18),
borderSide: BorderSide.none,
),

enabledBorder:
OutlineInputBorder(
borderRadius:
BorderRadius.circular(18),
borderSide: const BorderSide(
color: Color(0xFFF0F1F4),
),
),

focusedBorder:
OutlineInputBorder(
borderRadius:
BorderRadius.circular(18),
borderSide: const BorderSide(
color: Color(0xFF6366F1),
width: 1.5,
),
),
),
),

const SizedBox(height: 8),

Row(
children: [
const Icon(
Icons.info_outline_rounded,
size: 15,
color: Color(0xFF9CA3AF),
),

const SizedBox(width: 6),

const Text(
'Keep it clear and useful for the community',
style: TextStyle(
fontSize: 11,
color: Color(0xFF9CA3AF),
),
),

const Spacer(),

Text(
'${controller.text.length}/$maxLength',
style: TextStyle(
fontSize: 12,
fontWeight: FontWeight.w600,
color: controller.text.length >
maxLength * 0.9
? Colors.red
    : const Color(0xFF9CA3AF),
),
),
],
),

const SizedBox(height: 20),

Container(
width: double.infinity,
height: 55,

decoration: BoxDecoration(
gradient: const LinearGradient(
begin: Alignment.centerLeft,
end: Alignment.centerRight,
colors: [
Color(0xFF6366F1),
Color(0xFF8B5CF6),
],
),
borderRadius:
BorderRadius.circular(16),
boxShadow: [
BoxShadow(
color: const Color(0xFF6366F1)
    .withOpacity(0.25),
blurRadius: 15,
offset: const Offset(0, 7),
),
],
),

child: ElevatedButton(
onPressed: addPost,

style:
ElevatedButton.styleFrom(
backgroundColor:
Colors.transparent,
foregroundColor: Colors.white,
shadowColor: Colors.transparent,
elevation: 0,
shape: RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(16),
),
),

child: const Row(
mainAxisAlignment:
MainAxisAlignment.center,
children: [
Icon(
Icons.send_rounded,
size: 20,
),

SizedBox(width: 9),

Text(
'Publish Post',
style: TextStyle(
fontSize: 15,
fontWeight:
FontWeight.w700,
),
),
],
),
),
),
],
),
),

const SizedBox(height: 18),

Container(
padding: const EdgeInsets.all(17),

decoration: BoxDecoration(
gradient: const LinearGradient(
begin: Alignment.topLeft,
end: Alignment.bottomRight,
colors: [
Color(0xFFEDE9FE),
Color(0xFFE0E7FF),
],
),
borderRadius: BorderRadius.circular(19),
border: Border.all(
color: const Color(0xFFE4E0FF),
),
),

child: Row(
crossAxisAlignment:
CrossAxisAlignment.start,

children: [
Container(
width: 40,
height: 40,

decoration: BoxDecoration(
color: Colors.white.withOpacity(0.8),
borderRadius:
BorderRadius.circular(12),
),

child: const Icon(
Icons.lightbulb_rounded,
color: Color(0xFF6366F1),
size: 21,
),
),

const SizedBox(width: 12),

const Expanded(
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Text(
'Quick tip',
style: TextStyle(
fontSize: 14,
fontWeight:
FontWeight.w800,
color: Color(0xFF3730A3),
),
),

SizedBox(height: 4),

Text(
'Share projects, ideas, coding tips, or interesting things you discover. Help other developers learn something new!',
style: TextStyle(
fontSize: 12,
height: 1.5,
color: Color(0xFF5B5B7A),
),
),
],
),
),
],
),
),
],
),
),
),
);
}
}

