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

    func applyShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowRadius = 3
        layer.masksToBounds = false
    }
}

func / (_ size: CGSize, _ r: CGFloat) -> CGSize {
    return CGSize(width: size.width / r, height: size.height / r)
}
