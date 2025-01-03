abstract class CoachState {}

class CoachInitialState extends CoachState {}

class CoachRegisteringState extends CoachState {}

class CoachRegisteredState extends CoachState {
  final Map<String, dynamic> response;

  CoachRegisteredState(this.response);
}

class CoachErrorState extends CoachState {
  final String errorMessage;

  CoachErrorState(this.errorMessage);
}
