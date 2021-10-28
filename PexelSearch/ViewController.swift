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

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout {

    private let bag = DisposeBag()
    private var searchResult: SearchResult? = nil
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateCollectionViewLayout()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Connector.searchPhotos(keyword: "hello world").map(\.photos).bind(to: photoCollectionView.rx.items(cellIdentifier: ThumbCollectionViewCell.CELL_IDENTIFIER, cellType: ThumbCollectionViewCell.self)) {_, photo, cell in
            cell.imageView?.sd_setImage(with: photo.thumbUrl(), completed: nil)
            cell.label.text = photo.photographer
        }.disposed(by: bag)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCollectionViewLayout()
    }

    private func updateCollectionViewLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 2
        flowLayout.minimumInteritemSpacing = 2
        let size = (photoCollectionView.bounds.size.width - 2 * flowLayout.minimumLineSpacing) / 3.0
        // Get tiny photo for thumb. Tiny photo size 280x200 -> ratio = 7/5
        flowLayout.itemSize = CGSize(width: size, height: size * 5 / 7)
        photoCollectionView.setCollectionViewLayout(flowLayout, animated: true)
    }

    private func bindData() {
    }
}

