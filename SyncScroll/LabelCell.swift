//
//  LabelCell.swift
//  SyncScroll
//
//  Created by 古宮 伸久 on 2021/02/02.
//

import UIKit

final class LabelCell: UICollectionViewCell {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        view.layer.cornerRadius = 8
    }
}
