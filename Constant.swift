
import Foundation

class Constant{
    static let collectionCellIdId = "category"
    static let collectionNibName = "categoryCollectionViewCell"
    static let tableNibName = "RecipeTableViewCell"
    static let tableCellId = "recipeCell"
    static let detailSegue = "toDetails"
    static let recipeDicKey = "recipe"
    static let startUrlPoint = "https://api.edamam.com/search?app_id=9a736ed0&app_key=676d133db1fa8609950d571bf7eaed01&images=Regular"
    static let searchListKey = "list"
    static let healthSegue = "toHealth"
    
    static let Filteration:[String] = [
        "All",
        "keto-friendly",
        "kidney-friendly",
        "low-sugar",
        "low-potassium",
        "alcohol-free",
        "pork-free",
        "egg-free",
        "vegan",
        "paleo"
        
    ]
}
