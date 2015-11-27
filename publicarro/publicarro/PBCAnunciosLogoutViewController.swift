
import UIKit
import Parse

class PBCAnunciosLogoutViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    
    var array = NSArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        parseContent()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return array.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("CELL", forIndexPath: indexPath) as! LogoutAnuncioTableViewCell
        let object = array.objectAtIndex(indexPath.row)
        object.objectForKey("imagem")!.getDataInBackgroundWithBlock { (imageData, error) -> Void in
            if error == nil
            {
                cell.imageAnuncio.image = UIImage(data:imageData!)
            }
        }
        return cell
    }
    
    func parseContent()
    {
        let query = PFQuery(className: "Anuncio")
        query.findObjectsInBackgroundWithBlock({ (data, error) -> Void in
            self.array = data!
            self.tableView.reloadData()
        })
    }
    
    @IBAction func cadastro(sender: AnyObject)
    {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("CadastroView")
        addChildViewController(controller)
        UIView.transitionWithView(view, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {self.view.addSubview(controller.view)}, completion: nil)
    }
}