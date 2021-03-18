//
//  DetailViewController.swift
//  RecipePuppy
//
//  Created by Matej Terek on 18/03/2021.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var ingredientsTextView: UITextView!
    //assigned data from parent controller
    var recipeData = RecipeData()

    override func viewDidLoad() {
        super.viewDidLoad()
        //Load content
        loadTableViewContent()
    }

    func loadTableViewContent(){
        //Load content sended from parent controller
        self.navigationBar.topItem?.title =  recipeData.recipeName!.capitalizeFirstLetter()
        self.headerImageView.loadImageUsingCache(imagePath: recipeData.thumbnailURLString ?? "" , completionHandler: {
            _ in
        })
        let tempIngredientsArray = recipeData.ingredientsString?.components(separatedBy: ", ")
        self.ingredientsTextView.text = tempIngredientsArray?.joined(separator: "\n")
    }

    //open recipe url in safari
    @IBAction func openInSafari() {
        guard let url = URL(string: recipeData.recipeHref ?? "") else {
            return
        }
        UIApplication.shared.open(url)
    }

    //Closing View Controller with animation
    @IBAction func backButtonAction() {
        //Transition Animation
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }

}

