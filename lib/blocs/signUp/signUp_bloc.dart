import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/blocs/signUp/signUp_event.dart';
import 'package:untitled/blocs/signUp/signUp_state.dart';
import 'package:untitled/data/models/repositories/signUp_repository.dart';

class CoachBloc extends Bloc<CoachEvent, CoachState> {
  final CoachRepository coachRepository;

  CoachBloc(this.coachRepository) : super(CoachInitialState());

  @override
  Stream<CoachState> mapEventToState(CoachEvent event) async* {
    if (event is RegisterCoachEvent) {
      yield CoachRegisteringState();
      try {
        final response = await coachRepository.registerCoach(event.coachData);
        yield CoachRegisteredState(response);
      } catch (e) {
        yield CoachErrorState(e.toString());
      }
    }
  }
}
