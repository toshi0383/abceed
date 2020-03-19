import Nuke
import RxNuke
import RxSwift
import UIKit

final class BookCell: UICollectionViewCell {

    static let defaultSize = CGSize(width: 150, height: 242)

    private lazy var thumbnailView: UIImageView = {
        let v = UIImageView()
        v.backgroundColor = .lightGray
        v.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(v)
        v.pinEdges(self.contentView)
        v.contentMode = .scaleAspectFit
        return v
    }()

    /// 取得した画像サイズを基準の高さにリサイズした場合のサイズ、の半分(retina display考慮)
    /// これをセルのサイズ計算にそのまま使用する。
    private(set) var resolvedImageSize: CGSize?

    private var reuseDisposeBag = DisposeBag()

    func configure(_ imgURL: String, setNeedsLayout: @escaping () -> ()) {
        reuseDisposeBag = DisposeBag()
        resolvedImageSize = nil

        applyShadow()

        guard let url = URL(string: imgURL) else { return }

        ImagePipeline.shared.rx.loadImage(with: url)
            .subscribe(onSuccess: { [weak self] result in
                self?.setImage(result.image)
                setNeedsLayout()
            })
            .disposed(by: reuseDisposeBag)
    }

    private func setImage(_ image: UIImage) {

        let origSize = image.size

        if origSize.height == BookCell.defaultSize.height {
            resolvedImageSize = origSize / 2
            thumbnailView.image = image
            return
        }

        let newSize = CGSize(
            width: origSize.width * BookCell.defaultSize.height / origSize.height,
            height: BookCell.defaultSize.height
        )

        resolvedImageSize = newSize / 2

        thumbnailView.image = image
    }
}
