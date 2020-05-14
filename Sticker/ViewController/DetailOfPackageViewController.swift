//
//  DetailOfPackageViewController.swift
//  Sticker
//
//  Created by usuario on 13/05/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import UIKit

class DetailOfPackageViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var mainStack: UIStackView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var downloadStickersButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func downloadStickersTouch(_ sender: Any) {
    }
    
    @IBAction func backTouch(_ sender: Any) {
    }
}
