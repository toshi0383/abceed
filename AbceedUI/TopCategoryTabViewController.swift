import AbceedCore
import AbceedLogic
import RxSwift
import SwipeMenuViewController
import UIKit

public final class TopCategoryTabViewController: SwipeMenuViewController {

    private let viewModel: TopCategoryTabViewModelType
    private let wireframe: TopCategoryTabWireframe
    private let disposeBag = DisposeBag()

    private var loadingIndicator: UIActivityIndicatorView?
    private var errorLabel: UIView?
    private var border: UIView?

    private var options: SwipeMenuViewOptions = {
        var options = SwipeMenuViewOptions()
        options.tabView.style = .segmented
        options.tabView.itemView.selectedTextColor = .red
        options.tabView.additionView.backgroundColor = .red
        options.tabView.additionView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0.25, right: 0)
        options.tabView.bottomBorderView.borderColor = .lightGray
        options.tabView.bottomBorderView.borderWidth = 0.25
        options.isSafeAreaEnabled = true
        return options
    }()

    public init(viewModel: TopCategoryTabViewModelType, wireframe: TopCategoryTabWireframe) {
        self.viewModel = viewModel
        self.wireframe = wireframe

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        viewModel.state.asObservable()
            .observeOn(ConcurrentMainScheduler.instance)
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

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.isNavigationBarHidden = true
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        // Workaround: tabView disappears on rotation.
        swipeMenuView.tabView?.reloadData()
    }

    private func showSuccessfulState() {
        loadingIndicator?.stopAnimating()
        loadingIndicator?.removeFromSuperview()
        loadingIndicator = nil

        swipeMenuView.reloadData(options: options)
    }

    private func showLoadingState() {
        if loadingIndicator == nil {
            let indicator = UIActivityIndicatorView(style: .large)
            indicator.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(indicator)
            indicator.pinCenter(inParent: view)
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
            label.pinCenter(inParent: view)

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

        let viewModel = SubCategoryListViewModel(topCategory: topCategory)
        let vc = SubCategoryListViewController(viewModel: viewModel)
        addChild(vc)
        return vc
    }

}

extension TopCategoryTabViewController: BookListDelegate {
    func bookList(_ collectionView: UICollectionView, didSelectBook book: Book) {
        wireframe.navigateToBookDetail(book: book)
    }
}
