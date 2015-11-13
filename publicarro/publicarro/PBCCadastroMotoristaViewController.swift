
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
        if embeddedCadastroMotoristaViewController.emailTextField.text?.isEmpty == true
        {
            let alertController = UIAlertController(title: "Erro", message: "Email não informado", preferredStyle: .Alert)
            //alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
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
            user.email = embeddedCadastroMotoristaViewController.emailTextField.text
            user.password = embeddedCadastroMotoristaViewController.senhaTextField.text
        
        
            //Salvando usuário class (_User)
            user.signUpInBackgroundWithBlock { (sucessUser, errorUser) -> Void in
                
                if(errorUser?.code == 125)
                {
                    print("email invalido")
                }
                
                if(errorUser == nil)
                {
                    print("\n\nSave user sucess")
                
                    
                    //Objeto da classe Motorista
                    let motorista = PFObject(className: "Motorista")
                    motorista["user"] = user
                    motorista["telefone"] = self.embeddedCadastroMotoristaViewController.celularTextField.text
                    motorista["latitude"] = Double((PBCCadastroMotoristaTableViewController.locationTeste?.latitude)!)
                    motorista["longitude"] = Double((PBCCadastroMotoristaTableViewController.locationTeste?.longitude)!)

                    if(PBCCadastroMotoristaTableViewController.chosenImage != nil)
                    {
                        print("image")
                    let imageData = UIImageJPEGRepresentation(PBCCadastroMotoristaTableViewController.chosenImage!, 0.1)
                    let imageFile = PFFile(name:"image.png", data:imageData!)
                    
                    motorista["imageCNH"] = imageFile
                    }else{
                        print("nil image")

                    }
                    
                    
                    //Salvando motorista class (Motorista)
                    motorista.saveInBackgroundWithBlock({ (sucessMotorista, errorMotorista) -> Void in
                
                    
                        if( sucessMotorista == true)
                        {
                            print("\n\nSave motorista sucess")
                        
                            //Objeto da classe Carro
                            let carro = PFObject(className: "Carro")
                            carro["motorista"] = motorista
                            carro["renavam"] = self.embeddedCadastroMotoristaViewController.renavamTextField.text
                
                        
                            //Salvando carro class (Carro)
                            carro.saveInBackgroundWithBlock({ (sucessCarro, errorCarro) -> Void in
                            
                                if( sucessCarro == true)
                                {
                                    print("\n\nSave carro sucess")
                                }
                                else
                                {
                                    print("\n\nSave carro error: \(errorCarro)")
                                    motorista.deleteInBackground()
                                    user.deleteInBackground()

                                }
                            })
                
                        }
                        else
                        {
                            print("\n\nSave motorista error: \(errorMotorista)")
                            user.deleteInBackground()
                        }
                    })
                }
                else
                {
                    print("\n\nSave user error: \(errorUser)")
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
