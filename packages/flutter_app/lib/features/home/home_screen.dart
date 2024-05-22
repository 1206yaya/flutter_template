import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/data/auth_repository.dart';

final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((ref) {
  return GlobalKey<NavigatorState>();
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController displayNameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authRepositoryProvider).signOut();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: displayNameController,
              decoration: const InputDecoration(
                labelText: 'New Display Name',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String newDisplayName = displayNameController.text.trim();
                if (newDisplayName.isNotEmpty) {
                  await _updateDisplayName(ref, newDisplayName);
                }
              },
              child: const Text('Update DisplayName From Flutter Client'),
            ),
            ElevatedButton(
              onPressed: () async {
                String newDisplayName = displayNameController.text.trim();
                if (newDisplayName.isNotEmpty) {
                  await _updateDisplayNameByFunction(ref, newDisplayName);
                }
              },
              child: const Text('Update DisplayName From Functions'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateDisplayName(WidgetRef ref, String newDisplayName) async {
    try {
      final user = ref.read(authRepositoryProvider).currentUser!;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .update({'displayName': newDisplayName});
    } catch (e) {}
  }

  Future<void> _updateDisplayNameByFunction(
      WidgetRef ref, String newDisplayName) async {
    final uid = ref.read(authRepositoryProvider).currentUser!.id;
    const funcName = 'updateUser';
    await FirebaseFunctions.instance.httpsCallable(funcName).call(
      {'uid': uid, 'displayName': newDisplayName},
    ).then((result) {
      print("$funcName called successfully: ${result.data}");
    }).catchError((error) {
      print("Error calling $funcName: $error");
    });
  }
}
