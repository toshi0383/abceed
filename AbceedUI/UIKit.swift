import UIKit

extension UIView {
    func pinEdges(_ other: UIView) {
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: other.leadingAnchor),
            trailingAnchor.constraint(equalTo: other.trailingAnchor),
            topAnchor.constraint(equalTo: other.topAnchor),
            bottomAnchor.constraint(equalTo: other.bottomAnchor),
        ])
    }

    func pinCenter(_ other: UIView) {
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: other.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: other.centerYAnchor),
        ])
    }
}
