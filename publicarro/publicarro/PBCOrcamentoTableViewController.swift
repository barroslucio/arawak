
import UIKit

class PBCOrcamentoTableViewController: UITableViewController, UITextFieldDelegate
{
    @IBOutlet weak var nomeTextField: UITextField!
    @IBOutlet weak var telefoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var qtdCarros: UILabel!
    @IBOutlet weak var qtdMeses: UILabel!
    @IBOutlet weak var mesLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        nomeTextField.delegate = self
        telefoneTextField.delegate = self
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
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        if nomeTextField.text?.isEmpty == false && telefoneTextField.text?.isEmpty == false && emailTextField.text?.isEmpty == false
        {
            
        }
        else
        {
            
        }
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