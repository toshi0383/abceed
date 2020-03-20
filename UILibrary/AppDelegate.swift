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

private func topCategoryWithSingleSubCategory() -> TopCategory {
    let data = readData("single_subcategory.json")
    let decoder = JSONDecoder()
    let c = try! decoder.decode(TopCategory.self, from: data)
    return c
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private let viewModel = MockTopCategoryTabViewModel(state: .successful(allData()))
    private let wireframe = MockBookListWireframe()

    private func makeVC() -> UIViewController {
        let topnc = TopCategoryTabBuilder(bookRepository: MockBookRepository()).build()
        return topnc
//        let decoder = JSONDecoder()
//        let book = try! decoder.decode(Book.self, from: readData("book.json"))
//        let detail = BookDetailBuilder(book: book).build()

//        topnc.pushViewController(detail, animated: true)
//        let vm = SubCategoryListViewModel(topCategory: topCategoryWithSingleSubCategory())
//        let sub = SubCategoryListViewController(viewModel: vm)
//        let nc = UINavigationController(rootViewController: sub)
//
//        return nc
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.rootViewController = makeVC()
        window.makeKeyAndVisible()

        return true
    }
}
