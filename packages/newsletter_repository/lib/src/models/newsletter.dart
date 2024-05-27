import 'package:equatable/equatable.dart';
import '../entities/newsletter_entity.dart';

class Newsletter extends Equatable {
  final String id;
  final String titulo;
  final String imagen;
  final String cuerpo;
    final String autor;
      final String fecha;

  const Newsletter({
    required this.id,
    required this.titulo,
    required this.imagen,
    required this.cuerpo,
    required this.autor,
    required this.fecha,
  });

  static var empty = Newsletter(
    id: '',
    titulo: '',
    imagen: '',
    cuerpo: '',
    autor: '',
    fecha: '',
  );

  Newsletter copyWith({
    String? id,
    String? titulo,
    String? imagen,
    String? cuerpo,
    String? autor,
    String? fecha,
  }) {
    return Newsletter(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      imagen: imagen ?? this.imagen,
      cuerpo: cuerpo ?? this.cuerpo,
      autor: autor ?? this.autor,
      fecha: fecha ?? this.fecha,
    );
  }

  NewsletterEntity toEntity() {
    return NewsletterEntity(
      id: id,
      titulo: titulo,
      imagen: imagen,
      cuerpo: cuerpo,
      autor: autor,
      fecha: fecha,
    );
  }

  static Newsletter fromEntity(NewsletterEntity entity) {
    return Newsletter(
      id: entity.id,
      titulo: entity.titulo,
      imagen: entity.imagen,
      cuerpo: entity.cuerpo,
      autor: entity.autor,
      fecha: entity.fecha,
    );
  }

  @override
  List<Object?> get props => [id, titulo, imagen, cuerpo, autor, fecha];
}