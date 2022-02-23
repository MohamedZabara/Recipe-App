//
//  ViewController.swift
//  Recipe
//
//  Created by Mohamed Zabara on 18/02/2022.
//

import UIKit
import KRProgressHUD
import SearchTextField

class RecipesSearchViewController: UIViewController {
    @IBOutlet weak var recipeTextField: SearchTextField!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    var allRecipes = [[String:Recipe]]()
    let recipeApi = RecipeApi()
    let recipeModel = RecipeModel()
    var isMore:Bool?
    var from:Int?
    var search:String?
    var health:String? = nil

    var searchListArray = [String](){
        didSet{
            recipeTextField.filterStrings(searchListArray.reversed())
        }
    }
    
    
   
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setUpSearchList()
     
        
   
        
        
        

//        searchListArray.append("we")
//        searchListArray.reverse()
        print(searchListArray)
        recipeTextField.filterStrings(searchListArray)


        callSearchApi(operation: .searching)

    customizeTextField()

        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        recipeTextField.delegate = self
        
        
        
        
     

    }
   
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        recipeModel.persistSearchList(list: searchListArray)
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIScene.willDeactivateNotification, object: nil)
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        }
    }
    
    func registerCell(){
        let cellNib = UINib(nibName: "\(Constant.collectionNibName.self)", bundle: nil)
        categoryCollectionView.register(cellNib.self, forCellWithReuseIdentifier: Constant.collectionCellIdId)
        let tableCellNib = UINib(nibName: "\(Constant.tableNibName.self)", bundle: nil)
        tableView.register(tableCellNib.self, forCellReuseIdentifier: Constant.tableCellId)
    }
    
    
    func reloadTableView(){
        DispatchQueue.main.async {
        self.tableView.reloadData()
        }
    }
    
    
    func createSpinnerFooter()->UIView{
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
    func customizeTextField(){
        recipeTextField.theme.font = UIFont.systemFont(ofSize: 14)
        recipeTextField.theme.bgColor = UIColor.lightGray
        recipeTextField.theme.separatorColor = UIColor.black
        recipeTextField.theme.cellHeight = 40
        recipeTextField.maxNumberOfResults = 10
        recipeTextField.startSuggestingImmediately = true
        recipeTextField.startVisible = true
    }
    
    func setUpSearchList(){
        recipeModel.getSearchList{
            self.searchListArray = $0
        }
    }
    
    func observeAppInBackGround(){
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIScene.willDeactivateNotification, object: nil)
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        }
    }
    
    @objc func willResignActive(_ notification: Notification) {
        recipeModel.persistSearchList(list: searchListArray)
    }
    
   
    
    func showErrorHud(){
            self.allRecipes.removeAll()
            KRProgressHUD.showError(withMessage: "No results found")
        tableView.tableFooterView = nil
    }
    
    func callSearchApi(search:String? = "random",health:String? = nil,from:Int? = 0,operation:RecipeModel.OperationChosen){
        
        
        recipeApi.fetchData(search: search, filter: health, from: from,operation: operation) { response, error in
//            print("in  closure")
            print("ooooooooo \(operation)")
            if !error{
                guard let hits = response else{
//                    print("cant 1")
                    return
                }
                
                guard let recipes = hits.hits else{
//                    print("cant 2")
                    return
                }
            

                switch operation {
                case .searching:
                    if recipes.isEmpty{
                        self.showErrorHud()
                    }else{
                        KRProgressHUD.dismiss()
                        self.allRecipes.removeAll()
                    }
                    
                
                case .filtering:
                    if recipes.isEmpty{
                        self.showErrorHud()
                    }else{
                        KRProgressHUD.dismiss()
                        self.allRecipes.removeAll()
                    }
                    
                case .pagination:
                    break
                }
                
                let o:RecipeModel.OperationChosen = .searching
                print("kkkkkkkkk\(o)")
            
                self.allRecipes.append(contentsOf: recipes)
                print("uuuuuuu\(self.allRecipes.count)")

                self.isMore = hits.more
                self.from = (hits.to ?? 0) + 1
                print("pppppp\(hits.to)")
                print("aaaaaa\(self.search)")
                self.search = hits.q
                print("aaaaaa\(search)")
                print(self.allRecipes)
                    self.reloadTableView()
                
                
            }else{
                self.showErrorHud()
            }
           
        }
        
    }
}
//MARK: - collectionView
extension RecipesSearchViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constant.Filteration.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: Constant.collectionCellIdId, for: indexPath) as! categoryCollectionViewCell
        cell.categoryName.sizeToFit()
        cell.categoryName.text =  Constant.Filteration[indexPath.row].replacingOccurrences(of: "-", with: " ")
      
        return cell

    }
    
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constant.Filteration[indexPath.item].size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]).width + 50, height: 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(Constant.Filteration[indexPath.row])
        if indexPath.row == 0{
            health = nil
            print("vvvvvvv search\(search)")
            callSearchApi(search: search, operation: .searching)
        }else{
            health = Constant.Filteration[indexPath.row]
            print("vvvvvvv search\(search)  filter\(Constant.Filteration[indexPath.row])")

            callSearchApi(search: search, health: health, from: 0, operation: .filtering)
        }
        
    }
    
    
}
//MARK: - tableView
extension RecipesSearchViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.tableCellId, for: indexPath) as! RecipeTableViewCell
        let recipe = allRecipes[indexPath.row]["recipe"]
//        print("title :\(recipe?.label)")
        
        cell.titleLabel.text = recipe!.label
//        print("source :\(recipe?.source)")
        cell.sourceLabel.text = recipe!.source
//        if let img = recipe?.image{
//            if let data = getImgData(imgUrl:img){
//            cell.recipeImage.image = UIImage(data:data)
//            }
//        }
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
    
   
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 250
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constant.detailSegue, sender: allRecipes[indexPath.row][Constant.recipeDicKey])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == allRecipes.count-1{
            guard let isMore = isMore else{
                return
            }
            if isMore{
                tableView.tableFooterView = createSpinnerFooter()
                callSearchApi(search: search,health: health, from: from,operation: .pagination)
            }else{
                tableView.tableFooterView = nil
                print("nnnnnnnnnnnnnnnnnn")
            }
            
        }
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
        if segue.identifier == Constant.detailSegue {
              if let nextViewController = segue.destination as? DetailsViewController {
                  nextViewController.recipe = sender as? Recipe
                      
              }
          }
        
    }
    
   
    
    
}

extension RecipesSearchViewController:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if range.location == 0 && string == " " { // prevent space on first character
            return false
        }

        if textField.text?.last == " " && string == " " { // allowed only single space
            return false
        }

        if string == " " { return true } // now allowing space between name

        if string.rangeOfCharacter(from: CharacterSet.letters.inverted) != nil {
            return false
        }

        return true
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField.text)
        
        guard let searchText = textField.text else{
            return false
        }
        if !searchText.isEmpty{
            callSearchApi(search: searchText, health: health, from: 0,operation: .searching)
            searchListArray.append(searchText)
            if searchListArray.count == 11{
                searchListArray.removeFirst()
            }
            
        }
        textField.resignFirstResponder()
        return true
    }
}
