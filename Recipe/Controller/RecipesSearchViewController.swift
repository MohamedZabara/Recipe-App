//
//  ViewController.swift
//  Recipe
//
//  Created by Mohamed Zabara on 18/02/2022.
//

import UIKit
import KRProgressHUD

class RecipesSearchViewController: UIViewController {
    @IBOutlet weak var recipeTextField: UITextField!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    var allRecipes = [[String:Recipe]]()
    let recipeApi = RecipeApi()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        print("here in viewdidload")
       

        
        categoryCollectionView.dataSource = self
        let cellNib = UINib(nibName: "\(Constamt.collectionNibName.self)", bundle: nil)
        categoryCollectionView.register(cellNib.self, forCellWithReuseIdentifier: Constamt.collectionCellIdId)
        tableView.delegate = self
        tableView.dataSource = self
        
        let tableCellNib = UINib(nibName: "\(Constamt.tableNibName.self)", bundle: nil)
        tableView.register(tableCellNib.self, forCellReuseIdentifier: Constamt.tableCellId)
        
        
        recipeApi.fetchData(filter: nil) { response, error in
//            print("in  closure")
            if !error{
                guard let hits = response else{
//                    print("cant 1")
                    return
                }
                
                guard let recipes = hits.hits else{
//                    print("cant 2")
                    return
                }
                self.allRecipes.append(contentsOf: recipes)
//                print(self.allRecipes)
                DispatchQueue.main.async {
                    self.reloadTableView()
                }
                
                
            }
           
        }

    }
    
    func reloadTableView(){
        self.tableView.reloadData()
    }


}

extension RecipesSearchViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: Constamt.collectionCellIdId, for: indexPath) as! categoryCollectionViewCell
        cell.categoryName.text = "all"
        return cell

    }
    
    
}

extension RecipesSearchViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constamt.tableCellId, for: indexPath) as! RecipeTableViewCell
        let recipe = allRecipes[indexPath.row]["recipe"]
//        print("title :\(recipe?.label)")
        
        cell.titleLabel.text = recipe!.label
//        print("source :\(recipe?.source)")
        cell.sourceLabel.text = recipe!.source
        if let img = recipe?.image{
            if let data = getImgData(imgUrl:img){
            cell.recipeImage.image = UIImage(data:data)
            }
        }
//        print("health :\((recipe?.healthLabels))")

        var h = ""
        if let healthLabels = recipe?.healthLabels{

            for health in healthLabels{
                if indexPath.row == 0{
                    cell.healthLabel.text = """
                    hi man uj
                mo mo mo
                mo
                """
                }else{
                cell.healthLabel.text = h + ",\(health)"
//                print(health, separator: ",", terminator: " ")
                }
            }
            h=""
        }
//        cell.healthLabel.numberOfLines = 2
        

        
//        cell.healthLabel.text = """
//        hi
//        hi
//        hi
//        hi
//        hi
//        hi
//        hi
//        hi
//        hi
//        hi
//        """
                return cell
    }
    
   
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constamt.detailSegue, sender: allRecipes[indexPath.row][Constamt.recipeDicKey])
    }
    
    
    
    func getImgData(imgUrl img:String)->Data?{
        let url = URL(string: img)
        if let url = url{
            let data = try? Data(contentsOf: url)
            return data
        }
        return nil
    }
    
    //MARK: - prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("this is sender  --  \(String(describing: sender))")
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == Constamt.detailSegue {
              if let nextViewController = segue.destination as? DetailsViewController {
                  nextViewController.recipe = sender as? Recipe
                      
              }
          }
        
    }
    
   
    
    
}