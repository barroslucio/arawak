
import UIKit
import Parse

class PBCDetalhesAnunciosTableViewController: UITableViewController
{
    
 
    @IBOutlet weak var oneLabel: UILabel!
    @IBOutlet weak var twoLabel: UILabel!
    @IBOutlet weak var threeLabel: UILabel!
    @IBOutlet weak var fourLabel: UILabel!
    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var btParticipar: UIButton!
    
    var imageSegue:UIImage?
    var object:PFObject?
    var ativo = false
    var motorista : PFObject!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        oneLabel.text = object?.objectForKey("nome") as? String
        twoLabel.text = String(object?.objectForKey("carros") as! Int)
        threeLabel.text = object?.objectForKey("inicio") as? String
        fourLabel.text = object?.objectForKey("fim") as? String
        imagem.image = imageSegue
        queryMotorista()
    }
    
    
    func queryMotorista()
    {
        let query = PFQuery(className: "Motorista")
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        
        query.getFirstObjectInBackgroundWithBlock { (motorista, error) -> Void in
            
            if error == nil
            {
                self.motorista = motorista
                
                if self.motorista!["ativo"] as! Bool
                {
                    print("cancel")
                    self.btParticipar.setTitle("Cancelar", forState: .Normal)
                    self.btParticipar.setTitleColor(UIColor.redColor(), forState:.Normal)
                    
                } else
                {
                    self.btParticipar.setTitle("Participar", forState: .Normal)
                    self.btParticipar.setTitleColor(UIColor.blueColor(), forState:.Normal)

                    print("participar")

                }
                
            }
            
        }

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func participar(sender: AnyObject)
    {
        motorista["ativo"] = !(motorista["ativo"] as! Bool)
        
        motorista.saveInBackgroundWithBlock { (save, error) -> Void in
            if error == nil
            {
                print("Save motorista")
                self.queryMotorista()
            }
        }
        
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    */

}
