import '../../domain/entities/Template.dart';

class TemplateModel extends Template{
  TemplateModel({required super.id});

  factory TemplateModel.fromTemplate(Template Template){
    return TemplateModel(
        id: Template.id
    );
  }

  Map<String, dynamic> toMap() {
    return {};
  }

  factory TemplateModel.fromMap(Map<String, dynamic> map) {
    return TemplateModel(id: map['id']);
  }
}