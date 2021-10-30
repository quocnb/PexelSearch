//
//  PreviewViewController.swift
//  PexelSearch
//
//  Created by quocnb on 2021/10/30.
//

import UIKit
import SDWebImage
import RxSwift
import RxCocoa

class PreviewViewController: UIViewController {
    static let identifier = "PreviewViewController"

    private let bag = DisposeBag()
    var photo: Photo!
    var thumb: UIImage?

    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet private weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadPhoto()
        setupViews()
    }

    private func setupViews() {
        self.view.backgroundColor = UIColor.black
        closeButton.rx.tap.subscribe { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }.disposed(by: bag)

    }

    private func loadPhoto() {
        imageView.sd_setImage(
            with: photo.originalPhotoUrl(),
            placeholderImage: thumb,
            options: .continueInBackground,
            context: nil)
    }

}
