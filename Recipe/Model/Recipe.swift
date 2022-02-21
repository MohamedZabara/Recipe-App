
import Foundation
struct Hits:Decodable{
    let q:String?
    let from:Int?
    let to:Int?
    let more:Bool?
    let count:Int?
    let hits:[[String:Recipe]]?
}

struct Recipe:Decodable {
    let uri:String
    let label:String
    let image:String
    let source:String
    let url:String
    let shareAs:String
    let yield:Double
    let dietLabels:[String]
    let healthLabels:[String]
    let cautions:[String]
    let ingredientLines:[String]
    let ingredients:[Ingredient]?
    let calories:Double
    let totalWeight:Double
    let totalTime:Double
    let cuisineType:[String]?
    let mealType:[String]?
    let dishType:[String]?
    let totalNutrients:[String:Measure]?
    let totalDaily:[String:Measure]?
    let digest:[Digest]?
    



}

struct Ingredient:Decodable {
    let text:String?
    let quantity:Double?
    let measure:String?
    let food:String?
    let weight:Double?
    let foodCategory:String?
    let foodId:String?
    let image:String?
}

struct Measure:Decodable {
    let label:String?
    let quantity:Double?
    let unit:String?
}

struct Digest:Decodable {
    let label:String?
    let tag:String?
    let schemaOrgTag:String?
    let total:Double?
    let hasRDI:Bool?
    let daily:Double?
    let unit:String?
    let sub:[Sub]?
    
}
struct Sub:Decodable {
    let label:String?
    let tag:String?
    let schemaOrgTag:String?
    let total:Double?
    let hasRDI:Bool?
    let daily:Double?
    let unit:String?
}


