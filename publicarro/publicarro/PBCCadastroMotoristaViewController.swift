
import UIKit
import Parse
import CoreLocation

class PBCCadastroMotoristaViewController: UIViewController
{
    
    // Outlet da constraint de base do botão de cadastro que vai ser manipulado quando o teclado aparecer ou sumir.
    @IBOutlet var bottonConstraint: NSLayoutConstraint!
    
    //Instância da classe com os outlets
    private var embeddedCadastroMotoristaViewController : PBCCadastroMotoristaTableViewController!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationController?.navigationBar.hidden = false
        
        let dismiss: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(dismiss)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: self.view.window)
        
    }
    
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    
    func keyboardWillShow(notification:NSNotification) {
        adjustingHeight(true, notification: notification)
    }
    
    func keyboardWillHide(notification:NSNotification) {
        adjustingHeight(false, notification: notification)
    }
    
    func adjustingHeight(show:Bool, notification:NSNotification) {
        // 1
        var userInfo = notification.userInfo!
        // 2
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        // 3
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        // 4
        let changeInHeight = (CGRectGetHeight(keyboardFrame)) * (show ? 1 : -1)
        //5
        if (show && self.bottonConstraint.constant == 0){
            UIView.animateWithDuration(animationDurarion, animations: { () -> Void in
                self.bottonConstraint.constant += changeInHeight
            })
        }
        else if (!show){
            UIView.animateWithDuration(animationDurarion, animations: { () -> Void in
                self.bottonConstraint.constant += changeInHeight
            })
        }
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func validarCampos() -> Bool
    {
        if embeddedCadastroMotoristaViewController.renavamTextField.text?.isEmpty == true || embeddedCadastroMotoristaViewController.celularTextField.text?.isEmpty == true || embeddedCadastroMotoristaViewController.senhaTextField.text?.isEmpty == true
        {
            var mensagem = String()
            if embeddedCadastroMotoristaViewController.renavamTextField.text?.isEmpty == true
            {
                mensagem = "Renavam não informado."
            }
            else if embeddedCadastroMotoristaViewController.renavamTextField.text?.characters.count < 9
            {
                mensagem = "Renavam inválido."
            }
            else if embeddedCadastroMotoristaViewController.celularTextField.text?.isEmpty == true
            {
                mensagem = "Celular não informado."
            }
            else if embeddedCadastroMotoristaViewController.celularTextField.text?.characters.count <= 13
            {
                mensagem = "Celular incorreto."
            }
            else if embeddedCadastroMotoristaViewController.senhaTextField.text?.isEmpty == true
            {
                mensagem = "Informe uma senha !"
            }
            let alertView = UIAlertController(title: "Aviso", message: mensagem, preferredStyle: .Alert)
            presentViewController(alertView, animated: false, completion: nil)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0*Double(NSEC_PER_SEC))),dispatch_get_main_queue(),
            {
                alertView.dismissViewControllerAnimated(false, completion: nil)
            })
            return false
        }
        return true
    }
    
    @IBAction func cadastroTapped(sender: AnyObject)
    {
        if validarCampos() == true
        {
            
            //Objeto da classes _User
            let user = PFUser()
            
            user.username = embeddedCadastroMotoristaViewController.emailTextField.text
            user.password = embeddedCadastroMotoristaViewController.senhaTextField.text
            user.email = user.username
            
            
            //Salvando usuário class (_User)
            user.signUpInBackgroundWithBlock { (sucessUser, errorUser) -> Void in
                if(errorUser == nil)
                {
                    print("\n\nUser sucess")
                    
                    //Objeto da classe Motorista
                    let motorista = PFObject(className: "Motorista")
                    motorista["user"] = user
                    motorista["telefone"] = self.embeddedCadastroMotoristaViewController.celularTextField.text
                    
                    
                    
                    //Salvando motorista class (Motorista)
                    motorista.saveInBackgroundWithBlock({ (sucessMotorista, errorMotorista) -> Void in
                        
                        
                        if( sucessMotorista == true)
                        {
                            print("\n\nMotorista sucess")
                            
                            //Objeto da classe Carro
                            let carro = PFObject(className: "Carro")
                            carro["motorista"] = motorista
                            carro["renavam"] = self.embeddedCadastroMotoristaViewController.renavamTextField.text
                            
                            
                            //Salvando carro class (Carro)
                            carro.saveInBackgroundWithBlock({ (sucessCarro, errorCarro) -> Void in
                                
                                if( sucessCarro == true)
                                {
                                    print("\n\nCarro sucess")
                                }
                                else
                                {
                                    print("\n\nCarro error: \(errorCarro)")
                                }
                            })
                            
                        }
                        else
                        {
                            print("\n\nMotorista error: \(errorMotorista)")
                        }
                    })
                }
                else
                {
                    print("\n\n-----> Erro no Parse: \(errorUser)\n\n")
                    if errorUser != nil
                    {
                        var mensagem = String()
                        switch errorUser?.code
                        {
                            case 125?: mensagem = "Email inválido."
                            break
                            case 200?: mensagem = "Email não informado."
                            break
                            case 202?: mensagem = "Este email não está disponível"
                            break
                            default: mensagem = "ALGUM ERRO"
                        }
                        let alertView = UIAlertController(title: "Aviso", message: mensagem, preferredStyle: .Alert)
                        self.presentViewController(alertView, animated: false, completion: nil)
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0*Double(NSEC_PER_SEC))),dispatch_get_main_queue(),
                        {
                            alertView.dismissViewControllerAnimated(false, completion: nil)
                        })
                    }
                }
            }
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        //segue que acessa a classe dos outlets
        if(segue.identifier == "CadastroMotoristaEmbedSegue")
        {
            embeddedCadastroMotoristaViewController = segue.destinationViewController as? PBCCadastroMotoristaTableViewController
        }
    }
    
}