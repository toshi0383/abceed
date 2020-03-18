import AbceedLogic
import Nuke
import RxNuke
import RxSwift
import UIKit

final class BookListCollectionCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    static let verticalMargin: CGFloat = 0

    private var collectionView: UICollectionView?
    private let cellID = "bookCell"
    private var viewModel: BookListViewModelType?

    func configure(_ viewModel: BookListViewModelType) {
        self.viewModel = viewModel


        if collectionView == nil {
            let layout = UICollectionViewFlowLayout() //FlexibleWidthByImageSizeLayout()
            layout.scrollDirection = .horizontal
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.register(BookCell.self, forCellWithReuseIdentifier: cellID)
            collectionView.dataSource = self
            collectionView.delegate = self
            self.collectionView = collectionView
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(collectionView)
            collectionView.pinEdges(contentView)
            collectionView.backgroundColor = .clear
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }

        collectionView!.reloadData()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel!.books.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! BookCell
        cell.configure(viewModel!.books.value[indexPath.row].imgURL, setNeedsLayout: collectionView.collectionViewLayout.invalidateLayout)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(#function)
        let defaultSize = CGSize(width: BookCell.fixedWidth, height: BookCell.fixedHeight)

        if collectionView.indexPathsForVisibleItems.contains(where: { $0.item == indexPath.item }) {
            var size = defaultSize

            if let cell = collectionView.cellForItem(at: indexPath) as? BookCell,
                let resolvedSize = cell.resolvedImageSize {

                size = resolvedSize
            }

            print("size: \(size)")
            return size
        }

        print("default: \(defaultSize)")
        return defaultSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

final class BookCell: UICollectionViewCell {

    static let fixedWidth: CGFloat = 150
    static let fixedHeight: CGFloat = 242

    private lazy var thumbnailView: UIImageView = {
        let v = UIImageView()
        v.backgroundColor = .lightGray
        v.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(v)
        v.pinEdges(self.contentView)
        v.contentMode = .scaleAspectFit
        return v
    }()

    private(set) var resolvedImageSize: CGSize?

    private var reuseDisposeBag = DisposeBag()

    func configure(_ imgURL: String, setNeedsLayout: @escaping () -> ()) {
        reuseDisposeBag = DisposeBag()
        resolvedImageSize = nil

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

        if origSize.height == BookCell.fixedHeight {
            resolvedImageSize = origSize / 2
            thumbnailView.image = image
            return
        }

        let newSize = CGSize(
            width: origSize.width * BookCell.fixedHeight / origSize.height,
            height: BookCell.fixedHeight
        )

        resolvedImageSize = newSize / 2

        thumbnailView.image = image
    }
}

private func / (_ size: CGSize, _ r: CGFloat) -> CGSize {
    return CGSize(width: size.width / r, height: size.height / r)
}
