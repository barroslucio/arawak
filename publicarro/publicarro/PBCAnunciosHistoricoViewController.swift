//
//  PBCAnunciosHistoricoViewController.swift
//  publiCarro
//
//  Created by Lúcio Barros on 23/11/15.
//  Copyright © 2015 tambatech. All rights reserved.
//

import UIKit
import Parse

class PBCAnunciosHistoricoViewController: UITableViewController {
    
    var array = NSArray()
    var objectMotorista : PFObject?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("AnuncioCell", forIndexPath: indexPath) as! PBCAnunciosHistoricoTableViewCell
        let object = array[indexPath.row]
        
        
        cell.oneLabel.text = object["nome"] as? String
        cell.twoLabel.text = String.convertFromNSDateToString(object["inicioAnuncio"] as! NSDate)
        cell.threeLabel.text = String.convertFromNSDateToString(object["fimAnuncio"] as! NSDate)
        
        cell.fourLabel.text = (object["vagas"]?!.stringValue)!
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
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! PBCAnunciosHistoricoTableViewCell
        performSegueWithIdentifier("segueDetalhesHistoricoAnuncio", sender: cell.imagem.image!)
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
                queryAM.findObjectsInBackgroundWithBlock({ (arrayAnuncioMotorista, error) -> Void in
                    if error == nil
                    {
                        // Recebe os objectId's dos anúncios que o motorista participa
                        var arrayAnuncios : [String] = []
                        
                        // Objetos de AnuncioMotorista que o motorista participa
                        if let objectsAnuncioMotorista = arrayAnuncioMotorista
                        {
                            for object in objectsAnuncioMotorista
                            {
                                // Adiciona objectId de Anuncio's na lista de Anuncio que o motorista participa
                                
                                arrayAnuncios.append(object["anuncio"].objectId!!)
                            }
                        }
                        
                        // Query Anuncio
                        let queryAnuncios = PFQuery(className: "Anuncio")
                        
                        // Query somente de Anuncio's que o motorista participa
                        queryAnuncios.whereKey("objectId", containedIn: arrayAnuncios)                        
                        
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
        if segue.identifier == "segueDetalhesHistoricoAnuncio"
        {
            let destination = segue.destinationViewController as? PBCDetalhesAnunciosTableViewController
            let index = tableView.indexPathForSelectedRow?.row
            destination!.objectAnuncio = array.objectAtIndex(index!) as? PFObject
            destination!.imageSegue = sender as? UIImage
            destination?.objectMotorista = objectMotorista
            destination?.previousControllerIdentifier = "AnuncioHistorico"
        }
    }

}
