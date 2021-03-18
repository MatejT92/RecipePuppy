//
//  RecipesViewController.swift
//  RecipePuppy
//
//  Created by Matej Terek on 18/03/2021.
//

import UIKit

class RecipesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    let cellReuseIdentifier = "tableCell"
    var recipeList = [RecipeData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //Initialize loading HUD
        activityIndicator()
        //Show loading HUD
        indicator.startAnimating()
        //Start fetching and loading recipes
        loadTableViewContent()
    }

    func loadTableViewContent(){
        FetchModal().getRecipesData(parameter: "") {
            (newList, status,message) in
            if status{
                // Fetcing successful show new data
                DispatchQueue.main.async {
                    self.recipeList = newList
                    self.tableView.reloadData()
                    //Remove Loading Hud
                    self.indicator.stopAnimating()
                }
            }
            else
            {
                //Show Error message
                self.showAlertFailed(title: "Error", message: "Something went wrong, check your internet connection and try again.", controller: self)
                self.indicator.stopAnimating()
            }
        }
    }

    // Number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeList.count
    }

    // Create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:RecipeTableCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! RecipeTableCell
        //Load cell at index with data
        let currentItem = recipeList[indexPath.item]
        cell.recipekNameLabel?.text = currentItem.recipeName
        cell.imgPlaceholder?.loadImageUsingCache(imagePath: currentItem.thumbnailURLString! , completionHandler: {
            _ in
        })
        return cell
    }

    // Method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Uncheck clicked row
        tableView.deselectRow(at: indexPath, animated: true)
        //Present Detail View
        let detailsVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as! DetailViewController
        detailsVC.modalPresentationStyle = .fullScreen
        detailsVC.recipeData = recipeList[indexPath.row]
        //Transition Animation and presentation
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(detailsVC, animated: false)
    }

    //  Initialization of Loading HUD
    var indicator = UIActivityIndicatorView()
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.center = self.view.center
        indicator.backgroundColor = UIColor.darkGray.withAlphaComponent(0.6)
        indicator.color = UIColor.white
        indicator.layer.cornerRadius = 10
        self.view.addSubview(indicator)
    }

}

