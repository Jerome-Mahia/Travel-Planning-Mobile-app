class StepGuide {
  final String title;
  final String description;

  StepGuide({
    required this.title,
    required this.description,
  });
}

final _guide1=StepGuide(title: '', description: '');

final _guide2=StepGuide(title: '', description: '');

final _guide3=StepGuide(title: '', description: '');

final _guide4=StepGuide(title: '', description: '');

final _guide5=StepGuide(title: '', description: '');

List<StepGuide> guides = [
  _guide1,
  _guide2,
  _guide3,
  _guide4,
  _guide5,
];