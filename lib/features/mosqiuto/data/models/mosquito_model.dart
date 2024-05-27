class MosquitoModel {
  final String name;
  final double confidence;
  final String time; // Add this line

  MosquitoModel({
    required this.name,
    required this.confidence,
    required this.time, // Add this line
  });

  factory MosquitoModel.fromJson(Map<String, dynamic> json) {
    return MosquitoModel(
      name: json['name'] ?? '',
      confidence: json['confidence'] != null ? json['confidence'].toDouble() : 0.0,
      time: json['time'] ?? '', // Add this line
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "confidence": confidence,
      "time": time, // Add this line
    };
  }
}
