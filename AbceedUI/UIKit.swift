import UIKit

extension UIView {
    func pinEdges(_ layoutGuide: UILayoutGuide) {
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
        ])
    }

    func pinEdges(_ other: UIView) {
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: other.leadingAnchor),
            trailingAnchor.constraint(equalTo: other.trailingAnchor),
            topAnchor.constraint(equalTo: other.topAnchor),
            bottomAnchor.constraint(equalTo: other.bottomAnchor),
        ])
    }

    func pinCenter(inParent parent: UIView) {
        NSLayoutConstraint.activate([
            parent.centerXAnchor.constraint(equalTo: centerXAnchor),
            parent.centerYAnchor.constraint(equalTo: centerYAnchor),
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

func + (_ l: UIEdgeInsets, _ r: UIEdgeInsets) -> UIEdgeInsets {
    return UIEdgeInsets(top: l.top + r.top, left: l.left + r.left, bottom: l.bottom + r.bottom, right: l.right + r.right)
}

extension UIStackView {
    static func horizontal(spacing: CGFloat) -> UIStackView {
        let v = UIStackView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.axis = .horizontal
        v.spacing = spacing
        return v
    }

    static func vertical(spacing: CGFloat) -> UIStackView {
        let v = UIStackView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.axis = .vertical
        v.spacing = spacing
        return v
    }
}
