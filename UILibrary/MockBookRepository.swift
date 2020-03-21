import AbceedCore
import Foundation
import RxSwift
import TestHelper

final class MockBookRepository: BookRepository {
    func getAll() -> Observable<MockBookAllResponse> {
        let decoder = JSONDecoder()
        let res = try! decoder.decode(MockBookAllResponse.self, from: readData("all_data.json"))
        return .just(res)
    }
}
