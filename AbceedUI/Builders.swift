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

    public func build() -> UINavigationController {
        let viewModel = TopCategoryTabViewModel(
            bookRepository: bookRepository
        )

        let wireframe = TopCategoryTabWireframeImpl()

        let vc = TopCategoryTabViewController(viewModel: viewModel,
                                              wireframe: wireframe)

        let nc = UINavigationController(rootViewController: vc)

        wireframe.navigationController = nc

        return nc
    }
}
