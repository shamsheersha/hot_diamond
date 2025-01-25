import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/src/controllers/user_details/user_details_event.dart';
import 'package:hot_diamond_users/src/controllers/user_details/user_details_state.dart';
import 'package:hot_diamond_users/src/model/user/user_model.dart';

import 'package:hot_diamond_users/src/services/auth_repository.dart';
import 'package:hot_diamond_users/src/services/cloudinary_serivce.dart';

class UserDetailsBloc extends Bloc<UserDetailsEvent, UserDetailsState> {
  final AuthRepository authRepository;
  final ImageCloudinaryService imageService;

  UserDetailsBloc({
    required this.authRepository,
    required this.imageService,
  }) : super(UserDetailsInitial()) {
    on<FetchUserDetails>(_onFetchUserDetails);
    on<UpdateUserDetails>(_onUpdateUserDetails);
    on<UpdateProfileImage>(_onUpdateProfileImage);
  }

  Future<void> _onFetchUserDetails(
    FetchUserDetails event,
    Emitter<UserDetailsState> emit,
  ) async {
    try {
      emit(UserDetailsLoading());
      UserModel? userDetails = await authRepository.getUserDetails();
      
      if (userDetails != null) {
        emit(UserDetailsLoaded(
          name: userDetails.name,
          phoneNumber: userDetails.phoneNumber,
          email: userDetails.email,
          profileImage: userDetails.profileImage,
        ));
      } else {
        emit(const UserDetailsError(error: 'No user details found.'));
      }
    } catch (e) {
      emit(UserDetailsError(error: 'Failed to fetch user details: $e'));
    }
  }

  Future<void> _onUpdateProfileImage(
    UpdateProfileImage event,
    Emitter<UserDetailsState> emit,
  ) async {
    try {
      // Store current state before emitting loading
      final currentState = state;
      emit(UserDetailsLoading());

      // Upload the new image to Cloudinary
      String imageUrl = await imageService.uploadImage(event.imagePath);

      // Get current user data
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: event.email)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = userSnapshot.docs.first;
        
        // Delete old image if it exists
        final oldData = userDoc.data() as Map<String, dynamic>?;
        if (oldData != null && oldData['profileImage'] != null) {
          await imageService.deleteImage(oldData['profileImage']);
        }

        // Update user document with new image URL
        await userDoc.reference.update({
          'profileImage': imageUrl,
        });

        // Re-emit loaded state with updated data
        if (currentState is UserDetailsLoaded) {
          emit(UserDetailsLoaded(
            name: currentState.name,
            email: currentState.email,
            phoneNumber: currentState.phoneNumber,
            profileImage: imageUrl,
          ));
        } else {
          // Fetch fresh user details if we don't have current state
          add(FetchUserDetails());
        }
      } else {
        emit(const UserDetailsError(error: 'User not found.'));
      }
    } catch (e) {
      emit(UserDetailsError(error: 'Failed to update profile image: $e'));
      // Recover the previous state if available
      if (state is UserDetailsLoaded) {
        emit(state);
      } else {
        add(FetchUserDetails());
      }
    }
  }

  Future<void> _onUpdateUserDetails(
    UpdateUserDetails event,
    Emitter<UserDetailsState> emit,
  ) async {
    try {
      emit(UserDetailsLoading());

      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: event.email)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = userSnapshot.docs.first;
        final currentData = userDoc.data() as Map<String, dynamic>?;
        
        await userDoc.reference.update({
          'name': event.name,
          'email': event.email,
          'phoneNumber': event.phoneNumber,
          // Preserve the existing profileImage
          'profileImage': currentData?['profileImage'],
        });

        emit(UserDetailsLoaded(
          name: event.name,
          email: event.email,
          phoneNumber: event.phoneNumber,
          profileImage: currentData?['profileImage'],
        ));
      } else {
        emit(const UserDetailsError(error: 'User not found.'));
      }
    } catch (e) {
      emit(UserDetailsError(error: 'Failed to update user details: $e'));
    }
  }
}