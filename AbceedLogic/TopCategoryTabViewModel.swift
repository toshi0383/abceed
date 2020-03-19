import AbceedCore
import RxSwift

public protocol TopCategoryTabViewModelType {
    var state: Property<State> { get }
}

public enum State: Equatable {
    case successful([TopCategory])
    case error(String)
    case loading

    init(response: MockBookAllResponse?) {
        guard let res = response else {
            self = .error("データを取得できませんでした。")
            return
        }

        self = .successful(res.topCategories)
    }

    public var isLoading: Bool {
        return self == .loading
    }

    public var isSuccessful: Bool {
        if case .successful = self {
            return true
        }

        return false
    }

    public var topCategories: [TopCategory] {
        guard case .successful(let topCategories) = self else {
            return []
        }

        return topCategories
    }

    public func topCategory(at: Int) -> TopCategory? {
        return topCategories[at]
    }
}

public final class TopCategoryTabViewModel: TopCategoryTabViewModelType {
    public let state: Property<State>

    public init(bookRepository: BookRepository) {

        state = Property(
            initial: .loading,
            then: bookRepository.getAll()
                .optionalizeError()
                .map(State.init(response:))
        )

    }
}
