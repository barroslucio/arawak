
import UIKit
import Parse

class PBCPerfilMotoristaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logout(sender: AnyObject)
    {
        PFUser.logOutInBackgroundWithBlock { (error) -> Void in
            if error == nil
            {
                self.presentViewController(self.storyboard!.instantiateViewControllerWithIdentifier("LoginController"), animated: true, completion: nil)
            }
        }
    }

}
