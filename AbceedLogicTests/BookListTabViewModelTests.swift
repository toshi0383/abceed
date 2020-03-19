import XCTest
import AbceedCore
import TestHelper
import RxSwift
@testable import AbceedLogic

final class TopCategoryTabViewModelTests: XCTestCase {
    func testStateSuccessful() {
        let t = TopCategoryTabViewModel(bookRepository: MockBookRepository(MockResponse.just))
        XCTAssertTrue(t.state.value.isSuccessful)
    }

    func testStateEmpty() {
        let t = TopCategoryTabViewModel(bookRepository: MockBookRepository(.empty()))
        XCTAssertEqual(t.state.value, .loading)
    }

    func testStateError() {
        let t = TopCategoryTabViewModel(bookRepository: MockBookRepository(MockResponse.error))
        XCTAssertEqual(t.state.value, .error("データを取得できませんでした。"))
    }
}

final class MockBookRepository: BookRepository {

    private let mockResponse: Observable<MockBookAllResponse>

    init(_ mockResponse: Observable<MockBookAllResponse>) {
        self.mockResponse = mockResponse
    }

    func getAll() -> Observable<MockBookAllResponse> {
        return mockResponse
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
