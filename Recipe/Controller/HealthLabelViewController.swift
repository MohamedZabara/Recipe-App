//
//  HealthLabelViewController.swift
//  Recipe
//
//  Created by Mohamed Zabara on 23/02/2022.
//

import UIKit

class HealthLabelViewController: UIViewController {
    
    @IBOutlet weak var cancelImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    var recipe:Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapImage))
                cancelImage.isUserInteractionEnabled = true
                cancelImage.addGestureRecognizer(tap)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        tableView.dataSource = self
        titleLabel.sizeToFit()
        titleLabel.adjustsFontSizeToFitWidth = true


        titleLabel.text = recipe?.label

    }
    
    @objc
        func tapImage(sender:UITapGestureRecognizer) {
            dismiss(animated: true)
        }
    
    
    @IBAction func cancelBtnClicked(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

}
//MARK: - tableView

extension HealthLabelViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe?.healthLabels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = recipe?.healthLabels[indexPath.row]
        return cell
    }
}
