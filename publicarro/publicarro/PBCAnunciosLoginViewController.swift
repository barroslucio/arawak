
import UIKit
import Parse

class PBCAnunciosLoginViewController: UITableViewController
{
    var array = NSArray()
    var objectMotorista : PFObject?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
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
        let object = array[indexPath.row]
        
        
        cell.oneLabel.text = object.objectForKey("nome") as? String
        cell.twoLabel.text = convertFromNSdateToString(object.objectForKey("inicioAnuncio") as! NSDate)
        cell.threeLabel.text = convertFromNSdateToString(object.objectForKey("fimAnuncio") as! NSDate)

        cell.fourLabel.text = "restam " + (object.objectForKey("carros")?.stringValue)! + " vagas"
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
        performSegueWithIdentifier("segueDetalhesAnuncio", sender: cell.imagem.image!)
    }
    
    // MARK: - Navigation
    
    
    func convertFromNSdateToString(date:NSDate) -> String
    {
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        return dateFormatter.stringFromDate(date)
    }
    
    func ParseContent()
    {
        // Query Motorista
        let queryMotorista = PFQuery(className: "Motorista")
        
        // Query somente Motorista logado
        queryMotorista.whereKey("user", equalTo: PFUser.currentUser()!)
        queryMotorista.getFirstObjectInBackgroundWithBlock { (motorista, error) -> Void in
            if error == nil
            {
                self.objectMotorista = motorista
                
                // Query AnuncioMotorista
                let queryAM = PFQuery(className: "AnuncioMotorista")
                
                // Query somente do que o motorista participa
                queryAM.whereKey("motorista", equalTo: motorista!)
                queryAM.findObjectsInBackgroundWithBlock({ (arrayNotAnuncioMotorista, error) -> Void in
                    if error == nil
                    {
                        // Recebe os objectId's dos anúncios que o motorista participa e não poderão ser exibidos
                        var arrayNotAnuncios : [String] = []
                        
                        // Objetos de AnuncioMotorista que o motorista participa
                        if let objectsNotAnuncioMotorista = arrayNotAnuncioMotorista
                        {
                            for object in objectsNotAnuncioMotorista
                            {
                                // Adiciona objectId de Anuncio's na lista de Anuncio que o motorista participa
                                
                                arrayNotAnuncios.append(object["anuncio"].objectId!!)
                            }
                        }
                        
                        // Query Anuncio
                        let queryAnuncios = PFQuery(className: "Anuncio")
                        
                        // Query somente de Anuncio's que o motorista não participa
                        queryAnuncios.whereKey("objectId", notContainedIn: arrayNotAnuncios)
                        
                        // Query somente de Anuncio's em aberto
                        queryAnuncios.whereKey("emAberto", equalTo: true)
                        
                        
                        queryAnuncios.findObjectsInBackgroundWithBlock({ (arrayAnuncios, error) -> Void in
                            if error == nil
                            {
                                // Lista de Anuncio's
                                self.array = arrayAnuncios!
                                self.tableView.reloadData()
                            } else {
                                print("Erro query Anuncios")
                            }
                        })
                    } else
                    {
                        print("Erro query AnuncioMotorista")
                    }
                })
            } else
            {
                print("Erro query Motorista")
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "segueDetalhesAnuncio"
        {
            let destination = segue.destinationViewController as? PBCDetalhesAnunciosTableViewController
            let index = tableView.indexPathForSelectedRow?.row
            destination!.objectAnuncio = array.objectAtIndex(index!) as? PFObject
            destination!.imageSegue = sender as? UIImage
            destination?.objectMotorista = objectMotorista
        }
    }
}
