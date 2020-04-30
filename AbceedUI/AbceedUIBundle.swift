import UIKit

public enum AbceedUIBundle {}

extension AbceedUIBundle {
    public static let image = Image()

    public struct Image {
        public func leftArrow() -> UIImage {
            let path = Bundle.main.path(forResource: "AbceedUIBundle", ofType: "bundle")!
            return UIImage(named: "left-arrow", in: Bundle(path: path), compatibleWith: nil)!
        }
    }
}
