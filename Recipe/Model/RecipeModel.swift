//
//  RecipeModel.swift
//  Recipe
//
//  Created by Mohamed Zabara on 20/02/2022.
//
import UIKit
let defaults = UserDefaults.standard

class RecipeModel{
    enum OperationChosen{
        case searching
        case filtering
        case pagination
    }
    
    func getSearchList(completion:@escaping([String])->Void){
        let searchList = defaults.stringArray(forKey: Constant.searchListKey) ?? [String]()
        completion(searchList)
    }
    func persistSearchList(list:[String]){
        defaults.set(list, forKey: Constant.searchListKey)
    }
    
  
}
