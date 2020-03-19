import AbceedCore
import AbceedLogic
import UIKit

public protocol BookListWireframe {
    func navigateToBookDetail(book: Book)
}

public final class BookListWireframeImpl: BookListWireframe {
    public weak var viewController: UIViewController?

    public init() {}

    public func navigateToBookDetail(book: Book) {
        let vc = BookDetailBuilder(book: book).build()
        viewController?.present(vc, animated: true)
    }
}
