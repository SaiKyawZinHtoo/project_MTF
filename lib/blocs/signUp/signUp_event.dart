abstract class CoachEvent {}

class RegisterCoachEvent extends CoachEvent {
  final Map<String, dynamic> coachData;

  RegisterCoachEvent(this.coachData);
}
