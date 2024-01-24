import UIKit

extension InfoView: UICollectionViewDelegate,
                    UICollectionViewDataSource,
                    UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        exifStrings.count == 0 ? 0 : (exifStrings.count - 1) / 2 + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat!
        if indexPath.row == 0 {
            width = view.frame.width * 0.35
        } else {
            width = view.frame.width * 0.6
        }
        
        let height = CGFloat(40)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExifDataCell.cellIdentifier,
                for: indexPath
            ) as? ExifDataCell
        else {
            fatalError("Unable deque cell...")
        }
        let cellDataIndex = 2 * indexPath.section + indexPath.row
        if cellDataIndex >= exifStrings.count {
            return cell
        }
        cell.cellData = exifStrings[cellDataIndex]
        
        return cell
    }
    
    
}
