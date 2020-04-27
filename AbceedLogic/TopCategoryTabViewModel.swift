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

        navigateToBookDetail = eventRepository.observe(SelectBook.self)
            .map { $0.book }
    }
}
