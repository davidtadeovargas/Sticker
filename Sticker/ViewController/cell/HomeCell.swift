//
//  HomeCell.swift
//  Sticker
//
//  Created by Mehul on 19/12/18.
//  Copyright © 2018 Mehul. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var sView: UIScrollView!
    @IBOutlet weak var viewMainImage: UIView!
    @IBOutlet weak var viewSubImage: UIView!
    @IBOutlet weak var imgTray: UIImageView!
    @IBOutlet weak var btnMain: UIButton!
    @IBOutlet weak var btnArrow: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
