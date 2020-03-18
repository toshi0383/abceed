import AbceedUI
import AbceedCore
import AbceedLogic
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

    private let viewModel = MockTopCategoryTabViewModel(state: .successful(allData()))

    private func makeVC() -> UIViewController {
        return TopCategoryTabViewController(viewModel: viewModel)
//        let viewModel = SubCategoryListViewModel(topCategory: allData()[0])
//        let vc = SubCategoryListViewController(viewModel: viewModel)
//        return vc
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.rootViewController = makeVC()
        window.makeKeyAndVisible()

        return true
    }
}
