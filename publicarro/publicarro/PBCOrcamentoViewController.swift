
import UIKit
import Parse

class PBCOrcamentoViewController: UIViewController
{
    @IBOutlet var bottonConstraint: NSLayoutConstraint!
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
    
    @IBAction func orcamentoButtonTapped(sender: AnyObject)
    {
        let orcamento = PFObject(className: "Orcamento")
        orcamento["nome"] = embeddedViewController.nomeTextField.text
        orcamento["telefone"] = embeddedViewController.telefoneTextField.text
        orcamento["email"] = embeddedViewController.emailTextField.text
        orcamento.saveInBackgroundWithBlock
        {(sucess, error) -> Void in
            print(sucess)
            print(error)
        }
    }
    
//    func keyboardWillShow(notification:NSNotification)
//    {
//        adjustingHeight(true, notification: notification)
//    }
//    
//    func keyboardWillHide(notification:NSNotification)
//    {
//        adjustingHeight(false, notification: notification)
//    }
//    
//    func adjustingHeight(show:Bool, notification:NSNotification)
//    {
//        // 1
//        var userInfo = notification.userInfo!
//        // 2
//        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
//        // 3
//        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
//        // 4
//        let changeInHeight = (CGRectGetHeight(keyboardFrame)) * (show ? 1 : -1)
//        //5
//        if (show && self.bottonConstraint.constant == 0){
//            UIView.animateWithDuration(animationDurarion, animations: { () -> Void in
//                self.bottonConstraint.constant += changeInHeight
//            })
//        }
//        else if (!show){
//            UIView.animateWithDuration(animationDurarion, animations: { () -> Void in
//                self.bottonConstraint.constant += changeInHeight
//            })
//        }
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "OrcamentoEmbedSegue"
        {
            embeddedViewController = segue.destinationViewController as? PBCOrcamentoTableViewController
        }
    }
}