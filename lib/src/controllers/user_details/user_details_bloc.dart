import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hot_diamond_users/src/services/auth_repository.dart';

part 'user_details_event.dart';
part 'user_details_state.dart';

class UserDetailsBloc extends Bloc<UserDetailsEvent, UserDetailsState> {
  final AuthRepository authRepository;

  UserDetailsBloc({required this.authRepository}) : super(UserDetailsInitial()) {
    on<FetchUserDetails>(_onFetchUserDetails);
  }

  Future<void> _onFetchUserDetails(FetchUserDetails event, Emitter<UserDetailsState> emit) async {
    try {
      // Emit loading state before fetching data
      emit(UserDetailsLoading());

      // Fetch user details from the repository
      var userDetails = await authRepository.getUserDetails();

      // Check if user details were fetched
      if (userDetails != null) {
        emit(UserDetailsLoaded(name: userDetails['name'], phoneNumber: userDetails['phoneNumber']));
      } else {
        emit(const UserDetailsError( error: 'No user details found.'));
      }
    } catch (e) {
      emit(UserDetailsError(error: 'Failed to fetch user details: $e'));
    }
  }
}
