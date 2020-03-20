import AbceedCore
import AbceedLogic
import RxSwift

final class MockBookRepository: BookRepository {

    private let mockResponse: Observable<MockBookAllResponse>

    init(_ mockResponse: Observable<MockBookAllResponse>) {
        self.mockResponse = mockResponse
    }

    func getAll() -> Observable<MockBookAllResponse> {
        return mockResponse
    }
}
