
import UIKit
import Parse

class PBCAnunciosLoginViewController: UITableViewController
{
    var array = NSArray()
    var image: UIImage!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        ParseContent()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return array.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("AnuncioCell", forIndexPath: indexPath) as! AnuncioDisponivelTableViewCell
        let object = array.objectAtIndex(indexPath.row)
        cell.oneLabel.text = object.objectForKey("nome") as? String
        cell.twoLabel.text = object.objectForKey("inicio") as? String
        cell.threeLabel.text = object.objectForKey("fim") as? String
        cell.fourLabel.text = object.objectForKey("carros")?.stringValue
        cell.activityIndicator.startAnimating()
        object.objectForKey("imagem")!.getDataInBackgroundWithBlock { (imageData, error) -> Void in
            if error == nil
            {
                cell.activityIndicator.stopAnimating()
                cell.activityIndicator.hidesWhenStopped = true
                cell.imagem.image = UIImage(data:imageData!)
            }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! AnuncioDisponivelTableViewCell
        image = cell.imagem.image!
        performSegueWithIdentifier("segueDetalhesAnuncio", sender: self)
    }
    
    func ParseContent()
    {
        let query = PFQuery(className: "Anuncio")
        query.findObjectsInBackgroundWithBlock({ (anuncio, error) -> Void in
            if error == nil
            {
                self.array = anuncio!
                self.tableView.reloadData()
            }
            else
            {
                print(error)
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "segueDetalhesAnuncio"
        {
            let destination = segue.destinationViewController as? PBCDetalhesAnunciosTableViewController
            let index = tableView.indexPathForSelectedRow?.row
            destination!.objectAnuncio = array.objectAtIndex(index!) as? PFObject
            destination!.imageSegue = image
        }
    }
}
