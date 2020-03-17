import XCTest
import TestHelper
@testable import AbceedCore

class DecodableTests: XCTestCase {

    func testDecodeResponse() {
        let data = readData("all_data.json")

        do {
            let decoder = JSONDecoder()
            let res = try decoder.decode(MockBookAllResponse.self, from: data)
            XCTAssertEqual(res.topCategories.count, 5)
            let book = res.topCategories[0].subCategories[0].books[0]

            XCTAssertEqual(book.id,        "tokyu_kinhure_new")
            XCTAssertEqual(book.name,      "TOEIC L&R TEST 出る単特急 金のフレーズ")
            XCTAssertEqual(book.author,    "TEX 加藤")
            XCTAssertEqual(book.publisher, "朝日新聞出版")
            XCTAssertEqual(book.imgURL,    "https://d3grtcc7imzgqe.cloudfront.net/img/book_small/tokyu_kinhure_new.jpg")

        } catch {
            XCTFail("Failed to parse json with error: \(error)")
        }
    }
}
