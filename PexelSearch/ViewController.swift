//
//  ViewController.swift
//  PexelSearch
//
//  Created by quocnb on 2021/10/27.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {

    private let bag = DisposeBag()
    private var searchResult: SearchResult? = nil
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var photoCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        Connector.searchPhotos(keyword: "hello world").map(\.photos).subscribe(onNext: { result in
            print(result)
        }).disposed(by: bag)
    }

    private func bindData() {
    }
}

