
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ss20/screens/postScreen.dart';

class DevFeed extends StatelessWidget {
DevFeed({super.key});

final CollectionReference posts =
FirebaseFirestore.instance.collection('posts');

Future<void> toggleLikes(
String docId,
String userId,
List likes,
) async {
final bool isLiked = likes.contains(userId);

await posts.doc(docId).update({
'likes': isLiked
? FieldValue.arrayRemove([userId])
    : FieldValue.arrayUnion([userId]),
});
}

Future<void> deletePost(String docId) async {
await posts.doc(docId).delete();
}

void showDeleteDialog(
BuildContext context,
String docId,
) {
showDialog(
context: context,
builder: (context) {
return AlertDialog(
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(20),
),
title: const Text(
'Delete Post?',
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
content: const Text(
'Are you sure you want to delete this post?',
),
actions: [
TextButton(
onPressed: () {
Navigator.pop(context);
},
child: const Text('Cancel'),
),
ElevatedButton(
style: ElevatedButton.styleFrom(
backgroundColor: Colors.red,
foregroundColor: Colors.white,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),
),
onPressed: () async {
Navigator.pop(context);
await deletePost(docId);
},
child: const Text('Delete'),
),
],
);
},
);
}

@override
Widget build(BuildContext context) {
final user = FirebaseAuth.instance.currentUser;

return Scaffold(
backgroundColor: const Color(0xFFF7F8FC),

appBar: AppBar(
elevation: 0,
backgroundColor: Colors.white,
surfaceTintColor: Colors.white,
toolbarHeight: 75,
automaticallyImplyLeading: false,

title: Row(
children: [
Container(
width: 44,
height: 44,
decoration: BoxDecoration(
gradient: const LinearGradient(
begin: Alignment.topLeft,
end: Alignment.bottomRight,
colors: [
Color(0xFF6366F1),
Color(0xFF8B5CF6),
],
),
borderRadius: BorderRadius.circular(14),
),
child: const Icon(
Icons.code_rounded,
color: Colors.white,
size: 24,
),
),

const SizedBox(width: 12),

const Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'Dev Feed',
style: TextStyle(
color: Color(0xFF111827),
fontSize: 21,
fontWeight: FontWeight.w800,
),
),
SizedBox(height: 2),
Text(
'Developer community',
style: TextStyle(
color: Color(0xFF9CA3AF),
fontSize: 11,
fontWeight: FontWeight.w500,
),
),
],
),
],
),

actions: [
Container(
margin: const EdgeInsets.only(right: 16),
decoration: BoxDecoration(
color: const Color(0xFFF3F4F6),
borderRadius: BorderRadius.circular(13),
),
child: IconButton(
onPressed: () {},
icon: const Icon(
Icons.notifications_none_rounded,
color: Color(0xFF374151),
),
),
),
],
),

floatingActionButton: Container(
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(18),
boxShadow: [
BoxShadow(
color: const Color(0xFF6366F1).withOpacity(0.35),
blurRadius: 18,
offset: const Offset(0, 8),
),
],
),
child: FloatingActionButton.extended(
elevation: 0,
backgroundColor: const Color(0xFF6366F1),
foregroundColor: Colors.white,
onPressed: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (context) => PostScreen(),
),
);
},
icon: const Icon(
Icons.add_rounded,
size: 25,
),
label: const Text(
'Create Post',
style: TextStyle(
fontSize: 14,
fontWeight: FontWeight.bold,
),
),
),
),

body: StreamBuilder<QuerySnapshot>(
stream: posts.snapshots(),

builder: (context, snapshot) {
if (snapshot.connectionState ==
ConnectionState.waiting) {
return const Center(
child: CircularProgressIndicator(
color: Color(0xFF6366F1),
),
);
}

if (snapshot.hasError) {
return Center(
child: Padding(
padding: const EdgeInsets.all(30),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Container(
padding: const EdgeInsets.all(20),
decoration: BoxDecoration(
color: Colors.red.shade50,
shape: BoxShape.circle,
),
child: Icon(
Icons.error_outline_rounded,
size: 45,
color: Colors.red.shade400,
),
),
const SizedBox(height: 18),
const Text(
'Something went wrong',
style: TextStyle(
fontSize: 19,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 7),
const Text(
'Please try again later.',
textAlign: TextAlign.center,
style: TextStyle(
color: Colors.grey,
),
),
],
),
),
);
}

final data = snapshot.data?.docs ?? [];

if (data.isEmpty) {
return Center(
child: Padding(
padding: const EdgeInsets.all(30),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Container(
width: 90,
height: 90,
decoration: BoxDecoration(
gradient: const LinearGradient(
colors: [
Color(0xFFEDE9FE),
Color(0xFFE0E7FF),
],
),
borderRadius:
BorderRadius.circular(28),
),
child: const Icon(
Icons.forum_outlined,
size: 45,
color: Color(0xFF6366F1),
),
),

const SizedBox(height: 22),

const Text(
'Nothing here yet',
style: TextStyle(
fontSize: 22,
fontWeight: FontWeight.w800,
color: Color(0xFF111827),
),
),

const SizedBox(height: 8),

const Text(
'Be the first developer to share\nsomething with the community.',
textAlign: TextAlign.center,
style: TextStyle(
height: 1.5,
color: Color(0xFF9CA3AF),
fontSize: 14,
),
),

const SizedBox(height: 25),

ElevatedButton.icon(
style: ElevatedButton.styleFrom(
backgroundColor:
const Color(0xFF6366F1),
foregroundColor: Colors.white,
elevation: 0,
padding: const EdgeInsets.symmetric(
horizontal: 22,
vertical: 13,
),
shape: RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(14),
),
),
onPressed: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (context) =>
PostScreen(),
),
);
},
icon: const Icon(
Icons.add_rounded,
),
label: const Text(
'Create your first post',
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
),
],
),
),
);
}

