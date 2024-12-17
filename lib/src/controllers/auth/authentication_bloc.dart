import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:hot_diamond_users/src/controllers/auth/authentication_event.dart';
import 'package:hot_diamond_users/src/controllers/auth/authentication_state.dart';
import 'package:hot_diamond_users/src/services/auth_repository.dart';


class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository authRepository;
  AuthenticationBloc({required this.authRepository}) : super(AuthenticationInitial()) {
    //! Sign-Up Event
    on<SignUpEvent>((event, emit) async{
      emit(SignUpLoading());

      try{
        await authRepository.signUp(name: event.name, email: event.email, password: event.password, phoneNumber: event.phoneNumber);
        
        emit(SignUpSuccess());
      }catch(e){
        emit(SignUpFailure(error: e.toString()));
      }
    });

    //! Login Event
    on<SignInEvent>((event,emit)async{
      emit(LoginLoading());
      log('login loading');
      try{
        await authRepository.logIn(email: event.email, password: event.password);
        
        emit(LoginSuccess());
        log('logged');
      }catch(e){
        emit(LoginFailure(error:  e.toString()));
      }
    });

    //!Forgot Password Event
    on<ForgotPasswordEvent>((event, emit) async{
      emit(ForgotPasswordLoading());

      try{
        await authRepository.forgotPassword(event.email);
        emit(ForgotPasswordSuccess());
      }catch (e){
        emit(ForgotPasswordFailure(error:  e.toString()));
      }
    },);

    on<SignOutEvent>((event, emit) async {
      emit(LogOutLoading());
      try {
        await authRepository.signOut();
        
        emit(LogOutSuccess());
        log('Log out');
      } catch (e) {
        emit(LogOutFailure(error: e.toString()));
      }
    });


    on<GoogleSignInEvent>((event, emit) async {
      emit(GoogleLogInLoading());
      try {
        // await authRepository.googleSignIn();
        User? user = await authRepository.googleSignIn();
        if(user != null){
          emit(GoogleLogInSuccess());
        }
        
      } catch (e) {
        emit(GoogleLogInFailure(error: e.toString()));
      }
    });
  }
}
