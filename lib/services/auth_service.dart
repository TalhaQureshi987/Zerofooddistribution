class AuthService {
  // This simulates whether a user is logged in or not.
  static bool isLoggedIn = false;

  // Simulate a login process
  static void login(String email, String password) {
    if (email.isNotEmpty && password.isNotEmpty) {
      isLoggedIn = true;
    }
  }

  // Simulate a registration process
  static void register(String name, String email, String password) {
    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      isLoggedIn = true;
    }
  }

  // Simulate logout
  static void logout() {
    isLoggedIn = false;
  }
}
