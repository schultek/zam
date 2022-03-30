part of polls_module;

@MappableClass()
class Poll {
  final String id;
  final String name;
  final DateTime startedAt;

  final List<PollStep> steps;

  Poll(this.id, this.name, this.startedAt, this.steps);
}

@MappableClass(discriminatorKey: 'type')
class PollStep {
  final String type;

  PollStep(this.type);
}

@MappableClass(discriminatorValue: 'multiple-choice')
class MultipleChoiceQuestion extends PollStep {
  List<String> choices;
  bool multiselect;

  MultipleChoiceQuestion(this.choices, this.multiselect, String type) : super(type);
}

/*

Poll

Name, Id
StartedAt, EndingAt

Steps
  - Text, Question, ...

Logic
  - Branching, Conditions, Scores, Endings

Endings


 */
