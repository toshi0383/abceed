import AbceedLogic
import UIKit

public final class SubCategoryListViewController: UITableViewController {
    private let viewModel: SubCategoryListViewModelType
    private let cellID = "bookListCollectionCell"
    private let headerID = "subCategoryHeaderView"

    public init(viewModel: SubCategoryListViewModelType) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(BookListCollectionCell.self, forCellReuseIdentifier: cellID)
        tableView.register(SubCategoryHeaderView.self, forHeaderFooterViewReuseIdentifier: headerID)
    }

    // MARK: UITableView

    override public func numberOfSections(in tableView: UITableView) -> Int {
        print("\(viewModel.topCategory.name): \(viewModel.subCategories.value.count)")
        return viewModel.subCategories.value.count
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerID) as! SubCategoryHeaderView
        header.title = viewModel.subCategories.value[section].name
        return header
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)! as! BookListCollectionCell
        let section = indexPath.section
        cell.configure(BookListViewModel(books: viewModel.subCategories.value[section].books))
        return cell
    }

    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BookCell.fixedHeight / 2 + BookListCollectionCell.verticalMargin
    }
}

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

        base.translatesAutoresizingMaskIntoConstraints = false
        base.backgroundColor = .white
        contentView.addSubview(base)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)

        base.addSubview(label)
        base.pinEdges(contentView)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: base.topAnchor, constant: 14),
            label.leadingAnchor.constraint(equalTo: base.leadingAnchor, constant: 20),
            label.centerYAnchor.constraint(equalTo: base.centerYAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
