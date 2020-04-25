import AbceedCore
import AbceedLogic
import RxSwift
import UIKit

final class BookListCollectionCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDragDelegate {

    static let verticalMargin: CGFloat = bottomMargin
    static let bottomMargin: CGFloat = 8 // for drop shadow

    private var collectionView: UICollectionView?
    private let cellID = "bookCell"
    private var viewModel: BookListViewModelType?

    func configure(_ viewModel: BookListViewModelType) {
        self.backgroundColor = .clear
        self.viewModel = viewModel

        if collectionView == nil {
            let layout = UICollectionViewFlowLayout() //FlexibleWidthByImageSizeLayout()
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 8
            layout.itemSize = BookCell.defaultSize
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.register(BookCell.self, forCellWithReuseIdentifier: cellID)
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.dragDelegate = self
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

        viewModel?.select(books[indexPath.item])
    }

    // - MARK: UICollectionViewDragDelegate
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let books = viewModel?.books.value else { return [] }

        guard let cell = collectionView.cellForItem(at: indexPath) as? BookCell,
         let image = cell.thumbnailView.image else { return [] }

        let selectedBook = books[indexPath.item]

        guard let userActivity = NSUserActivity(book: selectedBook) else {
            return []
        }

        let itemProvider = NSItemProvider(object: image)
        itemProvider.registerObject(userActivity, visibility: .all)

        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = selectedBook

        return [dragItem]

    }
}
