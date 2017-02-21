import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var logInIndicator: UIActivityIndicatorView!
    
    @IBAction func login() {
        blockUIWithPendingLogIn()
        
        sessionManager.signIn(emailField.text!, password: passwordField.text!,
            onSuccess: onLoginSuccess,
            onFail: onLoginFailed)
    }
    
    override func viewDidLoad() {
        emailField.delegate = self
        passwordField.delegate = self
        emailField.canBecomeFirstResponder
        passwordField.canBecomeFirstResponder
        api.resetSession()
        emailField.text = "will@connectpal.com"
        passwordField.text = "password"
        super.viewDidLoad()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == passwordField) {
            passwordField.resignFirstResponder()
            login()
        } else if (textField == emailField) {
            passwordField.becomeFirstResponder()
        }
        
        return true
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return identifier != "login_success"
    }
    
    fileprivate func onLoginSuccess() {
        restoreUIAfterLogIn()
        performSegue(withIdentifier: "login_success", sender: self)
    }
    
    fileprivate func onLoginFailed() {
        restoreUIAfterLogIn()
        
        let alertController = UIAlertController(
            title: "Failed to Log In",
            message: "The email or password you entered doesn't appear to belong to an account. Please check your credentials and try again.",
            preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func blockUIWithPendingLogIn() {
        logInIndicator.isHidden = false
        logInIndicator.startAnimating()
        emailField.isEnabled = false
        passwordField.isEnabled = false
        logInButton.isEnabled = false
        logInButton.titleLabel!.text = "Please wait..."
    }
    
    fileprivate func restoreUIAfterLogIn() {
        logInIndicator.isHidden = true
        logInIndicator.stopAnimating()
        emailField.isEnabled = true
        passwordField.isEnabled = true
        passwordField.text = ""
        logInButton.isEnabled = true
        logInButton.titleLabel!.text = "Log In"
    }
}
