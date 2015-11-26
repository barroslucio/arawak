import UIKit
import Parse

class PBCAnunciosLoginViewController: UITableViewController
{
    var array = NSArray()
    var arrayImage:[UIImage] = []
    var objectMotorista:PFObject!

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
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
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
        let object = array[indexPath.row]
        
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
                    self.arrayImage.append(UIImage(data:imageData!)!)
                    cell.imagem.image = UIImage(data:imageData!)
                }
        }
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "segueDetalhesAnuncio"
        {
            if let destination = segue.destinationViewController as? PBCDetalhesAnunciosTableViewController {
                if let index = tableView.indexPathForSelectedRow?.row {
                    destination.objectAnuncio = array.objectAtIndex(index) as? PFObject
//                    destination.objectMotorista = self.objectMotorista
                    destination.imageSegue = arrayImage[index]
                }
            }
        }

    }

    
}