
import UIKit
import Parse

class PBCLoginTableViewController: UITableViewController, UITextFieldDelegate
{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        emailTextField.delegate = self
        senhaTextField.delegate = self
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    @IBAction func resetPassword(sender: AnyObject)
    {
        if let emailTextField = emailTextField
        {
            PFUser.requestPasswordResetForEmailInBackground(emailTextField.text!)
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        if textField == senhaTextField && senhaTextField.text?.isEmpty != true
        {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}