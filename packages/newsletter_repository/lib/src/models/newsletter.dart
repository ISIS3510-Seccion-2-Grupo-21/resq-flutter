import 'package:equatable/equatable.dart';
import '../entities/newsletter_entity.dart';

class Newsletter extends Equatable {
  final String titulo;
  final String imagen;
  final String cuerpo;

  const Newsletter({
    required this.titulo,
    required this.imagen,
    required this.cuerpo,
  });

  static var empty = Newsletter(
    titulo: '',
    imagen: '',
    cuerpo: '',
  );

  Newsletter copyWith({
    String? titulo,
    String? imagen,
    String? cuerpo,
  }) {
    return Newsletter(
      titulo: titulo ?? this.titulo,
      imagen: imagen ?? this.imagen,
      cuerpo: cuerpo ?? this.cuerpo,
    );
  }

  NewsletterEntity toEntity() {
    return NewsletterEntity(
      titulo: titulo,
      imagen: imagen,
      cuerpo: cuerpo,
    );
  }

  static Newsletter fromEntity(NewsletterEntity entity) {
    return Newsletter(
      titulo: entity.titulo,
      imagen: entity.imagen,
      cuerpo: entity.cuerpo,
    );
  }

  @override
  List<Object?> get props => [titulo, imagen, cuerpo];
}