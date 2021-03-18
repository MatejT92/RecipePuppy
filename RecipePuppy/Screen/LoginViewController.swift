//
//  LoginViewController.swift
//  RecipePuppy
//
//  Created by Matej Terek on 18/03/2021.
//
import  UIKit

class LoginViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        //check if user is loged in
        checkIfUserLogedIn()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // user clicked return on email
        if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }
        // user clicked return on password
        textField.resignFirstResponder()
        return false
    }

    func checkIfUserLogedIn(){
        //User didn't loged in, stay on the screen
        let userEmailString = UserDefaults.standard.string(forKey: "userEmail")
        if userEmailString == nil || userEmailString == "" {
            return
        }
        //User alredy loged continue to next screen
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(100)) {
            self.goToRecipesScreen(animated: true)
        }
    }

    @IBAction func loginAction() {
        //check credentials if valid
        if !emailTextField.text!.isValidEmail(){
            //invalid email
            self.showAlertFailed(title: "Invalid Email", message: "email address is invalid please check and try again.", controller: self)
            return
        }
        else if passwordTextField.text!.count < 6{
            //password too short
            self.showAlertFailed(title: "Password too short", message: "please enter a password with at least 6 characters.", controller: self)
            return
        }
        //store login credentials
        UserDefaults.standard.setValue(emailTextField.text, forKey: "userEmail")
        UserDefaults.standard.setValue(passwordTextField.text, forKey: "userPassword")
        //everything is ok continue to Recipe View
        goToRecipesScreen(animated: true)
    }

    func goToRecipesScreen(animated: Bool){
        //Present Recipies View
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "RecipeTableVC") as! RecipesViewController
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: animated)
    }

}

