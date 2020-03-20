import AbceedCore
import AbceedLogic
import UIKit

public protocol TopCategoryTabWireframe {
    func navigateToBookDetail(book: Book)
}

public final class TopCategoryTabWireframeImpl: TopCategoryTabWireframe {
    public weak var navigationController: UINavigationController?

    public init() {}

    public func navigateToBookDetail(book: Book) {
        let vc = BookDetailBuilder(book: book).build()
        navigationController?.pushViewController(vc, animated: true)
    }
}
