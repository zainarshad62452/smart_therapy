class Exercise {
  String uid;
  DateTime date;
  double forwardFlexion;
  double scapularRetractions;
  double kneesStretch;
  double seatedLegRaises;
  double chinToChest;
  double legAngle;
  double armAngle;

  Exercise({
    required this.uid,
    required this.date,
    this.forwardFlexion = 0.0,
    this.scapularRetractions = 0.0,
    this.kneesStretch = 0.0,
    this.seatedLegRaises = 0.0,
    this.chinToChest = 0.0,
    this.legAngle = 0.0,
    this.armAngle = 0.0,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      uid: json['uid'],
      date: json['date'].toDate(), // Convert Firestore Timestamp to DateTime
      forwardFlexion: json['exerciseItem1'],
      scapularRetractions: json['exerciseItem2'],
      kneesStretch: json['exerciseItem3'],
      seatedLegRaises: json['exerciseItem4'],
      chinToChest: json['exerciseItem5'],
      legAngle: json['legAngle'],
      armAngle: json['armAngle'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'date': date,
      'exerciseItem1': forwardFlexion,
      'exerciseItem2': scapularRetractions,
      'exerciseItem3': kneesStretch,
      'exerciseItem4': seatedLegRaises,
      'exerciseItem5': chinToChest,
      'legAngle': legAngle,
      'armAngle': armAngle,
    };
  }
}
