import AbceedCore
import Realm
import RealmSwift
import RxRelay

/// 簡略化のためDataStoreの役割も兼ねる。大きくなってきたらDataStoreにリファクタ想定。
public class MybookRepositoryImpl: MybookRepository {

    private var mybooks: [String] = restoreMybooks() {
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

        let realm = try! Realm()
        try! realm.write {
            realm.add(Mybook(id: bookID))
        }
    }

    public func unregisterMybook(_ bookID: String) {
        if let idx = mybooks.firstIndex(of: bookID) {
            mybooks.remove(at: idx)
        }

        let realm = try! Realm()

        try! realm.write {
            if let o = realm.object(ofType: Mybook.self, forPrimaryKey: bookID) {
                realm.delete(o)
            }
        }
    }
}

final class Mybook: Object {

    @objc dynamic var id = ""

    init(id: String) {
        self.id = id
    }

    required init() {
        super.init()
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}

private func restoreMybooks() -> [String] {
    let realm = try! Realm()
    return realm.objects(Mybook.self).map { $0.id }
}
