//
//  DetailsViewController.swift
//  Recipe
//
//  Created by Mohamed Zabara on 20/02/2022.
//

import UIKit
import SafariServices

class DetailsViewController: UIViewController {
    @IBOutlet weak var recipeImg: UIImageView!
    @IBOutlet weak var ingredientTableView: UITableView!
    var recipe:Recipe?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let _ = recipe else{
            return
        }
        setUpUI()
        ingredientTableView.dataSource = self
        ingredientTableView.delegate = self

        // Do any additional setup after loading the view.
    }
    func setUpUI(){
        if let img = recipe?.image{
            RecipeApi().loadImageUrl(imgUrlString: img) { data in
                DispatchQueue.main.async {
                    self.recipeImg.image = UIImage(data: data, scale: 1)
                }
            }
        }
        
    }
    
    @IBAction func recipeWebsiteBtnClicked(_ sender: UIButton) {
        guard let recipe = recipe else{
            return
        }
        openSafari(open: recipe.url)
    }
    @IBAction func shareBtnClicked(_ sender: UIBarButtonItem) {
        guard let recipe = recipe else{
            return
        }
        let someText = "Have a good recipe"
        let shareString:String = recipe.shareAs
       let objectsToShare:URL = URL(string:shareString )!
       let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
       let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
       activityViewController.popoverPresentationController?.sourceView = self.view

        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook,UIActivity.ActivityType.postToTwitter,UIActivity.ActivityType.mail]

       self.present(activityViewController, animated: true, completion: nil)
    }
    
   
    
    func openSafari(open url:String){
        if let url = URL(string: url) {
              let config = SFSafariViewController.Configuration()
              config.entersReaderIfAvailable = true

              let vc = SFSafariViewController(url: url, configuration: config)
              present(vc, animated: true)
          }
    }
    

}


extension DetailsViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let ingredient = recipe?.ingredientLines else{
            return 0
        }
        return ingredient.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) 
       
        if let ingredient = recipe?.ingredientLines{
            cell.textLabel?.text = " - \(ingredient[indexPath.row])"
        }
        
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    
}
