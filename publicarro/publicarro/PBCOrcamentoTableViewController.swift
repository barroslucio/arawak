
import UIKit

class PBCOrcamentoTableViewController: UITableViewController, UITextFieldDelegate
{
    @IBOutlet weak var nomeTextField: UITextField!
    @IBOutlet weak var celularTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var qtdCarros: UILabel!
    @IBOutlet weak var qtdMeses: UILabel!
    @IBOutlet weak var mesLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        nomeTextField.delegate = self
        celularTextField.delegate = self
        emailTextField.delegate = self
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func carroStepper(sender: UIStepper)
    {
        qtdCarros.text = Int(sender.value).description
    }
    
    @IBAction func mesStepper(sender: UIStepper)
    {
        if Int(sender.value) == 1
        {
            mesLabel.text = "Mês"
        }
        else
        {
            mesLabel.text = "Meses"
        }
        qtdMeses.text = Int(sender.value).description
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        if textField == celularTextField
        {
            if textField.text?.characters.count <= 14
            {
                if range.location == 2
                {
                    textField.text = "("+textField.text!+") 9"
                }
                else if range.location == 10
                {
                    textField.text = textField.text!+"-"
                }
            }
            else
            {
                return false
            }
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
}