import AbceedCore

public protocol BookDetailViewModelType {
    var book: Book { get }
    var isMybook: Property<Bool> { get }
    func tapMybookButton()
}

public final class BookDetailViewModel: BookDetailViewModelType {
    public let book: Book
    public let isMybook: Property<Bool>
    private let mybookRepository: MybookRepository

    public init(book: Book, mybookRepository: MybookRepository) {
        self.book = book
        self.mybookRepository = mybookRepository
        isMybook = mybookRepository.isMybook(book.id)
    }

    public func tapMybookButton() {
        if isMybook.value {
            mybookRepository.unregisterMybook(book.id)
        } else {
            mybookRepository.registerMybook(book.id)
        }
    }
}
