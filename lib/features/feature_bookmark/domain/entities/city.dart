import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

@entity
class City extends Equatable{
  ///columns
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name;

  City(this.name, this.id);

  @override
  // TODO: implement props
  List<Object?> get props => [

  ];

}