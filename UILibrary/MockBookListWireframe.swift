import AbceedCore
import AbceedUI
import UIKit

final class MockBookListWireframe: TopCategoryTabWireframe {
    var navigationController: UINavigationController?

    private(set) var _navigateToBookDetailCalled: Book?

    func navigateToBookDetail(book: Book) {
        _navigateToBookDetailCalled = book
    }
}
