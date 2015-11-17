
import UIKit
import Parse
import CoreLocation

class PBCCadastroMotoristaViewController: UIViewController
{
    let loadAnimationView = PBCLoadAnimationViewController()
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
    
    //variavel que vai receber a view de load
    var controller: UIViewController?

    @IBAction func cadastroTapped(sender: AnyObject)
    {
    
        if validarCampos() == true
        {
        
            //se os campos estiverem validados, carrega a view de load
            controller = storyboard!.instantiateViewControllerWithIdentifier("LoadView")
            addChildViewController(controller!)
            UIView.transitionWithView(view, duration: 0.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {self.view.addSubview(self.controller!.view)}, completion: nil)
        

        
            //Objeto da classes _User
            let user = PFUser()
            
            user.username = embeddedCadastroMotoristaViewController.emailTextField.text
            user.email = embeddedCadastroMotoristaViewController.emailTextField.text
            user.password = embeddedCadastroMotoristaViewController.senhaTextField.text
            
            
            
            //Salvando usuário class (_User)
            user.signUpInBackgroundWithBlock { (sucessUser, errorUser) -> Void in
                if(errorUser == nil)
                {
                    print("\n\nSave user sucess")
                
                    
                    //Objeto da classe Motorista
                    let motorista = PFObject(className: "Motorista")
                    let location = PBCCadastroMotoristaTableViewController.motoristaLocation!
                    
                    motorista["user"] = user
                    motorista["telefone"] = self.embeddedCadastroMotoristaViewController.celularTextField.text
                    
                    motorista["latitude"] = Double(location.latitude)
                    motorista["longitude"] = Double(location.longitude)
                    motorista["localizacao"] = PFGeoPoint(latitude: Double(location.latitude), longitude: Double(location.longitude))
                    
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
                                    //caso tenha conseguido salvar com sucesso, para de exibir a view de load.
                                    self.controller!.view.removeFromSuperview()
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
                    print("\n\n-----> Erro no Parse: \(errorUser)\n\n")
                    if errorUser != nil
                    {
                        var mensagem = String()
                        switch errorUser?.code
                        {
                            case 125?: mensagem = "Email inválido."
                            case 200?: mensagem = "Informe um email."
                            case 201?: mensagem = "Informe uma senha."
                            case 202?: mensagem = "Email já cadastrado."
                            default: mensagem = "[ALGUM ERRO]"
                        }
                        
                        //caso tenha dado erro remove a tela de load antes de exibir o erro.
                        self.controller!.view.removeFromSuperview()

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