//
//  RecipeTableViewCell.swift
//  Recipe
//
//  Created by Mohamed Zabara on 20/02/2022.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var seeMore: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var healthLabel: UILabel!
    var didTapBtn : (() -> Void)?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
                seeMore.isUserInteractionEnabled = true
                seeMore.addGestureRecognizer(tap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc
        func tapFunction(sender:UITapGestureRecognizer) {
            print("tap working")
            didTapBtn?()
        }
    
}
