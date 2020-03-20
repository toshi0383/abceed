import AbceedCore
import AbceedLogic
import UIKit

public protocol BookListWireframe {
    func navigateToBookDetail(book: Book)
}

public final class BookListWireframeImpl: BookListWireframe {
    public weak var navigationController: UINavigationController?

    public init() {}

    public func navigateToBookDetail(book: Book) {
        let vc = BookDetailBuilder(book: book).build()
        navigationController?.pushViewController(vc, animated: true)
    }
}
