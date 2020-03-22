import AbceedCore
import AbceedUI
import TestHelper
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.rootViewController = defaultStory() // change here
        window.makeKeyAndVisible()

        return true
    }
}

extension AppDelegate {

    private func defaultStory() -> UIViewController {
        let topnc = TopCategoryTabBuilder(bookRepository: MockBookRepository()).build()
        return topnc
    }

    private func bookDetailStory() -> UIViewController {
        let topnc = TopCategoryTabBuilder(bookRepository: MockBookRepository()).build()
        let decoder = JSONDecoder()
        let book = try! decoder.decode(Book.self, from: readData("book.json"))
        let detail = BookDetailBuilder(book: book).build()

        topnc.pushViewController(detail, animated: true)
        return topnc
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

