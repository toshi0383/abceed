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

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

extension SceneDelegate {

    private func defaultWireframe() -> Wireframe {
        let wireframe = TopCategoryTabBuilder(bookRepository: MockBookRepository()).build()
        return wireframe
    }

    private func bookDetailStory() -> Wireframe {
        let wf = TopCategoryTabBuilder(bookRepository: MockBookRepository()).build()
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
