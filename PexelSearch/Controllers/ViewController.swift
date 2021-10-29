//
//  ViewController.swift
//  PexelSearch
//
//  Created by quocnb on 2021/10/27.
//

import UIKit
import RxCocoa
import RxSwift
import SDWebImage

class ViewController: UIViewController {

    private let bag = DisposeBag()
    private let photos = BehaviorRelay<[Photo]>(value: [])
    private var isRequesting = false
    private var currentPage = 1
    private var hasNextPage = false

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var photoCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateCollectionViewLayout()
        bindData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCollectionViewLayout()
    }

    private func updateCollectionViewLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 2
        flowLayout.minimumInteritemSpacing = 2
        // 3 cell for one row
        let cellWidth = (photoCollectionView.bounds.size.width - 2 * flowLayout.minimumLineSpacing) / 3.0
        // We will use tiny photo for display. Tiny photo size 280x200 -> ratio = 7/5
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth * 5 / 7)
        photoCollectionView.setCollectionViewLayout(flowLayout, animated: true)
    }
}

// MARK: Bind data
extension ViewController {
    private func bindData() {
        // Dismiss keyboard when click search button
        searchBar.rx.searchButtonClicked.subscribe { [unowned self] _ in
            self.searchBar.endEditing(true)
        } .disposed(by: bag)

        // Due to the guidelines of Pexel API Document, by default, the API is rate-limited
        // to 200 requests per hour. So I won't support realtime search
        // https://www.pexels.com/api/documentation/
        self.searchBar.rx.searchButtonClicked
            .map { [unowned self] _ in
                return self.searchBar.text ?? ""
            }.filter({ text in
                !text.isEmpty
            }).subscribe(onNext: { [unowned self] (text) in
                self.search(keyword: text, page: 1)
            }).disposed(by: self.bag)

        photos.bind(to: photoCollectionView.rx.items(cellIdentifier: ThumbCollectionViewCell.CELL_IDENTIFIER, cellType: ThumbCollectionViewCell.self)) {_, photo, cell in
            cell.imageView?.sd_setImage(with: photo.thumbUrl(), completed: nil)
            cell.label.text = photo.photographer
        }.disposed(by: bag)

        photoCollectionView.rx.willDisplayCell.filter { [unowned self](cell: UICollectionViewCell, idp: IndexPath) in
            idp.row >= (self.photos.value.count - 1) && !isRequesting && hasNextPage
        }.subscribe { [unowned self](cell: UICollectionViewCell, at: IndexPath) in
            self.search(keyword: self.searchBar.text ?? "", page: self.currentPage + 1)
        }.disposed(by: bag)

    }
}

// MARK: Api
extension ViewController {
    private func search(keyword: String, page: Int) {
        // Only 1 request at once
        if (isRequesting) {
            return
        }
        isRequesting = true
        Connector.searchPhotos(keyword: keyword, page: page).subscribe { [unowned self] searchResult in
            if page == 1 {
                self.photos.accept(searchResult.photos)
            } else {
                self.photos.accept(self.photos.value + searchResult.photos)
            }
            self.isRequesting = false
            currentPage = page
            hasNextPage = searchResult.nextPage != nil
        } onError: { [unowned self] error in
            self.isRequesting = false
            self.showErrorAlert(message: error.localizedDescription)
        }.disposed(by: bag)
    }
}
