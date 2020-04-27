import AbceedCore
import RxRelay
import RxSwift

final class MockTopCategoryTabViewModel: TopCategoryTabViewModelType {
    let navigateToBookDetail: Observable<Book>
    let _navigateToBookDetail = PublishRelay<Book>()

    let state: Property<TopCategoryTabState>
    init(state: TopCategoryTabState) {
        self.state = Property(state)
        navigateToBookDetail = _navigateToBookDetail.asObservable()
    }
}
