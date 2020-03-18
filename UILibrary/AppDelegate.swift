import AbceedUI
import AbceedCore
import TestHelper
import UIKit

private func allData() -> [TopCategory] {
    let data = readData("all_data.json")
    let decoder = JSONDecoder()
    let res = try! decoder.decode(MockBookAllResponse.self, from: data)
    return res.topCategories
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private let viewModel = MockBookListTabViewModel(state: .successful(allData()))

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.rootViewController = BookListTabViewController(viewModel: viewModel)
        window.makeKeyAndVisible()

        return true
    }
}
