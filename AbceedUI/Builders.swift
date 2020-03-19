import AbceedCore
import AbceedLogic
import UIKit

final class BookDetailBuilder {
    private let book: Book

    init(book: Book) {
        self.book = book
    }

    func build() -> UIViewController {
        let viewModel = BookDetailViewModel(
            book: book,
            mybookRepository: MybookRepositoryImpl()
        )

        let vc = BookDetailViewController(viewModel: viewModel)

        return vc
    }
}

public final class TopCategoryTabBuilder {
    public init() {}

    public func build() -> UIViewController {
        let viewModel = TopCategoryTabViewModel(
            bookRepository: BookRepositoryImpl()
        )

        let wireframe = BookListWireframeImpl()

        let vc = TopCategoryTabViewController(viewModel: viewModel,
                                         wireframe: wireframe)
        wireframe.viewController = vc

        return vc
    }
}
