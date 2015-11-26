
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
    var objectAnuncio:PFObject?
    var objectAnuncioMotorista = PFObject(className: "AnuncioMotorista")
    var objectMotorista : PFObject!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        oneLabel.text = objectAnuncio?.objectForKey("nome") as? String
        twoLabel.text = String(objectAnuncio?.objectForKey("carros") as! Int)
        threeLabel.text = objectAnuncio?.objectForKey("inicio") as? String
        fourLabel.text = objectAnuncio?.objectForKey("fim") as? String
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
                self.objectMotorista = motorista
                self.btParticipar.setTitle("Participar", forState: .Normal)
                
                if self.objectMotorista!["ativo"] as! Bool
                {
                    self.btParticipar.setTitleColor(UIColor.blueColor(), forState:.Normal)
                } else
                {
                    self.btParticipar.setTitleColor(UIColor.grayColor(), forState:.Normal)
                    self.btParticipar.enabled = false
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
        objectAnuncioMotorista["anuncio"] = objectAnuncio
        objectAnuncioMotorista["motorista"] = objectMotorista
        
        objectAnuncioMotorista.saveInBackgroundWithBlock { (success, error) -> Void in
            if error == nil
            {
                print("save anuncio motorista")
            } else
            {
                print(error)
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
