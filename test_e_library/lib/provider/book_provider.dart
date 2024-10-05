import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_e_library/model/book_model.dart';

class BookNotifier extends StateNotifier<Book> {
  BookNotifier()
      : super(Book(
            addedBy: '',
            title: '',
            author: '',
            description: '',
            pdfPath: '',
            isFavorite: false));

  void updateSelectedBook(Book param) {
    state = param;
  }

  void updateTitle(String newTittle) {
    state = state.copyWith(title: newTittle);
  }

  void updateDescription(String newDescription) {
    state = state.copyWith(description: newDescription);
  }

  void updateAuthor(String newAuthor) {
    state = state.copyWith(author: newAuthor);
  }

  void updateFavorite(bool fav) {
    state = state.copyWith(isFavorite: fav);
  }
}

final bookProvider =
    StateNotifierProvider<BookNotifier, Book>((ref) => BookNotifier());
