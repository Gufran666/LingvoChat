// Mocks generated by Mockito 5.4.5 from annotations
// in language_app/test/features/auth/auth_provider_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:firebase_auth/firebase_auth.dart' as _i4;
import 'package:language_app/features/auth/data/auth_repository.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [AuthRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthRepository extends _i1.Mock implements _i2.AuthRepository {
  MockAuthRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<_i4.User?> signInWithEmailAndPassword(
    String? email,
    String? password,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #signInWithEmailAndPassword,
          [
            email,
            password,
          ],
        ),
        returnValue: _i3.Future<_i4.User?>.value(),
      ) as _i3.Future<_i4.User?>);

  @override
  _i3.Future<_i4.User?> signUpWithEmailAndPassword(
    String? email,
    String? password,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #signUpWithEmailAndPassword,
          [
            email,
            password,
          ],
        ),
        returnValue: _i3.Future<_i4.User?>.value(),
      ) as _i3.Future<_i4.User?>);

  @override
  _i3.Future<_i4.User?> signInWithGoogle() => (super.noSuchMethod(
        Invocation.method(
          #signInWithGoogle,
          [],
        ),
        returnValue: _i3.Future<_i4.User?>.value(),
      ) as _i3.Future<_i4.User?>);

  @override
  _i3.Future<void> logout() => (super.noSuchMethod(
        Invocation.method(
          #logout,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}
