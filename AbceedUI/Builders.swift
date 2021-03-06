import AbceedCore
import AbceedLogic
import UIKit

public final class BookDetailBuilder {
    private let book: Book

    public init(book: Book) {
        self.book = book
    }

    public func build() -> UIViewController {
        let bookDetailUseCase = BookDetailUseCaseImpl(
            mybookRepository: MybookRepositoryImpl()
        )

        let presenter = BookDetailPresenterImpl(
            bookDetailUseCase: bookDetailUseCase
        )

        let vc = BookDetailViewController(book: book, presenter: presenter)

        return vc
    }
}

public final class TopCategoryTabBuilder {
    private let bookRepository: BookRepository

    public init(bookRepository: BookRepository = BookRepositoryImpl()) {
        self.bookRepository = bookRepository
    }

    public func build(_ scene: UIWindowScene) -> TopCategoryTabWireframe {
        let viewModel = TopCategoryTabViewModel(
            bookRepository: bookRepository,
            eventBus: EventBusPool.shared.getEventBus(forScene: scene)
        )

        let wireframe = TopCategoryTabWireframeImpl()

        let vc = TopCategoryTabViewController(viewModel: viewModel,
                                              wireframe: wireframe)

        let nc = UINavigationController(rootViewController: vc)
        nc.navigationBar.barTintColor = .white

        wireframe.navigationController = nc

        return wireframe
    }
}

public final class SubCategoryListBuilder {

    private let topCategory: TopCategory

    public init(topCategory: TopCategory) {
        self.topCategory = topCategory
    }

    public func build() -> UIViewController {
        let viewModel = SubCategoryListViewModel(topCategory: topCategory)
        return SubCategoryListViewController(viewModel: viewModel)
    }
}

public final class BookListBuilder {
    private let books: [Book]

    public init(books: [Book]) {
        self.books = books
    }

    public func build(_ scene: UIWindowScene) -> BookListViewModel {
        let eventBus = EventBusPool.shared.getEventBus(forScene: scene)
        let viewModel = BookListViewModel(books: books,
                                          eventBus: eventBus)

        return viewModel
    }
}
