import AbceedCore
import AbceedLogic
import RxRelay
import RxSwift

final class BookDetailPresenterImpl: BookDetailPresenter {
    private let disposeBag = DisposeBag()
    private let bookDetailUseCase: BookDetailUseCase

    init(bookDetailUseCase: BookDetailUseCase) {
        self.bookDetailUseCase = bookDetailUseCase
     }

    func transform(book: Book, tapMybookButton: Observable<Void>) -> BookDetail.Input {
        let showMessage = PublishRelay<String>()
        let isMybook = bookDetailUseCase.isMybook(book.id)

        tapMybookButton
            .subscribe(onNext: { [weak self] in
                guard let me = self else { return }

                if isMybook.value {
                    me.bookDetailUseCase.unregisterMybook(book.id)
                } else {
                    me.bookDetailUseCase.registerMybook(book.id)
                }

                showMessage.accept(isMybook.value ? "Mybookへ追加しました。" : "Mybookから削除しました。")
            })
            .disposed(by: disposeBag)

        return BookDetail.Input(
            book: book,
            isMybook: isMybook,
            showMessage: showMessage.asObservable()
        )
    }
}
