import 'package:hive/hive.dart';

part 'notes_model.g.dart';

@HiveType(typeId: 0)
class NotesModel extends HiveObject {
  @HiveField(0)
  String title;
  @HiveField(1)
  String subTitle;
  @HiveField(2)
  String date;
  @HiveField(3)
  int color;
  @HiveField(4)
  String? dateEdit;

  NotesModel({
    required this.title,
    required this.subTitle,
    required this.date,
    required this.color,
    this.dateEdit,
  });
}
