import AbceedLogic
import UIKit

final class BookListViewController: UITableViewController {
    private let viewModel: BookListViewModelType

    init(viewModel: BookListViewModelType) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
