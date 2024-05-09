import 'package:equatable/equatable.dart';
import '../entities/newsletter_entity.dart';

class Newsletter extends Equatable {
  final String id;
  final String titulo;
  final String imagen;
  final String cuerpo;

  const Newsletter({
    required this.id,
    required this.titulo,
    required this.imagen,
    required this.cuerpo,
  });

  static var empty = Newsletter(
    id: '',
    titulo: '',
    imagen: '',
    cuerpo: '',
  );

  Newsletter copyWith({
    String? id,
    String? titulo,
    String? imagen,
    String? cuerpo,
  }) {
    return Newsletter(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      imagen: imagen ?? this.imagen,
      cuerpo: cuerpo ?? this.cuerpo,
    );
  }

  NewsletterEntity toEntity() {
    return NewsletterEntity(
      id: id,
      titulo: titulo,
      imagen: imagen,
      cuerpo: cuerpo,
    );
  }

  static Newsletter fromEntity(NewsletterEntity entity) {
    return Newsletter(
      id: entity.id,
      titulo: entity.titulo,
      imagen: entity.imagen,
      cuerpo: entity.cuerpo,
    );
  }

  @override
  List<Object?> get props => [id, titulo, imagen, cuerpo];
}