import AbceedCore
import AbceedUI
import TestHelper
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var wireframe: Wireframe?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let scene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: scene)
        self.window = window
        let wf = defaultWireframe() // change here
        wireframe = wf

        window.rootViewController = wf.viewController
        window.makeKeyAndVisible()

        if let userActivity = connectionOptions.userActivities.first ?? session.stateRestorationActivity {
            wf.handleUserActivity(userActivity)
        }
    }

    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        return scene.userActivity
    }
}

extension SceneDelegate {

    private func defaultWireframe() -> Wireframe {
        let wireframe = TopCategoryTabBuilder(bookRepository: MockBookRepository()).build(window!.windowScene!)
        return wireframe
    }

    private func bookDetailStory() -> Wireframe {
        let wf = TopCategoryTabBuilder(bookRepository: MockBookRepository()).build(window!.windowScene!)
        guard let topnc = wf.navigationController else { fatalError() }
        let decoder = JSONDecoder()
        let book = try! decoder.decode(Book.self, from: readData("book.json"))
        let detail = BookDetailBuilder(book: book).build()

        topnc.pushViewController(detail, animated: true)
        return wf
    }

    private func singlePage() -> UIViewController {
        let sub = SubCategoryListBuilder(topCategory: topCategoryWithSingleSubCategory()).build()
        return sub
    }
}

private func allData() -> [TopCategory] {
    let data = readData("all_data.json")
    let decoder = JSONDecoder()
    let res = try! decoder.decode(MockBookAllResponse.self, from: data)
    return res.topCategories
}

private func topCategoryWithSingleSubCategory() -> TopCategory {
    let data = readData("single_subcategory.json")
    let decoder = JSONDecoder()
    let c = try! decoder.decode(TopCategory.self, from: data)
    return c
}