return RefreshIndicator(
color: const Color(0xFF6366F1),
onRefresh: () async {
await Future.delayed(
const Duration(milliseconds: 500),
);
},

child: ListView.builder(
padding: const EdgeInsets.fromLTRB(
16,
20,
16,
110,
),
itemCount: data.length,

itemBuilder: (context, index) {
final post =
data[index].data()
as Map<String, dynamic>;

final String docId = data[index].id;

final List likes =
post['likes'] ?? [];

final String authorEmail =
post['authorEmail'] ??
'Unknown Developer';

final String content =
post['content'] ?? '';

final String userId =
user?.uid ?? '';

final bool isLiked =
likes.contains(userId);

final String firstLetter =
authorEmail.isNotEmpty
? authorEmail[0].toUpperCase()
    : 'D';

return Container(
margin: const EdgeInsets.only(
bottom: 18,
),

decoration: BoxDecoration(
color: Colors.white,
borderRadius:
BorderRadius.circular(24),
border: Border.all(
color: const Color(0xFFEDEEF2),
),
boxShadow: [
BoxShadow(
color: Colors.black
    .withOpacity(0.035),
blurRadius: 20,
offset: const Offset(0, 7),
),
],
),

child: Padding(
padding: const EdgeInsets.all(18),

child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,

children: [
Row(
children: [
Container(
width: 50,
height: 50,
decoration: BoxDecoration(
gradient:
const LinearGradient(
begin:
Alignment.topLeft,
end:
Alignment.bottomRight,
colors: [
Color(0xFF6366F1),
Color(0xFF8B5CF6),
],
),
borderRadius:
BorderRadius.circular(
16,
),
),
alignment: Alignment.center,
child: Text(
firstLetter,
style:
const TextStyle(
color: Colors.white,
fontSize: 21,
fontWeight:
FontWeight.w800,
),
),
),

const SizedBox(width: 13),

Expanded(
child: Column(
crossAxisAlignment:
CrossAxisAlignment
    .start,
children: [
Text(
authorEmail,
maxLines: 1,
overflow:
TextOverflow
    .ellipsis,
style:
const TextStyle(
color:
Color(0xFF111827),
fontSize: 15,
fontWeight:
FontWeight.w700,
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
Color(
0xFF22C55E,
),
shape:
BoxShape
    .circle,
),
),

const SizedBox(
width: 6),

const Text(
'Developer',
style: TextStyle(
color:
Color(
0xFF9CA3AF,
),
fontSize: 11,
fontWeight:
FontWeight
    .w500,
),
),
],
),
],
),
),

PopupMenuButton<String>(
icon: const Icon(
Icons.more_horiz_rounded,
color:
Color(0xFF9CA3AF),
),
shape: RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(
15,
),
),
onSelected: (value) {
if (value == 'delete') {
showDeleteDialog(
context,
docId,
);
}
},
itemBuilder: (context) => [
const PopupMenuItem(
value: 'delete',
child: Row(
children: [
Icon(
Icons
    .delete_outline_rounded,
color: Colors.red,
),
SizedBox(width: 10),
Text(
'Delete post',
),
],
),
),
],
),
],
),

const SizedBox(height: 20),

Text(
content,
style: const TextStyle(
color: Color(0xFF374151),
fontSize: 15,
height: 1.65,
fontWeight: FontWeight.w400,
),
),

const SizedBox(height: 20),

Container(
height: 1,
color: const Color(0xFFF0F1F4),
),

const SizedBox(height: 12),

Row(
children: [
Material(
color: isLiked
? const Color(0xFFEDE9FE)
    : const Color(
0xFFF8F8FA,
),
borderRadius:
BorderRadius.circular(
13,
),
child: InkWell(
borderRadius:
BorderRadius.circular(
13,
),
onTap: () {
if (user != null) {
toggleLikes(
docId,
user.uid,
likes,
);
}
},
child: Padding(
padding:
const EdgeInsets
    .symmetric(
horizontal: 13,
vertical: 9,
),
child: Row(
children: [
Icon(
isLiked
? Icons
    .thumb_up_rounded
    : Icons
    .thumb_up_outlined,
size: 19,
color: isLiked
? const Color(
0xFF6366F1)
    : const Color(
0xFF6B7280),
),
const SizedBox(
width: 7),
Text(
'${likes.length}',
style: TextStyle(
color: isLiked
? const Color(
0xFF6366F1)
    : const Color(
0xFF6B7280),
fontWeight:
FontWeight.w700,
fontSize: 13,
),
),
],
),
),
),
),

const SizedBox(width: 10),

Expanded(
child: Text(
likes.isEmpty
? 'Be the first to like this'
    : likes.length == 1
? '1 person liked this'
    : '${likes.length} people liked this',
style: const TextStyle(
color:
Color(0xFF9CA3AF),
fontSize: 11,
fontWeight:
FontWeight.w500,
),
),
),

Container(
padding:
const EdgeInsets.all(9),
decoration: BoxDecoration(
color:
const Color(0xFFF8F8FA),
borderRadius:
BorderRadius.circular(
12,
),
),
child: const Icon(
Icons
    .chat_bubble_outline_rounded,
size: 18,
color:
Color(0xFF9CA3AF),
),
),
],
),
],
),
),
);
},
),
);
},
),
);
}
}

