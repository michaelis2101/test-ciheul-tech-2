class Book {
  int? id;
  String addedBy;
  String title;
  String author;
  String description;
  String pdfPath;
  bool isFavorite;

  Book({
    this.id,
    required this.addedBy,
    required this.title,
    required this.author,
    this.description = '',
    required this.pdfPath,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'added_by': addedBy,
      'title': title,
      'author': author,
      'description': description,
      'pdf_path': pdfPath,
      'is_favorite': isFavorite ? 1 : 0,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      addedBy: map['added_by'],
      title: map['title'],
      author: map['author'],
      description: map['description'],
      pdfPath: map['pdf_path'],
      isFavorite: map['is_favorite'] == 1,
    );
  }

  Book copyWith({
    int? id,
    String? addedBy,
    String? title,
    String? author,
    String? description,
    String? pdfPath,
    bool? isFavorite,
  }) {
    return Book(
      id: id ?? this.id,
      addedBy: addedBy ?? this.addedBy,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      pdfPath: pdfPath ?? this.pdfPath,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
