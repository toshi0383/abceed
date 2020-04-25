import AbceedCore
import AbceedLogic
import UIKit

public protocol Wireframe {
    var viewController: UIViewController? { get }
    func handleUserActivity(_ userActivity: NSUserActivity)
}

extension Wireframe {
    public func handleUserActivity(_ userActivity: NSUserActivity) {}
}

public protocol TopCategoryTabWireframe: Wireframe {
    var navigationController: UINavigationController? { get }
    func navigateToBookDetail(book: Book)
}

extension TopCategoryTabWireframe {
    public var viewController: UIViewController? {
        return navigationController
    }
}

public final class TopCategoryTabWireframeImpl: TopCategoryTabWireframe {
    public weak var navigationController: UINavigationController?

    public init() {}

    public func navigateToBookDetail(book: Book) {
        let vc = BookDetailBuilder(book: book).build()
        navigationController?.pushViewController(vc, animated: true)
    }

    public func handleUserActivity(_ userActivity: NSUserActivity) {
        guard let data = userActivity.userInfo?["book"] as? Data else { return }

        let decoder = JSONDecoder()
        let book = try! decoder.decode(Book.self, from: data)

        navigateToBookDetail(book: book)
    }
}
