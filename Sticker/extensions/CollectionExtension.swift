//
//  CollectionExtension.swift
//  Sticker
//
//  Created by usuario on 01/06/20.
//  Copyright © 2020 Mehul. All rights reserved.
//

import UIKit

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
