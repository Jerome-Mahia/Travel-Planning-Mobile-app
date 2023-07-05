class StepGuide {
  final String title;
  final String description;

  StepGuide({
    required this.title,
    required this.description,
  });
}

final _guide1=StepGuide(title: 'Add a note', description: 'Jot down anything about your trip');

final _guide2=StepGuide(title: 'Add a reservation', description: 'Save your reservations in one place');

final _guide3=StepGuide(title: 'Add a flight ticket', description: 'Save your flight tickets in one place');

final _guide4=StepGuide(title: 'Add a ticket', description: 'Save your bus or any other ticket in one place');

final _guide5=StepGuide(title: 'Map view', description: 'View all your place destinations on a map');

List<StepGuide> guides = [
  _guide1,
  _guide2,
  _guide3,
  _guide4,
  _guide5,
];