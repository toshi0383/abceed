import AbceedLogic
import UIKit

public final class SubCategoryListViewController: UITableViewController {

    private let viewModel: SubCategoryListViewModelType
    private let cellID = "bookListCollectionCell"
    private let headerID = "subCategoryHeaderView"
    private let headerHeight: CGFloat = 50 // including vertical margin

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

    public override func scrollViewDidScroll(_ scrollView: UIScrollView) {

        // スクロール時にヘッダー位置を(見た目上)固定しないためのワークアラウンド
        if scrollView.contentOffset.y <= headerHeight && scrollView.contentOffset.y >= 0 {
            scrollView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0);
        } else if scrollView.contentOffset.y >= headerHeight {
            scrollView.contentInset = UIEdgeInsets(top: -headerHeight, left: 0, bottom: 0, right: 0);
        }
    }

    override public func numberOfSections(in tableView: UITableView) -> Int {
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

    public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
}
