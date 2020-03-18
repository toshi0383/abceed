import AbceedUI
import AbceedCore
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private let viewModel = TopCategoryTabViewModel()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.rootViewController = TopCategoryTabViewController(viewModel: viewModel)
        window.makeKeyAndVisible()

        return true
    }
}
