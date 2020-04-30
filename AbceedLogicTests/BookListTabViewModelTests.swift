import XCTest
import AbceedCore
import TestHelper
import RxSwift
@testable import AbceedLogic

final class TopCategoryTabViewModelTests: XCTestCase {
    func testStateSuccessful() {
        let eventBus = EventBusImpl()
        let t = TopCategoryTabViewModel(bookRepository: MockBookRepository(MockResponse.just), eventBus: eventBus)
        XCTAssertTrue(t.state.value.isSuccessful)
    }

    func testStateEmpty() {
        let eventBus = EventBusImpl()
        let t = TopCategoryTabViewModel(bookRepository: MockBookRepository(.empty()), eventBus: eventBus)
        XCTAssertEqual(t.state.value, .loading)
    }

    func testStateError() {
        let eventBus = EventBusImpl()
        let t = TopCategoryTabViewModel(bookRepository: MockBookRepository(MockResponse.error), eventBus: eventBus)
        XCTAssertEqual(t.state.value, .error("データを取得できませんでした。"))
    }
}

private enum MockResponse {
    static var error: Observable<MockBookAllResponse> {
        let e = NSError(domain: "jp.toshi0383.abceed", code: -1, userInfo: nil)
        return .error(e)
    }

    static var just: Observable<MockBookAllResponse> {
        let decoder = JSONDecoder()
        return .just(
            try! decoder.decode(MockBookAllResponse.self, from: readData("all_data.json"))
        )
    }

}
