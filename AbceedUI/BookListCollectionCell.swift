import AbceedLogic
import RxSwift
import UIKit

final class BookListCollectionCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    static let verticalMargin: CGFloat = bottomMargin
    static let bottomMargin: CGFloat = 8 // for drop shadow

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
            collectionView.pinEdges(self)
            collectionView.backgroundColor = .clear
            let bottomMargin = BookListCollectionCell.bottomMargin
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: bottomMargin, right: 16)
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

        var size = BookCell.defaultSize / 2

        if collectionView.indexPathsForVisibleItems.contains(where: { $0.item == indexPath.item }) {

            if let cell = collectionView.cellForItem(at: indexPath) as? BookCell,
                let resolvedSize = cell.resolvedImageSize {

                size = resolvedSize
            }
            return size
        }

        return size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
