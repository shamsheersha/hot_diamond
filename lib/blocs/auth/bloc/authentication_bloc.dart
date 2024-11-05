import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hot_diamond_users/blocs/auth/auth_bloc/authentication_event.dart';
import 'package:hot_diamond_users/blocs/auth/auth_bloc/authentication_state.dart';
import 'package:hot_diamond_users/services/auth_repository.dart';


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
        emit(SignUpFailture(error:  e.toString()));
      }
    });

    //! Login Event
    on<SignInEvent>((event,emit)async{
      emit(LoginLoading());
      
      try{
        await authRepository.logIn(email: event.email, password: event.password);
        emit(LoginSuccess());
      }catch(e){
        emit(LoginFailture(error:  e.toString()));
      }
    });

    //!Forgot Password Event
    on<SignOutEvent>((event, emit) async{
      emit(ForgotPasswordLoading());

      try{
        await authRepository.signOut();
        emit(ForgotPasswordSuccess());
      }catch (e){
        emit(ForgotPasswordFailture(error: e.toString()));
      }
    },);


    on<GoogleSignInEvent>((event, emit) async {
      emit(GoogleLogInLoading());
      try {
        await authRepository.googleSignIn();
        emit(GoogleLogInSuccess());
      } catch (e) {
        emit(GoogleLogInFailture(error: e.toString()));
      }
    });
  }
}
