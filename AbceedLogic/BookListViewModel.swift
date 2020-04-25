import AbceedCore

public final class BookListViewModel: BookListViewModelType {
    public let books: Property<[Book]>
    private let eventRepository: EventRepository

    public init(books: [Book],
                eventRepository: EventRepository) {
        self.books = Property(books)
        self.eventRepository = eventRepository
    }

    public func select(_ book: Book) {
        eventRepository.accept(.select(book))
    }
}
