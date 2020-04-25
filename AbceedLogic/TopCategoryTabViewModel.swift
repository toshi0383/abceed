import AbceedCore
import RxSwift

public final class TopCategoryTabViewModel: TopCategoryTabViewModelType {
    public let state: Property<TopCategoryTabState>
    public var navigateToBookDetail: Observable<Book>

    public init(bookRepository: BookRepository,
                eventRepository: EventRepository) {

        state = Property(
            initial: .loading,
            then: bookRepository.getAll()
                .optionalizeError()
                .map(TopCategoryTabState.init(response:))
        )

        navigateToBookDetail = eventRepository.event.flatMap { event -> Observable<Book> in
            guard case let .select(book) = event else { return .empty() }

            return .just(book)
        }
    }
}
