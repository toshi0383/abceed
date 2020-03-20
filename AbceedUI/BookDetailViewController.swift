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
        let arrow = UIBarButtonItem(image: UIImage(named: "left-arrow", in: Bundle(for: BookDetailViewController.self), compatibleWith: nil)!, style: .plain, target: self, action: #selector(pop))
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

        baseStack.distribution = .fillProportionally
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

        let url = URL(string: book.imgURL)!
        Nuke.loadImage(with: url, into: thumbnailView.imageView)

        viewModel.isMybook.asObservable()
            .bind(to: mybookButton.isMybook)
            .disposed(by: disposeBag)

        mybookButton.rx.tapGesture
            .subscribe(onNext: { [weak self] in
                self?.viewModel.tapMybookButton()
            })
            .disposed(by: disposeBag)
    }
}

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

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            widthAnchor.constraint(greaterThanOrEqualToConstant: BookCell.defaultSize.width / 1.4),
            widthAnchor.constraint(lessThanOrEqualToConstant: BookCell.defaultSize.width),
            heightAnchor.constraint(lessThanOrEqualToConstant: BookCell.defaultSize.height / 1.5),
        ])

    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

class Button: UIView {
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
}

final class MybookButton: Button {
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

final class BuyButton: Button {
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