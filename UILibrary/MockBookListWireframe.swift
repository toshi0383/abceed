import AbceedCore
import AbceedUI

final class MockBookListWireframe: TopCategoryTabWireframe {
    private(set) var _navigateToBookDetailCalled: Book?

    func navigateToBookDetail(book: Book) {
        _navigateToBookDetailCalled = book
    }
}
