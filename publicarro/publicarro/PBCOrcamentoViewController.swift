
import UIKit
import Parse

class PBCOrcamentoViewController: UIViewController, UIAlertViewDelegate
{
    @IBOutlet weak var bottonConstraint: NSLayoutConstraint!
    @IBOutlet weak var orcamentoButton: UIButton!
    
    var controller: PBCLoadAnimationViewController!

    private var embeddedViewController: PBCOrcamentoTableViewController!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: view.window)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissKeyboard"))
        navigationController?.navigationBar.hidden = false
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    func validarCampos() -> Bool
    {
        if embeddedViewController.nomeTextField.text?.isEmpty == true || embeddedViewController.emailTextField.text?.isEmpty == true || embeddedViewController.celularTextField.text?.isEmpty == true || embeddedViewController.celularTextField.text?.characters.count <= 14
        {
            var mensagem: String!
            if embeddedViewController.nomeTextField.text?.isEmpty == true && embeddedViewController.emailTextField.text?.isEmpty == true && embeddedViewController.celularTextField.text?.isEmpty == true
            {
                mensagem = "Informe seus dados."
            }
            else if embeddedViewController.nomeTextField.text?.isEmpty == true
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
            controller = storyboard!.instantiateViewControllerWithIdentifier("LoadView") as! PBCLoadAnimationViewController
            addChildViewController(controller!)
            UIView.transitionWithView(view, duration: 0.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                self.view.addSubview(self.controller!.view)
            }, completion: nil)
            controller.falha()
            controller.infoLabel.text = mensagem
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.7*Double(NSEC_PER_SEC))),dispatch_get_main_queue(),{
                self.controller.view.removeFromSuperview()
            })
            return false
        }
        return true
    }
    
    @IBAction func orcamentoTapped(sender: AnyObject)
    {
        if validarCampos() == true
        {
            dismissKeyboard()
            controller = storyboard!.instantiateViewControllerWithIdentifier("LoadView") as! PBCLoadAnimationViewController
            addChildViewController(controller!)
            UIView.transitionWithView(view, duration: 0.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                self.view.addSubview(self.controller!.view)
                self.controller.infoLabel.text = "Enviando . . ."
            }, completion: nil)
            let orcamento = PFObject(className: "Orcamento")
            orcamento["nome"] = embeddedViewController.nomeTextField.text
            orcamento["telefone"] = embeddedViewController.celularTextField.text
            orcamento["email"] = embeddedViewController.emailTextField.text
            orcamento["carros"] = Int(embeddedViewController.qtdCarros.text!)
            orcamento["meses"] = Int(embeddedViewController.qtdMeses.text!)
            orcamento.saveInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil
                {
                    self.controller.infoLabel.text = "Entraremos em contato"
                    self.controller.sucesso()
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(1.3*Double(NSEC_PER_SEC))),dispatch_get_main_queue(),{
                        self.controller!.view.removeFromSuperview()
                        self.embeddedViewController.nomeTextField.text = ""
                        self.embeddedViewController.celularTextField.text = ""
                        self.embeddedViewController.emailTextField.text = ""
                        self.embeddedViewController.qtdCarros.text = "10"
                        self.embeddedViewController.qtdMeses.text = "1"
                    })
                }
                else
                {
                    print("ERROR PARSE: \(error)")
                    self.controller.infoLabel.text = "Ocorreu um erro!"
                    self.controller.falha()
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.3*Double(NSEC_PER_SEC))),dispatch_get_main_queue(),{
                        self.controller!.view.removeFromSuperview()
                        self.dismissKeyboard()
                    })
                }
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
    
    func keyboardWillShow(notification: NSNotification)
    {
        adjustingHeight(true, notification: notification)
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        adjustingHeight(false, notification: notification)
    }
    
    func adjustingHeight(show:Bool, notification: NSNotification)
    {
        let changeInHeight = CGRectGetHeight(notification.userInfo![UIKeyboardFrameBeginUserInfoKey]!.CGRectValue) * (show ? 1 : -1)
        if show == true && bottonConstraint.constant == 0
        {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.bottonConstraint.constant += changeInHeight
            })
        }
        else if show == false
        {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.bottonConstraint.constant += changeInHeight
            })
        }
    }
}