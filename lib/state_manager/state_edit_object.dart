import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditObject<T> {
  T? object;

  EditObject({this.object});
}

final editObjectProvider = StateProvider<EditObject>((ref) {
  return EditObject();
});
