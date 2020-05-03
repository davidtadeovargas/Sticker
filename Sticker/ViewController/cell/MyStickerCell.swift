//
//  MyStickerCell.swift
//  Sticker
//
//  Created by Mehul on 19/06/19.
//  Copyright © 2019 Mehul. All rights reserved.
//

import UIKit

class MyStickerCell: UITableViewCell {
    
    @IBOutlet weak var sView: UIScrollView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgTray: UIImageView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewSub: UIView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnSelect: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
