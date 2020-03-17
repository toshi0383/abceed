import AbceedCore
import AbceedLogic

final class MockBookListTabViewModel: BookListTabViewModelType {
    let state: Property<State>
    init(state: State) {
        self.state = Property(state)
    }
}
