import 'package:mockito/annotations.dart';
import 'package:auth_app/features/auth/domain/usecase/get_current_user_usecase.dart';
import 'package:auth_app/features/auth/domain/usecase/sign_in_usecase.dart';
import 'package:auth_app/features/auth/domain/usecase/sign_up_usecase.dart';
import 'package:auth_app/features/auth/domain/usecase/sign_out_usecase.dart';
import 'package:auth_app/features/auth/domain/usecase/sign_in_with_google_usecase.dart';

@GenerateMocks([
  SignInUseCase,
  SignUpUseCase,
  SignOutUseCase,
  GetCurrentUserUseCase,
  SignInWithGoogleUseCase,
])
void main() {}
