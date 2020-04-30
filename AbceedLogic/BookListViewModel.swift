import AbceedCore

// TODO: Separate into Presenter and UseCase
public final class BookListViewModel: BookListViewModelType {
    public let books: Property<[Book]>
    private let eventBus: EventBus

    public init(books: [Book],
                eventBus: EventBus) {
        self.books = Property(books)
        self.eventBus = eventBus
    }

    public func select(_ book: Book) {
        eventBus.accept(SelectBook(book))
    }
}
