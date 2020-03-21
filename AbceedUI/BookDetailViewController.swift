import AbceedCore
import AbceedLogic
import Nuke
import RxCocoa
import RxSwift
import UIKit

final class BookDetailViewController: UIViewController {

    private let viewModel: BookDetailViewModelType
    private let disposeBag = DisposeBag()
    private let mybookButton = MybookButton()

    init(viewModel: BookDetailViewModelType) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func pop() {
        navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        navigationController?.isNavigationBarHidden = false

        let path = Bundle.main.path(forResource: "AbceedUIBundle", ofType: "bundle")!
        let arrow = UIBarButtonItem(image: UIImage(named: "left-arrow", in: Bundle(path: path), compatibleWith: nil)!, style: .plain, target: self, action: #selector(pop))
        arrow.tintColor = .gray

        let item = UIBarButtonItem()
        item.title = "書籍紹介"
        item.isEnabled = false
        item.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .disabled)

        navigationItem.setLeftBarButtonItems([arrow, item], animated: false)

        let baseStack = UIStackView.horizontal(spacing: 18)
        let thumbnailView = ThumbnailView()
        let secondaryStack = UIStackView.vertical(spacing: 12)
        let descriptionStack = UIStackView.vertical(spacing: 6)
        let buttonStack = UIStackView.horizontal(spacing: 8)

        baseStack.alignment = .center
        baseStack.distribution = .fill
        baseStack.addArrangedSubview(thumbnailView)
        baseStack.addArrangedSubview(secondaryStack)

        let title = UILabel()
        title.font = .boldSystemFont(ofSize: 18)
        title.numberOfLines = 0
        let author = UILabel()
        author.font = .systemFont(ofSize: 14)
        author.textColor = .gray
        let publisher = UILabel()
        publisher.font = .systemFont(ofSize: 14)
        publisher.textColor = .gray

        mybookButton.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.addArrangedSubview(mybookButton)

        let buyButton = BuyButton()
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.addArrangedSubview(buyButton)
        buttonStack.distribution = .fillEqually

        secondaryStack.addArrangedSubview(descriptionStack)
        secondaryStack.addArrangedSubview(buttonStack)

        view.addSubview(baseStack)

        NSLayoutConstraint.activate([
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: baseStack.topAnchor, constant: -8),
            view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: baseStack.leadingAnchor, constant: -8),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: baseStack.trailingAnchor, constant: 8),
            baseStack.heightAnchor.constraint(equalTo: thumbnailView.heightAnchor),
        ])

        let book = viewModel.book

        title.text = book.name
        author.text = book.author
        publisher.text = book.publisher
        descriptionStack.addArrangedSubview(title)

        if !book.author.isEmpty {
            descriptionStack.addArrangedSubview(author)
        }

        if !book.publisher.isEmpty {
            descriptionStack.addArrangedSubview(publisher)
        }

        Nuke.loadImage(with: URL(string: book.imgURL)!, into: thumbnailView.imageView)

        viewModel.isMybook.asObservable()
            .bind(to: mybookButton.isMybook)
            .disposed(by: disposeBag)

        mybookButton.rx.tapGesture
            .subscribe(onNext: { [weak self] in
                self?.viewModel.tapMybookButton()
            })
            .disposed(by: disposeBag)

        viewModel.showMessage
            .observeOn(ConcurrentMainScheduler.instance)
            .subscribe(onNext: { [weak self] message in
                let a = UIAlertController(title: message, message: nil, preferredStyle: .alert)
                a.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self?.navigationController?.present(a, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UI Components

private final class ThumbnailView: UIView {

    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.applyShadow()
        addSubview(imageView)

        imageView.pinEdges(self)

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: BookCell.defaultSize.width),
            imageView.heightAnchor.constraint(equalToConstant: BookCell.defaultSize.height + 40),
        ])

    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

private class Button: UIView {
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: label.topAnchor, constant: -8),
            bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            centerXAnchor.constraint(equalTo: label.centerXAnchor),
        ])

        label.font = .systemFont(ofSize: 14)

        layer.borderWidth = 1
        layer.cornerRadius = 4
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        label.alpha = 0.2
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        label.alpha = 1.0
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)

        label.alpha = 1.0
    }
}

private final class MybookButton: Button {
    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        backgroundColor = .white
    }

    var isMybook: Binder<Bool> {
        return Binder(self) { (base, value) in
            let color: UIColor = value ? .lightGray : .red
            base.layer.borderColor = color.cgColor
            base.label.textColor = color
            base.label.text = value ? "MyBooksから外す" : "MyBooks追加"
        }
    }
}

private final class BuyButton: Button {
    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        let color: UIColor = .red
        layer.backgroundColor = color.cgColor
        layer.borderColor = color.cgColor
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.text = "購入"
    }
}
