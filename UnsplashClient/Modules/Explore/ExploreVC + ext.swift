import UIKit

extension ExploreViewController:
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 5
        case 2:
            return 1
        case 3:
            return newImages.count
        default:
            return 1
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CellsHeaderLable.headerIdentifier,
                    for: indexPath
                ) as? CellsHeaderLable
            else {
                fatalError("Unable deque cell...")
            }
            
            return cell
        
        case 1:
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CollectionsCarouselCell.cellIdentifier,
                    for: indexPath
                ) as? CollectionsCarouselCell
            else {
                fatalError("Unable deque cell...")
            }
            if collections.count == 0 { return cell }
            cell.cellData = collections[indexPath.row]
            
            return cell
        case 2:
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CellsHeaderLable.headerIdentifier,
                    for: indexPath
                ) as? CellsHeaderLable
            else {
                fatalError("Unable deque cell...")
            }
            cell.exploreLable.text = "New Images"
            
            return cell
        case 3:
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: NewImageCell.cellIdentifier,
                    for: indexPath
                ) as? NewImageCell
            else {
                fatalError("Unable deque cell...")
            }
            if newImages.count == 0 { return cell }
            cell.cellData = newImages[indexPath.row]
            
            return cell
        default:
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: NewImageCell.cellIdentifier,
                    for: indexPath
                ) as? NewImageCell
            else {
                fatalError("Unable deque cell...")
            }
            
            return cell
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if indexPath.section == 0 {
            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TopBannderCell.cellIdentifier,
                for: indexPath) as? TopBannderCell
            else {
                fatalError("Cannot create header view")
            }
            supplementaryView.cellData = headerImageData
            supplementaryView.scrollviewDidScroll(scrollView: collectionView)
            
            return supplementaryView
        }
        else {
            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TopBannderCell.cellIdentifier,
                for: indexPath) as? TopBannderCell else { fatalError("Cannot create header view") }

            return supplementaryView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            presenter?.presentExifScreen(photoId: newImages[indexPath.row].id)
        }
    }
}
