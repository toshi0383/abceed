import UIKit

final class SubCategoryHeaderView: UITableViewHeaderFooterView {
    var title: String? {
        set {
            label.text = newValue
        }
        get {
            return label.text
        }
    }

    private let base = UIView()
    private let label = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        // NOTE: setting self.backgroundColor is deprecated.
        base.backgroundColor = .clear
        backgroundView = base

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)

        contentView.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
