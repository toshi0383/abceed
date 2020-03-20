import AbceedCore
import AbceedLogic
import RxSwift
import UIKit

protocol BookListDelegate: AnyObject {
    func bookList(_ collectionView: UICollectionView, didSelectBook book: Book)
}

final class BookListCollectionCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    static let verticalMargin: CGFloat = bottomMargin
    static let bottomMargin: CGFloat = 8 // for drop shadow

    weak var delegate: BookListDelegate?

    private var collectionView: UICollectionView?
    private let cellID = "bookCell"
    private var viewModel: BookListViewModelType?

    func configure(_ viewModel: BookListViewModelType, delegate: BookListDelegate?) {
        self.viewModel = viewModel
        self.delegate = delegate

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
        }

        collectionView!.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        collectionView!.reloadData()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        setContentInset()
    }

    override func updateConstraints() {
        super.updateConstraints()

        setContentInset()

        // scroll offset isn't automatically fixed on traitCollection change
        collectionView?.collectionViewLayout.invalidateLayout()
    }

    private func setContentInset() {
        // NOTE:
        //   safe area aware contentInset
        //   collectionView is pinned to cell, not contentView, otherwise cell's reuse behavior would be visible to user.
        let bottomMargin = BookListCollectionCell.bottomMargin
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: bottomMargin, right: 16) + safeAreaInsets
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return BookCell.defaultSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let books = viewModel?.books.value else { return }

        delegate?.bookList(collectionView, didSelectBook: books[indexPath.item])
    }
}
