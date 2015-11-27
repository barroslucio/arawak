
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
    }
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func participar(sender: AnyObject)
    {
        if self.objectMotorista!["ativo"] as! Bool
        {
            
            // Query AnuncioMotorista
            let queryAM = PFQuery(className: "AnuncioMotorista")
            
            // Query somente do que o motorista participa
            queryAM.whereKey("motorista", equalTo: objectMotorista)
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
                    
                    // Query somente de Anuncio's que o motorista já participa
                    queryAnuncios.whereKey("objectId", containedIn: arrayAnuncios)
                    
                    queryAnuncios.findObjectsInBackgroundWithBlock({ (arrayAnuncios, error) -> Void in
                        if error == nil
                        {
                            if self.objectMotorista["participando"] as! Bool
                            {
                                // Lista de Anuncio's em aberto que o motorista já participa
                                if let objectsExists = arrayAnuncios
                                {
                                    if objectsExists.count < 2
                                    {
                                        for object in objectsExists
                                        {
                                            let currentFimAdesivamento: NSDate = self.objectAnuncio!["fimAdesivamento"] as! NSDate
                                            let objectFimAnuncio: NSDate = object["fimAnuncio"] as! NSDate
                                            
                                            //let currentFimAnuncio: NSDate = self.objectAnuncio!["fimAnuncio"] as! NSDate
                                            //let objectFimAdesivamento: NSDate = object["fimAdesivamento"] as! NSDate
                                            
                                            // Verifica se essa campanha é depois da qual ele já participa
                                            if self.maiorIgual(currentFimAdesivamento, rhs: objectFimAnuncio)
                                                // Verifica se é antes da qual ele já participa
                                                //&& self.menor(currentFimAnuncio, rhs: objectFimAdesivamento)
                                            {
                                                print("\nVocê está sendo vinculado a segunda campanha em aberto")
                                                self.salvarParticipacao()
                                            } else
                                            {
                                                print("\nVocê não pode participar pois há conflito de datas entre as campanhas")
                                            }
                                        }
                                    } else
                                    {
                                       print("\nVocê não pode estar vinculado a mais de duas campanhas")
                                    
                                    }
                                }
                            } else
                            {
                                print("\nVocê Você está sendo vinculado a uma campanha em aberto")
                                self.salvarParticipacao()
                            }

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
            print("Motorista inativo")

        }
        
    }
    
    func salvarParticipacao()
    {
        self.objectAnuncioMotorista["anuncio"] = self.objectAnuncio
        self.objectAnuncioMotorista["motorista"] = self.objectMotorista
        
        self.objectAnuncioMotorista.saveInBackgroundWithBlock { (success, error) -> Void in
            if error == nil
            {
                print("save anuncio motorista")
                
                self.objectMotorista["participando"] = true
                self.objectMotorista.saveInBackground()
                
                let vagas = (self.objectAnuncio!["vagas"] as! Int) - 1
                
                self.objectAnuncio!["vagas"] = vagas
                self.objectAnuncio?.saveInBackground()
                
                self.navigationController?.popViewControllerAnimated(true)
            } else
            {
                print("error save Anuncio")
            }
        }

    }

    // Comparando datas
    func menorIgual(lhs: NSDate, rhs: NSDate) -> Bool
    {return lhs.timeIntervalSince1970 <= rhs.timeIntervalSince1970}
    
    func maiorIgual(lhs: NSDate, rhs: NSDate) -> Bool
    {return lhs.timeIntervalSince1970 >= rhs.timeIntervalSince1970}
    
    func maior(lhs: NSDate, rhs: NSDate) -> Bool
    {
        print("\(lhs) > \(rhs)")
        return lhs.timeIntervalSince1970 > rhs.timeIntervalSince1970
    }
    
    func menor(lhs: NSDate, rhs: NSDate) -> Bool
    {return lhs.timeIntervalSince1970 < rhs.timeIntervalSince1970}
    
    func igual(lhs: NSDate, rhs: NSDate) -> Bool
    {return lhs.timeIntervalSince1970 == rhs.timeIntervalSince1970}
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }

}
