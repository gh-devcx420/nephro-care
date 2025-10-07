import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Result {
  final bool isSuccess;
  final String message;
  final Color backgroundColor;

  const Result({
    required this.isSuccess,
    required this.message,
    required this.backgroundColor,
  });
}

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Result> saveEntry({
    required String userId,
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
    required String successMessage,
    required Color successMessageColor,
    required String errorMessagePrefix,
    required Color errorMessageColor,
  }) async {
    try {
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
      );
    } catch (e) {
      return Result(
        isSuccess: false,
        message: '$errorMessagePrefix$e',
        backgroundColor: errorMessageColor,
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
  }) async {
    try {
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
      );
    } catch (e) {
      return Result(
        isSuccess: false,
        message: '$errorMessagePrefix$e',
        backgroundColor: errorColor,
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
      await batch.commit();
      return Result(
        isSuccess: true,
        message: successMessage,
        backgroundColor: successMessageColor,
      );
    } catch (e) {
      return Result(
        isSuccess: false,
        message: '$errorMessagePrefix$e',
        backgroundColor: errorColor,
      );
    }
  }
}
