import 'package:equatable/equatable.dart';

class Goal extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final bool isAchieved;

  const Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    this.isAchieved = false,
  });

  @override
  List<Object?> get props => [id, title, startDate, endDate, isAchieved];
}
