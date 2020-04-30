import AbceedCore
import RxSwift

// TODO: Separate into Presenter and UseCase
public final class TopCategoryTabViewModel: TopCategoryTabViewModelType {
    public let state: Property<TopCategoryTabState>
    public var navigateToBookDetail: Observable<Book>

    public init(bookRepository: BookRepository,
                eventBus: EventBus) {

        state = Property(
            initial: .loading,
            then: bookRepository.getAll()
                .optionalizeError()
                .map(TopCategoryTabState.init(response:))
        )

        navigateToBookDetail = eventBus.observe(SelectBook.self)
            .map { $0.book }
    }
}
