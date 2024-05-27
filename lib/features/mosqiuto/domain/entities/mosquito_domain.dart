
import 'package:equatable/equatable.dart';

class Mosquito  extends Equatable{
  String? id;
  String name;
  String description;
  String detectedTime;

  void main() {
    var len = id!.length; // Runtime error: Null check operator used on a null value
  }
  Mosquito({
    this.id,
    required this.name,
    required this.description,
    required this.detectedTime,
  });

  @override
  List<Object?> get props =>[id,name,description,detectedTime];

}