import AbceedCore

public final class BookListViewModel: BookListViewModelType {
    public let books: Property<[Book]>

    public init(books: [Book]) {
        self.books = Property(books)
    }
}
