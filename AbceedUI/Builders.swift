import AbceedCore
import AbceedLogic
import UIKit

public final class BookDetailBuilder {
    private let book: Book

    public init(book: Book) {
        self.book = book
    }

    public func build() -> UIViewController {
        let viewModel = BookDetailViewModel(
            book: book,
            mybookRepository: MybookRepositoryImpl()
        )

        let vc = BookDetailViewController(viewModel: viewModel)

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
            eventRepository: EventRepositoryPool.shared.getEventRepository(forScene: scene)
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
        let eventRepository = EventRepositoryPool.shared.getEventRepository(forScene: scene)
        let viewModel = BookListViewModel(books: books,
                                          eventRepository: eventRepository)

        return viewModel
    }
}
