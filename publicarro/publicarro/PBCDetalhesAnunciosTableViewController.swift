
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
    
    var previousControllerIdentifier: String!
    var imageSegue:UIImage?
    var objectAnuncio:PFObject!
    var objectAnuncioMotorista = PFObject(className: "AnuncioMotorista")
    var objectMotorista : PFObject!
    var controller: PBCLoadAnimationViewController!

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        oneLabel.text = objectAnuncio?.objectForKey("nome") as? String
        twoLabel.text = String(objectAnuncio?.objectForKey("vagas") as! Int)
        threeLabel.text = String.convertFromNSDateToString(objectAnuncio["inicioAnuncio"] as! NSDate)
        fourLabel.text = String.convertFromNSDateToString(objectAnuncio["inicioAnuncio"] as! NSDate)
        imagem.image = imageSegue
        
        self.controller = self.storyboard!.instantiateViewControllerWithIdentifier("LoadView") as! PBCLoadAnimationViewController

    }

    override func viewWillAppear(animated: Bool) {
        
        switch (previousControllerIdentifier)
        {
        case "AnuncioHistorico":
            if objectAnuncio!["emAberto"] as! Bool
            {
                btParticipar.setTitle("Cancelar", forState: .Normal)
            }else
            {
                btParticipar.hidden = true
            }
            break
        case "AnuncioLogin":
            btParticipar.setTitle("Participar", forState: .Normal)
            break
        default:
            break
        }
        
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    func AnuncioHistorico()
    {
        print("Cancelar")
        
        let vagas = self.objectAnuncio!["vagas"].integerValue
        
        self.objectAnuncio!["vagas"] = vagas + 1
        self.objectAnuncio!.saveInBackground()
        
        // Query AnuncioMotorista
        let queryAM = PFQuery(className: "AnuncioMotorista")
        
        // Query somente do que o motorista participa
        queryAM.whereKey("motorista", equalTo: objectMotorista)
        
        //Query de todos os objetos
        queryAM.findObjectsInBackgroundWithBlock { (tamanho, errorGet) -> Void in
            if errorGet == nil
            {
                
                // Query somente deste anúncio
                queryAM.whereKey("anuncio", equalTo: self.objectAnuncio)
                
                // Query do objeto a ser excluído
                queryAM.getFirstObjectInBackgroundWithBlock({ (AnuncioMotorista, errorGet) -> Void in
                    if errorGet == nil
                    {

                        // Deleta o objeto AnuncioMotorista
                        AnuncioMotorista?.deleteEventually()
                        
                        // Se o motorista pertence a somente uma campanha, a participação será alterado para false
                        if tamanho?.count == 1
                        {
                            self.objectMotorista["participando"] = false
                            self.objectMotorista.saveEventually()
                        }
                        UIView.transitionWithView(self.view, duration: 0.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations:
                            {
                                self.view.addSubview(self.controller.view)
                                self.controller.infoLabel.text = "Você saiu da campanha"
                                self.controller.sucesso()
                            }, completion: nil)

                        self.removeSubViewAndPop()
                    } else
                    {
                        print(errorGet)
                    }
                })

            } else
            {
                print(errorGet)
            }

        }
        
            }
    func AnuncioLogin()
    {
        print("Participar")
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
                                            
                                            if self.maior(currentFimAdesivamento, rhs: objectFimAnuncio)
                                            {
                                                self.salvarParticipacao("Você está sendo vinculado a segunda campanha em aberto")
                                            }
                                            else
                                            {
                                                UIView.transitionWithView(self.view, duration: 0.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations:
                                                    {
                                                        self.view.addSubview(self.controller.view)
                                                        self.controller.infoLabel.text = "Você não pode participar pois há conflito de datas entre as campanhas"
                                                        self.controller.falha()
                                                    }, completion: nil)
                                                self.removeSubView()
                                            }
                                        }
                                    }
                                    else
                                    {
                                        self.addChildViewController(self.controller)
                                        UIView.transitionWithView(self.view, duration: 0.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations:
                                            {
                                                self.view.addSubview(self.controller.view)
                                                self.controller.infoLabel.text = "Você não pode estar vinculado a mais de duas campanhas"
                                                self.controller.falha()
                                            }, completion: nil)
                                        self.removeSubView()
                                    }
                                }
                            }
                            else
                            {
                                self.salvarParticipacao("Você está sendo vinculado a uma campanha em aberto")
                            }
                        }
                        else
                        {
                            print("Erro = Query Anuncios")
                        }
                    })
                }
                else
                {
                    print("Erro = Query AnuncioMotorista")
                }
            })
        }
        else
        {
            UIView.transitionWithView(view, duration: 0.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations:
                {
                    self.view.addSubview(self.controller.view)
                    self.controller.infoLabel.text = "Motorista inativo."
                    self.controller.falha()
                }, completion: nil)
            self.removeSubView()
        }
    }
    
    @IBAction func participar(sender: AnyObject)
    {
        self.addChildViewController(self.controller)

        UIView.transitionWithView(view, duration: 0.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations:
        {
            self.view.addSubview(self.controller.view)
            self.controller.infoLabel.text = "Carregando..."
            self.controller.animacao()
        }, completion: nil)

        performSelector(Selector(previousControllerIdentifier))
        
    }

    func salvarParticipacao(message:String)
    {
        self.objectAnuncioMotorista["anuncio"] = self.objectAnuncio
        self.objectAnuncioMotorista["motorista"] = self.objectMotorista
        self.objectAnuncioMotorista.saveInBackgroundWithBlock { (success, error) -> Void in
            if error == nil
            {
                print("save anuncio motorista")
                
                self.objectMotorista["participando"] = true
                self.objectMotorista.saveInBackground()
                
                let vagas = self.objectAnuncio!["vagas"].integerValue
                
                self.objectAnuncio!["vagas"] = vagas - 1
                self.objectAnuncio?.saveEventually()
                
                UIView.transitionWithView(self.view, duration: 0.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations:
                    {
                        self.view.addSubview(self.controller.view)
                        self.controller.infoLabel.text = message
                        self.controller.sucesso()
                    }, completion: nil)
                self.removeSubViewAndPop()
                
            } else
            {
                print("error save Anuncio")
            }
        }

    }
    
    func removeSubView()
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3.0*Double(NSEC_PER_SEC))),dispatch_get_main_queue(),{
            self.controller.view.removeFromSuperview()
        })
        
    }
    
    func removeSubViewAndPop()
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3.0*Double(NSEC_PER_SEC))),dispatch_get_main_queue(),{
            self.controller.view.removeFromSuperview()
            self.navigationController?.popViewControllerAnimated(true)
        })
        
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
