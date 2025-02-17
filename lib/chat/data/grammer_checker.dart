import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:language_app/chat/data/message_model.dart';
import 'package:language_tool/language_tool.dart';

class GrammerChecker {
  final _tool = LanguageTool();

  Future<List<GrammerError>> checkText(String text) async {
    final result = await _tool.check(text);
    return result.map((e) => GrammerError(
        e.offset,
        e.length,
        e.message ?? 'Possible Error',
    ).toList();
  }
}