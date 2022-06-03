class AuthResponse {
  final String localId;
  final String email;
  final String idToken;
  final String refreshToken;
  final String expiresIn;

  AuthResponse(
    this.localId,
    this.email,
    this.idToken,
    this.refreshToken,
    this.expiresIn,
  );

  AuthResponse.fromMap(Map<String, dynamic> data)
      : localId = data['localId'] ?? '',
        email = data['email'] ?? '',
        idToken = data['idToken'] ?? '',
        refreshToken = data['refreshToken'] ?? '',
        expiresIn = data['expiresIn'] ?? '';

  Map<String, dynamic> toMap() {
    return {
      'localId': localId,
      'email': email,
      'idToken': idToken,
      'refreshToken': refreshToken,
      'expiresIn': expiresIn,
    };
  }
}
