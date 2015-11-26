
import UIKit
import Parse
import SystemConfiguration

class PBCLoginViewController: UIViewController
{
    
    
    //variavel que vai receber a view de load
    
    var array = NSArray()
    
    var controller: PBCLoadAnimationViewController!

    @IBOutlet var bottonConstraint: NSLayoutConstraint!
    private var embeddedLoginViewController : PBCLoginTableViewController!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: view.window)
        
        let dismiss: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(dismiss)
        
        navigationController?.navigationBar.hidden = false
    }
    
    
    
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
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
    
    @IBAction func loginTapped(sender: AnyObject)
    {
        
    
      
        
        if isConnectedToNetwork()
        {
            //se os campos estiverem validados, carrega a view de load
            self.controller = storyboard!.instantiateViewControllerWithIdentifier("LoadView") as! PBCLoadAnimationViewController
            addChildViewController(self.controller!)
            UIView.transitionWithView(view, duration: 0.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                
                self.view.addSubview(self.controller!.view)
                self.controller.infoLabel.text = "Realizando login..."
                
                }, completion: nil)

                PFUser.logInWithUsernameInBackground(embeddedLoginViewController.emailTextField.text!, password: embeddedLoginViewController.senhaTextField.text!, block: { (user, error) -> Void in
                    
                    
                    
                    
                if user != nil
                {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0*Double(NSEC_PER_SEC))),dispatch_get_main_queue(),
                        { self.controller.view.removeFromSuperview()})
                    print("Usuário Logado")
                    
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("AnunciosTabBar")
                    self.presentViewController(controller, animated: true, completion: nil)

                    
                }
                else
                {
                    var mensagem = String()
                    switch(error?.code)
                    {
                    case 101?:
                        mensagem = "Email ou senha incorretos."
                        break
                    default:
                        mensagem = "[ALGUM ERRO]"
                        break
                    }
                    //se os campos estiverem validados, carrega a view de load
                    self.controller.falha()
                    self.controller.infoLabel.text = mensagem

                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1*Double(NSEC_PER_SEC))),dispatch_get_main_queue(),{
                        self.controller.view.removeFromSuperview()
                    })
                }
            })
        } else {
            //se os campos estiverem validados, carrega a view de load
            self.controller = storyboard!.instantiateViewControllerWithIdentifier("LoadView") as! PBCLoadAnimationViewController
            addChildViewController(self.controller!)
            UIView.transitionWithView(view, duration: 0.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                
                self.view.addSubview(self.controller!.view)
                self.controller.falha()
                self.controller.infoLabel.text = "Sem conexão."
                
                }, completion: nil)
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1*Double(NSEC_PER_SEC))),dispatch_get_main_queue(),{
                self.controller.view.removeFromSuperview()
            })
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        //segue para a table view controller
        if(segue.identifier == "LoginEmbedSegue")
        {
            embeddedLoginViewController = segue.destinationViewController as? PBCLoginTableViewController
        }
    }
    
    // Conexão com a internet
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}