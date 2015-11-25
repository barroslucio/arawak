import UIKit
import Parse

class PBCAnunciosLoginViewController: UITableViewController
{
    var array = NSArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationController?.navigationBar.hidden = false
    }
    override func viewDidAppear(animated: Bool) {
        query()
    }
    
    //Requisição de anúncios
    func query()
    {
        let query = PFQuery(className: "Anuncio")
        query.findObjectsInBackgroundWithBlock({ (anuncio, error) -> Void in
            
            if error == nil
            {
                self.array = anuncio!
                self.tableView.reloadData()
            } else
            {
                print(error)
            }
        })
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signUpButton(sender: AnyObject)
    {
       
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.array.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("AnuncioCell", forIndexPath: indexPath) as! AnuncioDisponivelTableViewCell
        let object = array.objectAtIndex(indexPath.row)
        
        cell.oneLabel.text = object.objectForKey("nome") as? String
        cell.twoLabel.text = object.objectForKey("inicio") as? String
        cell.threeLabel.text = object.objectForKey("fim") as? String
        cell.fourLabel.text = String(object.objectForKey("carros") as! Int)

        
        cell.activityIndicator.startAnimating()
        object.objectForKey("imagem")!.getDataInBackgroundWithBlock
        {
            (imageData: NSData?, error: NSError?) -> Void in
            
                if error == nil
                {
                    cell.activityIndicator.hidden = true
                    cell.imagem.image = UIImage(data:imageData!)
                }
        }
        return cell
    }
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
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}