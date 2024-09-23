
import '../../../core/base/repositories/base_repository.dart';
import '../../../core/services/local/cache_client.dart';
import '../../../core/services/network/api_client.dart';

class SocialAuthRepository extends BaseRepository {
  final ApiClient _apiClient;
  final CacheClient _cacheClient;

  SocialAuthRepository(this._apiClient, this._cacheClient, super.networkInfo);

  // Future<GoogleSignInAccount?> getGoogleAccount() async {
  //   final String clientId =
  //       Platform.isAndroid ? "" : "757102792557-4ffb89ctki5gj98lau22mrjdgua1s2jf.apps.googleusercontent.com";
  //   await GoogleSignIn(clientId: clientId).signOut();
  //   GoogleSignInAccount? account = await GoogleSignIn(clientId: clientId).signIn();
  //   return account;
  // }
  //
  // Future<Map<String, dynamic>> getFacebookAccount() async {
  //   await FacebookAuth.instance.logOut();
  //   final loginResult = await FacebookAuth.instance.login(loginBehavior: LoginBehavior.nativeWithFallback);
  //   final Map<String, dynamic> userData = await FacebookAuth.instance.getUserData();
  //   return {...userData, "access_token": loginResult.accessToken?.token};
  // }

  // Future<AuthorizationCredentialAppleID> getAppleCredentials() async {
  //   final credential = await SignInWithApple.getAppleIDCredential(
  //     scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
  //   );
  //   return credential;
  // }

  // Future<Either<Failure, UserModel>> googleSignIn(GoogleSignInAccount account) async {
  //   return super.call<UserModel>(
  //     httpRequest: () async {
  //       final response = await _apiClient.post(
  //         url: EndPoints.socialLogin,
  //         requestBody: {
  //           "google_id": account.id,
  //           "first_name": account.displayName,
  //           "email": account.email,
  //         },
  //       );
  //       await _cacheClient.saveSecuredData(StorageKeys.token, response.data["data"]["token"]);
  //       await _cacheClient.save(StorageKeys.isAuthed, true);
  //       return response;
  //     },
  //     successReturn: (data) => UserModel.fromJson(data),
  //   );
  // }
  //
  // Future<Either<Failure, UserModel>> facebookSignIn(Map<String, dynamic> userData) async {
  //   return super.call<UserModel>(
  //     httpRequest: () async {
  //       final response = await _apiClient.post(
  //         url: EndPoints.socialLogin,
  //         requestBody: {
  //           "provider_name": "facebook",
  //           "facebook_id": userData["id"],
  //           // "access_token": userData["access_token"],
  //           "first_name": userData["name"],
  //           "email": userData["email"],
  //           // "image": userData["picture"]["data"]["url"],
  //         },
  //       );
  //       await _cacheClient.saveSecuredData(StorageKeys.token, response.data["data"]["token"]);
  //       await _cacheClient.save(StorageKeys.isAuthed, true);
  //       return response;
  //     },
  //     successReturn: (data) => UserModel.fromJson(data["user"]),
  //   );
  // }

  // Future<Either<Failure, User>> appleSignIn(AuthorizationCredentialAppleID credential) async {
  //   return super.call<User>(
  //     httpRequest: () async {
  //       final response = await _apiClient.post(
  //         url: EndPoints.socialLogin,
  //         requestBody: {
  //           "provider_name": "apple",
  //           "provider_id": credential.userIdentifier,
  //           "access_token": credential.identityToken,
  //           "name": "${credential.givenName} ${credential.familyName}",
  //           "email": credential.email,
  //           "image": "",
  //         },
  //       );
  //       await _cacheClient.saveSecuredData(StorageKeys.token, response.data["data"]["token"]);
  //       await _cacheClient.save(StorageKeys.isAuthed, true);
  //       return response;
  //     },
  //     successReturn: (data) => User.fromJson(data["user"]),
  //   );
  // }
}
