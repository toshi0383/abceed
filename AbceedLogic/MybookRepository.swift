import AbceedCore
import RxRelay
import Realm
import RealmSwift

public protocol MybookRepository {
    func isMybook(_ bookID: String) -> AbceedCore.Property<Bool>
    func registerMybook(_ bookID: String)
    func unregisterMybook(_ bookID: String)
}

public class MybookRepositoryImpl: MybookRepository {
    private var mybooks: [String] = [] {
        didSet {
            mybooksRelay.accept(mybooks)
        }
    }

    private let mybooksRelay = PublishRelay<[String]>()

    public init() {}

    public func isMybook(_ bookID: String) -> AbceedCore.Property<Bool> {
        return Property(
            initial: mybooks.contains(bookID),
            then: mybooksRelay.asObservable().map { $0.contains(bookID) }
        )
    }

    public func registerMybook(_ bookID: String) {
        mybooks.append(bookID)


    }

    public func unregisterMybook(_ bookID: String) {
        if let idx = mybooks.firstIndex(of: bookID) {
            mybooks.remove(at: idx)
        }
    }
}

final class Mybook: Object {
    @objc dynamic var id = ""

    override static func primaryKey() -> String? {
        return "id"
    }
}
