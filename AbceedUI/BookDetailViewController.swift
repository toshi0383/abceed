import AbceedLogic
import UIKit

final class BookDetailViewController: UIViewController {
    private let viewModel: BookDetailViewModelType
    init(viewModel: BookDetailViewModelType) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .yellow
    }
}
