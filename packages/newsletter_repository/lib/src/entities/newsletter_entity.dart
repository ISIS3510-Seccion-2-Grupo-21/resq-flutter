import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class NewsletterEntity extends Equatable {
  final String id;
  final String titulo;
  final String imagen;
  final String cuerpo;
  final String autor;
  final String fecha;

  const NewsletterEntity({
    required this.id,
    required this.titulo,
    required this.imagen,
    required this.cuerpo,
    required this.autor,
    required this.fecha,
  });

  Map<String, Object?> toDocument() {
    return {
      'id': id,
      'titulo': titulo,
      'imagen': imagen,
      'cuerpo': cuerpo,
      'autor': autor,
      'fecha': fecha,
    };
  }

  static NewsletterEntity fromDocument(Map<String, dynamic> doc) {
    return NewsletterEntity(
      id: doc['id'] as String,
      titulo: doc['titulo'] as String,
      imagen: doc['imagen'] as String,
      cuerpo: doc['cuerpo'] as String,
      autor: doc['autor'] as String,
      fecha: doc['fehca'] as String,
    );
  }

  @override
  List<Object?> get props => [id, titulo, imagen, cuerpo, autor, fecha];
}