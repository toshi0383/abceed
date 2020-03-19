import AbceedCore
import AbceedUI

final class MockBookListWireframe: BookListWireframe {
    private(set) var _navigateToBookDetailCalled: Book?

    func navigateToBookDetail(book: Book) {
        _navigateToBookDetailCalled = book
    }
}
