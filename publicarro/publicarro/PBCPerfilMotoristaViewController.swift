
import UIKit
import Parse

class PBCPerfilMotoristaViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()


    

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
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
        PFUser.logOut()
        presentViewController((storyboard?.instantiateViewControllerWithIdentifier("NavigationBarTutorial"))!, animated: false, completion: nil)
    }
}