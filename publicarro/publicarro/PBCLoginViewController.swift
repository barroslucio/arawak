
import UIKit
import Parse
import SystemConfiguration

class PBCLoginViewController: UIViewController
{
    @IBOutlet var bottonConstraint: NSLayoutConstraint!
    
    var array = NSArray()

    private var embeddedLoginViewController: PBCLoginTableViewController!
    
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
        dismissKeyboard()
        let controller = storyboard!.instantiateViewControllerWithIdentifier("LoadView") as! PBCLoadAnimationViewController
        addChildViewController(controller)
        if isConnectedToNetwork() == true
        {
            UIView.transitionWithView(view, duration: 0.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                self.view.addSubview(controller.view)
                controller.infoLabel.text = "Realizando login..."
                controller.animacao()
                }, completion: nil)
            PFUser.logInWithUsernameInBackground(embeddedLoginViewController.emailTextField.text!, password: embeddedLoginViewController.senhaTextField.text!, block: { (user, error) -> Void in
                if user != nil && error == nil
                {
                    self.presentViewController(self.storyboard!.instantiateViewControllerWithIdentifier("AnunciosTabBar"), animated: false, completion: nil)
                }
                else
                {
                    switch error!.code
                    {
                    case PFErrorCode.ErrorObjectNotFound.rawValue:
                        controller.infoLabel.text = "Email ou senha incorretos."
                        controller.falha()
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.8*Double(NSEC_PER_SEC))),dispatch_get_main_queue(),{
                            controller.view.hidden = true
                        })
                        break
                    default:
                        let alertView = UIAlertController(title: "Problem Code: "+error!.code.description, message: error!.localizedDescription, preferredStyle: .Alert)
                        alertView.addAction(UIAlertAction(title: "Click", style: .Cancel, handler: nil))
                        self.presentViewController(alertView, animated: true, completion: nil)
                    }
                }
            })
        }
        else
        {
            UIView.transitionWithView(view, duration: 0.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                self.view.addSubview(controller.view)
                controller.infoLabel.text = "Sem conexão."
                controller.falha()
                }, completion: nil)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.7*Double(NSEC_PER_SEC))),dispatch_get_main_queue(),{
                controller.view.hidden = true
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "LoginEmbedSegue")
        {
            embeddedLoginViewController = segue.destinationViewController as? PBCLoginTableViewController
        }
    }
    
    func isConnectedToNetwork() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress)
        {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags)
        {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}