
import UIKit
import Parse

class PBCLoginViewController: UIViewController
{
    
    @IBOutlet var bottonConstraint: NSLayoutConstraint!
    private var embeddedLoginViewController : PBCLoginTableViewController!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: view.window)
        navigationController?.navigationBar.hidden = false
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
//        let controller = storyboard!.instantiateViewControllerWithIdentifier("LoadView")
//        addChildViewController(controller)
//        UIView.transitionWithView(view, duration: 0.0, options: UIViewAnimationOptions.TransitionNone, animations: {self.view.addSubview(controller.view)}, completion: nil)
        PFUser.logInWithUsernameInBackground(embeddedLoginViewController.emailTextField.text!, password: embeddedLoginViewController.senhaTextField.text!, block: { (user, error) -> Void in
//            controller.view.removeFromSuperview()
            if user != nil
            {
                print("Usuário Logado")
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
                let alertView = UIAlertController(title: "Aviso", message: mensagem, preferredStyle: .Alert)
                self.presentViewController(alertView, animated: false, completion: nil)
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1*Double(NSEC_PER_SEC))),dispatch_get_main_queue(),{
                    alertView.dismissViewControllerAnimated(false, completion: nil)
                })
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "LoginEmbedSegue")
        {
            embeddedLoginViewController = segue.destinationViewController as? PBCLoginTableViewController
        }
    }
}