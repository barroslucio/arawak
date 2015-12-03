
import UIKit
import Parse

class PBCPerfilMotoristaViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logout(sender: UIButton)
    {
        PFUser.logOut()
        presentViewController((storyboard?.instantiateViewControllerWithIdentifier("NavigationBarTutorial"))!, animated: false, completion: nil)
    }
}