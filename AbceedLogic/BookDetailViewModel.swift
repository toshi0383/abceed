import AbceedCore
import RxRelay
import RxSwift

public final class BookDetailViewModel: BookDetailViewModelType {
    public let book: Book
    public let isMybook: Property<Bool>
    public let showMessage: Observable<String>

    private let _showMessage = PublishRelay<String>()
    private let mybookRepository: MybookRepository

    public init(book: Book, mybookRepository: MybookRepository) {
        self.book = book
        self.mybookRepository = mybookRepository
        isMybook = mybookRepository.isMybook(book.id)
        showMessage = _showMessage.asObservable()
    }

    public func tapMybookButton() {
        if isMybook.value {
            mybookRepository.unregisterMybook(book.id)
        } else {
            mybookRepository.registerMybook(book.id)
        }

        _showMessage.accept(isMybook.value ? "Mybookへ追加しました。" : "Mybookから削除しました。")
    }
}
