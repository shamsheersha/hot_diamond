import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hot_diamond_users/src/model/user/user_model.dart';
import 'package:hot_diamond_users/src/services/auth_repository.dart';

part 'user_details_event.dart';
part 'user_details_state.dart';

class UserDetailsBloc extends Bloc<UserDetailsEvent, UserDetailsState> {
  final AuthRepository authRepository;

  UserDetailsBloc({required this.authRepository}) : super(UserDetailsInitial()) {
    on<FetchUserDetails>(_onFetchUserDetails);
    on<UpdateUserDetails>(_onUpdateUserDetails);
  }

  Future<void> _onFetchUserDetails(FetchUserDetails event, Emitter<UserDetailsState> emit) async {
    try {
      // Emit loading state before fetching data
      emit(UserDetailsLoading());

      // Fetch user details from the repository
      UserModel? userDetails = await authRepository.getUserDetails();

      // Check if user details were fetched
      if (userDetails != null) {
        emit(UserDetailsLoaded(name: userDetails.name, phoneNumber: userDetails.phoneNumber, email: userDetails.email));
      } else {
        emit(const UserDetailsError( error: 'No user details found.'));
      }
    } catch (e) {
      emit(UserDetailsError(error: 'Failed to fetch user details: $e'));
    }
  }

   //! Handler for UpdateUserDetails event
  Future<void> _onUpdateUserDetails(
      UpdateUserDetails event, Emitter<UserDetailsState> emit) async {
    try {
      emit(UserDetailsLoading()); // Emit loading state

      // Update user details in Firebase
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: event.email)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = userSnapshot.docs.first;

        await userDoc.reference.update({
          'name': event.name,
          'email': event.email,
          'phoneNumber': event.phoneNumber,
        });

        emit(UserDetailsLoaded(
          name: event.name,
          email: event.email,
          phoneNumber: event.phoneNumber,
        )); // Emit updated user details
      } else {
        emit(const UserDetailsError(error: 'User not found.'));
      }
    } catch (e) {
      emit(UserDetailsError(error: 'Failed to update user details: $e'));
    }
  }
}
