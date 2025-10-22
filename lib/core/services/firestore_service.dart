import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Result {
  final bool isSuccess;
  final String message;
  final Color backgroundColor;
  final bool isPendingSync;

  const Result({
    required this.isSuccess,
    required this.message,
    required this.backgroundColor,
    this.isPendingSync = false,
  });
}

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirestoreService() {
    _firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  Future<Result> saveEntry({
    required String userId,
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
    required String successMessage,
    required Color successMessageColor,
    required String errorMessagePrefix,
    required Color errorMessageColor,
    required bool isOnline,
  }) async {
    try {
      if (!isOnline) {
        // Offline: Save without waiting
        _firestore
            .collection('users')
            .doc(userId)
            .collection(collection)
            .doc(docId)
            .set(data)
            .ignore();

        return Result(
          isSuccess: true,
          message: successMessage,
          backgroundColor: successMessageColor,
          isPendingSync: true,
        );
      } else {
        // Online: Wait for completion
        await _firestore
            .collection('users')
            .doc(userId)
            .collection(collection)
            .doc(docId)
            .set(data);

        return Result(
          isSuccess: true,
          message: successMessage,
          backgroundColor: successMessageColor,
          isPendingSync: false,
        );
      }
    } catch (e) {
      return Result(
        isSuccess: false,
        message: '$errorMessagePrefix$e',
        backgroundColor: errorMessageColor,
        isPendingSync: false,
      );
    }
  }

  Future<Result> deleteEntry({
    required String userId,
    required String collection,
    required String docId,
    required String successMessage,
    required Color successColor,
    required String errorMessagePrefix,
    required Color errorColor,
    required bool isOnline,
  }) async {
    try {
      if (!isOnline) {
        _firestore
            .collection('users')
            .doc(userId)
            .collection(collection)
            .doc(docId)
            .delete()
            .ignore();

        return Result(
          isSuccess: true,
          message: successMessage,
          backgroundColor: Colors.green,
          isPendingSync: true,
        );
      } else {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection(collection)
            .doc(docId)
            .delete();

        return Result(
          isSuccess: true,
          message: successMessage,
          backgroundColor: Colors.green,
          isPendingSync: false,
        );
      }
    } catch (e) {
      return Result(
        isSuccess: false,
        message: '$errorMessagePrefix$e',
        backgroundColor: errorColor,
        isPendingSync: false,
      );
    }
  }

  Future<Result> deleteAllEntries({
    required String userId,
    required String collection,
    required List<String> docIds,
    required String successMessage,
    required Color successMessageColor,
    required String errorMessagePrefix,
    required Color errorColor,
    required bool isOnline,
  }) async {
    try {
      final batch = _firestore.batch();
      for (var docId in docIds) {
        batch.delete(
          _firestore
              .collection('users')
              .doc(userId)
              .collection(collection)
              .doc(docId),
        );
      }

      if (!isOnline) {
        batch.commit().ignore();

        return Result(
          isSuccess: true,
          message: successMessage,
          backgroundColor: successMessageColor,
          isPendingSync: true,
        );
      } else {
        await batch.commit();

        return Result(
          isSuccess: true,
          message: successMessage,
          backgroundColor: successMessageColor,
          isPendingSync: false,
        );
      }
    } catch (e) {
      return Result(
        isSuccess: false,
        message: '$errorMessagePrefix$e',
        backgroundColor: errorColor,
        isPendingSync: false,
      );
    }
  }
}
