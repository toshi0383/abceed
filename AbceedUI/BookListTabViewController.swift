import AbceedCore
import AbceedLogic
import RxSwift
import SwipeMenuViewController
import UIKit

public final class BookListTabViewController: SwipeMenuViewController {
    private let viewModel: BookListTabViewModelType
    private let disposeBag = DisposeBag()

    private var loadingIndicator: UIActivityIndicatorView?
    private var errorLabel: UIView?
    private var tabView: UIView?

    private var options: SwipeMenuViewOptions = {
        var options = SwipeMenuViewOptions()
        options.tabView.style = .segmented
        options.tabView.itemView.selectedTextColor = .red
        options.tabView.additionView.backgroundColor = .red
        return options
    }()

    public init(viewModel: BookListTabViewModelType) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        // TODO
//        viewModel.presentDetailView
//            .observeOn(ConcurrentMainScheduler.instance)
//            .subscribe(onNext: { subcategory in
//            })
//            .disposed(by: disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        viewModel.state.asObservable()
            .subscribe(onNext: { [weak self] state in
                guard let me = self else { return }

                switch state {
                case .successful:
                    me.showSuccessfulState()
                case .loading:
                    me.showLoadingState()
                case .error(let message):
                    me.showErrorState(message)
                }
            })
            .disposed(by: disposeBag)
    }

    private func showSuccessfulState() {
        loadingIndicator?.stopAnimating()
        loadingIndicator?.removeFromSuperview()
        loadingIndicator = nil

        view.bringSubviewToFront(swipeMenuView)
        swipeMenuView.reloadData(options: options)
    }

    private func showLoadingState() {
        if loadingIndicator == nil {
            let indicator = UIActivityIndicatorView(style: .large)
            indicator.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(indicator)
            indicator.pinCenter(view)
            self.loadingIndicator = indicator
        }

        loadingIndicator?.startAnimating()
    }

    private func showErrorState(_ message: String) {

        loadingIndicator?.stopAnimating()
        loadingIndicator?.removeFromSuperview()
        loadingIndicator = nil

        if errorLabel == nil {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.text = message
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
            label.pinCenter(view)

            errorLabel = label
        }

        view.bringSubviewToFront(errorLabel!)
    }

    // MARK: SwipeMenuViewController

    public override func numberOfPages(in swipeMenuView: SwipeMenuView) -> Int {
        return viewModel.state.value.topCategories.count
    }

    public override func swipeMenuView(_ swipeMenuView: SwipeMenuView, titleForPageAt index: Int) -> String {
        return viewModel.state.value.topCategory(at: index)?.name ?? ""
    }

    public override func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewControllerForPageAt index: Int) -> UIViewController {
        guard let topCategory = viewModel.state.value.topCategory(at: index) else {
            fatalError()
        }

        let viewModel = BookListViewModel(topCategory: topCategory)
        return BookListViewController(viewModel: viewModel)
    }

}

extension UIView {
    func pinCenter(_ other: UIView) {
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: other.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: other.centerYAnchor),
        ])
    }
}
