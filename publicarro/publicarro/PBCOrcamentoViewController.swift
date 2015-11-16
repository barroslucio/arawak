
import UIKit
import Parse

class PBCOrcamentoViewController: UIViewController, UIAlertViewDelegate
{
    @IBOutlet weak var bottonConstraint: NSLayoutConstraint!
    @IBOutlet weak var orcamentoButton: UIButton!
    
    private var embeddedViewController: PBCOrcamentoTableViewController!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationController?.navigationBar.hidden = false
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func validarCampos() -> Bool
    {
        if embeddedViewController.nomeTextField.text?.isEmpty == true || embeddedViewController.emailTextField.text?.isEmpty == true || embeddedViewController.celularTextField.text?.isEmpty == true || embeddedViewController.celularTextField.text?.characters.count <= 14
        {
            var mensagem = String()
            if embeddedViewController.nomeTextField.text?.isEmpty == true
            {
                mensagem = "Informe seu nome."
            }
            else if embeddedViewController.celularTextField.text?.isEmpty == true
            {
                mensagem = "Informe seu celular."
            }
            else if embeddedViewController.celularTextField.text?.characters.count <= 14
            {
                mensagem = "Celular inválido."
            }
            else
            {
                mensagem = "Informe seu email."
            }
            let alertView = UIAlertController(title: "Aviso", message: mensagem, preferredStyle: .Alert)
            presentViewController(alertView, animated: false, completion: nil)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0*Double(NSEC_PER_SEC))),dispatch_get_main_queue(),{
                alertView.dismissViewControllerAnimated(false, completion: nil)
            })
            return false
        }
        return true
    }
    
    @IBAction func orcamentoTapped(sender: AnyObject)
    {
        if validarCampos() == true
        {
            let orcamento = PFObject(className: "Orcamento")
            orcamento["nome"] = self.embeddedViewController.nomeTextField.text
            orcamento["telefone"] = self.embeddedViewController.celularTextField.text
            orcamento["email"] = self.embeddedViewController.emailTextField.text
            orcamento["carros"] = Int(self.embeddedViewController.qtdCarros.text!)
            orcamento["meses"] = Int(self.embeddedViewController.qtdMeses.text!)
            orcamento.saveInBackground()
            let alertView = UIAlertController(title: "Aviso", message: "Orçamento feito com sucesso, aguarde nosso retorno!", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alertView, animated: false, completion: nil)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3.0*Double(NSEC_PER_SEC))),dispatch_get_main_queue(),{
                    alertView.dismissViewControllerAnimated(false, completion: nil)
            })
        }
    }
        
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "OrcamentoEmbedSegue"
        {
            embeddedViewController = segue.destinationViewController as? PBCOrcamentoTableViewController
        }
    }
}