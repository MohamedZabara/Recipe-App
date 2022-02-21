//
//  RecipeTableViewCell.swift
//  Recipe
//
//  Created by Mohamed Zabara on 20/02/2022.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var healthLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
