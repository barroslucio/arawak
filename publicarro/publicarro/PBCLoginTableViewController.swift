
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
        if emailTextField.text?.isEmpty != true
        {
            PFUser.requestPasswordResetForEmailInBackground(self.emailTextField!.text!)
            let alertView = UIAlertController(title: "Recuperação de Senha", message: "Verifique seu email: "+emailTextField.text!, preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            presentViewController(alertView, animated: true, completion: nil)
        }
        else
        {
            var email: UITextField?
            let alertView = UIAlertController(title: "Recuperação de Senha", message: "Informe seu email de acesso:", preferredStyle: .Alert)
            alertView.addTextFieldWithConfigurationHandler { (text) -> Void in
                email = text
                email!.placeholder = "email@email.com"
                email!.keyboardAppearance = UIKeyboardAppearance.Dark
                email!.keyboardType = UIKeyboardType.Alphabet
            }
            alertView.addAction(UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil))
            alertView.addAction(UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
                PFUser.requestPasswordResetForEmailInBackground(self.emailTextField!.text!)
                })
            presentViewController(alertView, animated: true, completion: nil)
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