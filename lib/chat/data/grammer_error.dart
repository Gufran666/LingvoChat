import 'package:hive/hive.dart';

part 'grammer_error.g.dart';

@HiveType(typeId: 5)
class GrammarError extends HiveObject {
  @HiveField(0)
  final int offset;

  @HiveField(1)
  final int length;

  @HiveField(2)
  final String message;

  GrammarError({
    required this.offset,
    required this.length,
    required this.message,
  });
}
