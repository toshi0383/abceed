import RxSwift

public protocol SubCategoryListViewModelType {
    var topCategory: TopCategory { get }
    var subCategories: Property<[AbceedCore.Category]> { get }
}

public protocol TopCategoryTabViewModelType {
    var state: Property<TopCategoryTabState> { get }
    var navigateToBookDetail: Observable<Book> { get }
}

public protocol BookListViewModelType {
    var books: Property<[Book]> { get }
    func select(_ book: Book)
}

public protocol BookRepository {
    func getAll() -> Observable<MockBookAllResponse>
}

public protocol EventBus {
    func accept(_ event: EventType)
    func observe<T>(_ eventType: T.Type) -> Observable<T>
}

public protocol MybookRepository {
    func isMybook(_ bookID: String) -> AbceedCore.Property<Bool>
    func registerMybook(_ bookID: String)
    func unregisterMybook(_ bookID: String)
}

public protocol BookDetailUseCase {
    func isMybook(_ bookID: String) -> AbceedCore.Property<Bool>
    func registerMybook(_ bookID: String)
    func unregisterMybook(_ bookID: String)
}

public protocol BookDetailPresenter {
    func transform(book: Book, tapMybookButton: Observable<Void>) -> BookDetail.Input
}

public enum BookDetail {

    /// A struct which stands for both:
    /// - Final input of dedicated ViewController
    /// - Output of dedicated Presenter
    public struct Input {
        public let book: Book
        public let isMybook: AbceedCore.Property<Bool>
        public let showMessage: Observable<String>

        public init(book: Book,
                    isMybook: AbceedCore.Property<Bool>,
                    showMessage: Observable<String>) {

            self.book = book
            self.isMybook = isMybook
            self.showMessage = showMessage
        }
    }
}
