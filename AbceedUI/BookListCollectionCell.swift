import AbceedCore
import AbceedLogic
import RxSwift
import UIKit

protocol BookListDelegate: AnyObject {
    func bookList(_ collectionView: UICollectionView, didSelectBook book: Book)
}

final class BookListCollectionCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    static let verticalMargin: CGFloat = bottomMargin
    static let bottomMargin: CGFloat = 8 // for drop shadow

    weak var delegate: BookListDelegate?

    private var collectionView: UICollectionView?
    private let cellID = "bookCell"
    private var viewModel: BookListViewModelType?

    func configure(_ viewModel: BookListViewModelType, delegate: BookListDelegate?) {
        self.backgroundColor = .clear
        self.viewModel = viewModel
        self.delegate = delegate

        if collectionView == nil {
            let layout = UICollectionViewFlowLayout() //FlexibleWidthByImageSizeLayout()
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 8
            layout.itemSize = BookCell.defaultSize
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.register(BookCell.self, forCellWithReuseIdentifier: cellID)
            collectionView.dataSource = self
            collectionView.delegate = self
            self.collectionView = collectionView
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(collectionView)
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: BookListCollectionCell.bottomMargin, right: 16)
            collectionView.pinEdges(self.safeAreaLayoutGuide)
            collectionView.contentInsetAdjustmentBehavior = .never
            collectionView.backgroundColor = .clear
        }

        collectionView!.reloadData()
        collectionView!.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel!.books.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! BookCell
        cell.configure(viewModel!.books.value[indexPath.row].imgURL)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let books = viewModel?.books.value else { return }

        delegate?.bookList(collectionView, didSelectBook: books[indexPath.item])
    }
}
