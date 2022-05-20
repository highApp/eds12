// Singleton class

class Datamanager {
  static final Datamanager _singleton = Datamanager._internal();

  factory Datamanager() {
    return _singleton;
  }

  Datamanager._internal();
  String userRole = ''; /// "0" for devotee and "1" for minister
  
}