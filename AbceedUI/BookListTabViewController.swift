import AbceedCore
import AbceedLogic
import RxSwift
import UIKit

public final class BookListTabViewController: UIViewController {
    private let viewModel: BookListTabViewModelType
    private let disposeBag = DisposeBag()

    private var loadingIndicator: UIActivityIndicatorView?
    private var errorLabel: UIView?
    private var tabView: UIView?

    public init(viewModel: BookListTabViewModelType) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = .white

        viewModel.state.asObservable()
            .subscribe(onNext: { [weak self] state in
                guard let me = self else { return }

                switch state {
                case .successful(let topCategories):
                    break
                case .loading:
                    me.showLoadingState()
                case .error(let message):
                    me.showErrorState(message)
                }
            })
            .disposed(by: disposeBag)

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
        loadingIndicator = nil
        tabView?.isHidden = true

        if errorLabel == nil {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.text = message
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
            label.pinCenter(view)

            errorLabel = label
        }

        errorLabel!.isHidden = false
        view.bringSubviewToFront(errorLabel!)
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
