import SwiftUI

extension EdgeInsets {
    var vertical: CGFloat {
        return top + bottom
    }

    var horizontal: CGFloat {
        return leading + trailing
    }
}
