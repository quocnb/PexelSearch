//
//  ThumbCollectionViewCell.swift
//  PexelSearch
//
//  Created by quocnb on 2021/10/27.
//

import UIKit

class ThumbCollectionViewCell: UICollectionViewCell {
    static let CELL_IDENTIFIER = "ThumbCell"
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleAspectFill
        label.layer.cornerRadius = 5.0
        label.clipsToBounds = true
        label.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        label.textColor = UIColor.black
    }
}
