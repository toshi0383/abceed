import Foundation

class TestHelper {}

public func readData(_ filename: String) -> Data {
    let url = Bundle(for: TestHelper.self).url(forResource: filename, withExtension: nil)!
    return try! Data(contentsOf: url)
}
