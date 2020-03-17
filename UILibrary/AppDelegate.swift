import AbceedUI
import AbceedCore
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private let viewModel = MockBookListTabViewModel(state: .error("データを取得できませんでした。"))

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.rootViewController = BookListTabViewController(viewModel: viewModel)
        window.makeKeyAndVisible()

        return true
    }
}
