import AbceedCore
import RxSwift

public protocol TopCategoryTabViewModelType {
    var state: Property<State> { get }
}

public enum State: Equatable {
    case successful([TopCategory])
    case error(String)
    case loading

    init(response: MockBookAllResponse?) {
        guard let res = response else {
            self = .error("データを取得できませんでした。")
            return
        }

        self = .successful(res.topCategories)
    }

    public var isLoading: Bool {
        return self == .loading
    }

    public var isSuccessful: Bool {
        if case .successful = self {
            return true
        }

        return false
    }

    public var topCategories: [TopCategory] {
        guard case .successful(let topCategories) = self else {
            return []
        }

        return topCategories
    }

    public func topCategory(at: Int) -> TopCategory? {
        return topCategories[at]
    }
}

public final class TopCategoryTabViewModel: TopCategoryTabViewModelType {
    public let state: Property<State>

    public init(bookRepository: BookRepository) {

        state = Property(
            initial: .loading,
            then: bookRepository.getAll()
                .optionalizeError()
                .map(State.init(response:))
        )

    }
}

public protocol SubCategoryListViewModelType {
    var topCategory: TopCategory { get }
    var subCategories: Property<[AbceedCore.Category]> { get }
}

public final class SubCategoryListViewModel: SubCategoryListViewModelType {
    public let topCategory: TopCategory
    public let subCategories: Property<[AbceedCore.Category]>

    public init(topCategory: TopCategory) {
        self.topCategory = topCategory
        self.subCategories = Property(topCategory.subCategories)
    }
}

public protocol BookListViewModelType {
    var books: Property<[Book]> { get }
}

public final class BookListViewModel: BookListViewModelType {
    public let books: Property<[Book]>

    public init(books: [Book]) {
        self.books = Property(books)
    }
}

public protocol BookDetailViewModelType {
    var book: Book { get }
    var isMybook: Property<Bool> { get }
}

public final class BookDetailViewModel: BookDetailViewModelType {
    public let book: Book
    public let isMybook: Property<Bool>
    private let mybookRepository: MybookRepository

    public init(book: Book, mybookRepository: MybookRepository) {
        self.book = book
        self.mybookRepository = mybookRepository
        isMybook = mybookRepository.isMybook(book.id)
    }
}
