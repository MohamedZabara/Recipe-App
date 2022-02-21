//
//  categoryCollectionViewCell.swift
//  Recipe
//
//  Created by Mohamed Zabara on 19/02/2022.
//

import UIKit

class categoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.cgColor
        
    }

}
