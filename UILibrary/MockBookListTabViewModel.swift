import AbceedCore

final class MockTopCategoryTabViewModel: TopCategoryTabViewModelType {
    let state: Property<TopCategoryTabState>
    init(state: TopCategoryTabState) {
        self.state = Property(state)
    }
}
