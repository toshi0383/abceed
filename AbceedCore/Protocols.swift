import RxSwift

public protocol SubCategoryListViewModelType {
    var topCategory: TopCategory { get }
    var subCategories: Property<[AbceedCore.Category]> { get }
}

public protocol TopCategoryTabViewModelType {
    var state: Property<TopCategoryTabState> { get }
}

public protocol BookListViewModelType {
    var books: Property<[Book]> { get }
}

public protocol BookDetailViewModelType {
    var book: Book { get }
    var isMybook: Property<Bool> { get }
    var showMessage: Observable<String> { get }
    func tapMybookButton()
}

public protocol BookRepository {
    func getAll() -> Observable<MockBookAllResponse>
}

public protocol MybookRepository {
    func isMybook(_ bookID: String) -> AbceedCore.Property<Bool>
    func registerMybook(_ bookID: String)
    func unregisterMybook(_ bookID: String)
}
