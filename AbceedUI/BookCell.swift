import Nuke
import RxNuke
import RxSwift
import UIKit

final class BookCell: UICollectionViewCell {

    static let defaultSize = CGSize(width: 80, height: 121)

    private lazy var thumbnailView: UIImageView = {
        let v = UIImageView()
        v.backgroundColor = .clear
        v.contentMode = .scaleAspectFit
        v.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.addSubview(v)

        NSLayoutConstraint.activate([
            v.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            v.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
        ])
        return v
    }()

    private var reuseDisposeBag = DisposeBag()

    func configure(_ imgURL: String) {
        reuseDisposeBag = DisposeBag()

        applyShadow()

        guard let url = URL(string: imgURL) else { return }

        ImagePipeline.shared.rx.loadImage(with: url)
            .subscribe(onSuccess: { [weak self] result in
                self?.thumbnailView.image = result.image
            })
            .disposed(by: reuseDisposeBag)
    }
}
