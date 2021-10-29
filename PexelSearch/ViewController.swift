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
    private let searchKeyword = PublishSubject<String>()

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!

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

    private func bindData() {
        searchBar.rx.searchButtonClicked.subscribe { [unowned self] _ in
            self.searchBar.endEditing(true)
        } .disposed(by: bag)

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
    }

    // MARK: Api
    private func search(keyword: String, page: Int) {
        Connector.searchPhotos(keyword: keyword).subscribe { [unowned self] searchResult in
            if page == 1 {
                self.photos.accept(searchResult.photos)
            } else {
                self.photos.accept(self.photos.value + searchResult.photos)
            }
        } onError: { error in
            self.showErrorAlert(message: error.localizedDescription)
        }.disposed(by: bag)
    }
}
