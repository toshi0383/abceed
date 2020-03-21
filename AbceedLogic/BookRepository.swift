import AbceedCore
import Foundation
import RxSwift

public final class BookRepositoryImpl: BookRepository {

    public init() {}

    public func getAll() -> Observable<MockBookAllResponse> {
        let url = URL(string: "https://2zw3cqudp7.execute-api.ap-northeast-1.amazonaws.com/dev/mock/book/all")!
        let req = URLRequest(url: url)
        return URLSession.shared.rx.data(request: req)
            .map {
                let decoder = JSONDecoder()
                return try decoder.decode(MockBookAllResponse.self, from: $0)
            }
    }
}
