
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
    
    override func viewDidAppear(animated: Bool) {
        
        let pushQuery = PFInstallation.query()!
        pushQuery.whereKey("user", equalTo: PFUser.currentUser()!)
        let data = ["alert" : "New message from \(PFUser.currentUser())", "badge" : "Increment"]
        let push = PFPush()
        push.setQuery(pushQuery)
        push.setData(data)
        push.sendPushInBackground()
        

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
