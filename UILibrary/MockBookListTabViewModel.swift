import AbceedCore
import AbceedLogic

final class MockTopCategoryTabViewModel: TopCategoryTabViewModelType {
    let state: Property<State>
    init(state: State) {
        self.state = Property(state)
    }
}
