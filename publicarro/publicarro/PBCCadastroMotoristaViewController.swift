
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
            presentViewController(alertController, animated: false, completion: nil)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0*Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                alertController.dismissViewControllerAnimated(false, completion: nil)
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
            user.email = user.username
            user.password = embeddedCadastroMotoristaViewController.senhaTextField.text
            
            
            //Salvando usuário class (_User)
            user.signUpInBackgroundWithBlock { (sucessUser, errorUser) -> Void in
                
                if(errorUser?.code == 125)
                {
                    print("email invalido")
                }
                
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
                    print("\n\nUser error: \(errorUser)")
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


/*
let alert = UIAlertController(title: "Alerta", message: "teste", preferredStyle: UIAlertControllerStyle.Alert)

let subview = alert.view.subviews.first! as UIView

let alertContentView = subview.subviews.first! as UIView

let ok = UIAlertAction(title: "ok", style: .Default, handler: { (ok) -> Void in
alert.dismissViewControllerAnimated(true, completion: nil)
})

let attributedMessage = NSAttributedString(string: "Message message message", attributes: [
NSFontAttributeName : UIFont.systemFontOfSize(15, weight: 3),
NSForegroundColorAttributeName : UIColor.whiteColor()
])

let attributedTitle = NSAttributedString(string: "Title of alert", attributes: [
NSFontAttributeName : UIFont.systemFontOfSize(20, weight: 5),
NSForegroundColorAttributeName : UIColor.whiteColor()
])

alert.setValue(attributedMessage, forKey: "attributedMessage")
alert.setValue(attributedTitle, forKey: "attributedTitle")

alertContentView.backgroundColor = UIColor(red:0.11, green:0.15, blue:0.18, alpha:1.0)
alertContentView.layer.cornerRadius = 5;

alert.view.tintColor = UIColor.whiteColor();

alert.addAction(ok)

self.presentViewController(alert, animated: true, completion: nil)
*/



/*
//Define a color
let color = UIColor.redColor()

//Make a controller
let alertVC = UIAlertController(title: "Dont care what goes here, since we're about to change below", message: "", preferredStyle: UIAlertControllerStyle.Alert)

//Title String
var hogan = NSMutableAttributedString(string: "Presenting the great... Hulk Hogan!")

//Make the attributes, like size and color
hogan.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(40.0), range: NSMakeRange(24, 11))

hogan.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(0, NSString(string: hogan.string).length))

//Set the new title
//Use "attributedMessage" for the message
alertVC.setValue(hogan, forKey: "attributedTitle")

//This will change the button color
alertVC.view.tintColor = UIColor.orangeColor()

//Make the button
let button:UIAlertAction  = UIAlertAction(title: "Label text", style: UIAlertActionStyle.Default, handler: { (e:UIAlertAction!) -> Void in
print("\(e)")
})

//You can add images to the button
let accessoryImage:UIImage = UIImage(named: "pessoaIcon")!
button.setValue(accessoryImage, forKey:"image")

//Add the button to the alert
alertVC.addAction(button)

//Finally present it
self.presentViewController(alertVC, animated: true, completion:  nil)
*/
