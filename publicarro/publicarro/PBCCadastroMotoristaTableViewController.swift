
import UIKit
import CoreLocation


class PBCCadastroMotoristaTableViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()

    
    //OUTLES
    @IBOutlet weak var nome: UITextField!
    @IBOutlet weak var telefone: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var senha: UITextField! 
    @IBOutlet weak var cpf: UITextField!
    @IBOutlet weak var cep: UITextField!
    @IBOutlet weak var estado: UITextField!
    @IBOutlet weak var cidade: UITextField!
    @IBOutlet weak var bairro: UITextField!
    @IBOutlet weak var endereco: UITextField!
    @IBOutlet weak var renavamCarro: UITextField!
    
    @IBOutlet weak var imagePicker: UIButton!
    let picker = UIImagePickerController()
    var chosenImage : UIImage?

    
    @IBAction func abrirSettings(sender: AnyObject) {
        let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
        if let url = settingsUrl {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // Adicionando delegate aos outlets
//        self.telefone.delegate = self
//        self.cpf.delegate = self
//        self.cep.delegate = self
//        self.email.delegate = self
//        self.senha.delegate = self
//        self.endereco.delegate = self
//        self.renavamCarro.delegate = self
//        self.cidade.delegate = self
//        self.estado.delegate = self
//        self.nome.delegate = self
//        self.bairro.delegate = self
        
        picker.delegate = self
        
        self.locationManager.requestAlwaysAuthorization()
        
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }

        
    }
    
 //   func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      //  let locValue:CLLocationCoordinate2D = manager.location!.coordinate
      //  print("locations = \(locValue.latitude) \(locValue.longitude)")
  //  }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //TABLEVIEW
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    
    //TEXTFIELD
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if(textField == self.telefone)
        {
            return maskTelefone(textField, replacementString: string)
        }
        if(textField == self.cpf)
        {
            return maskCpf(textField, replacementString: string)
        }
        if(textField == self.cep)
        {
            return maskCep(textField, replacementString: string)
        }
        return true
    }
    
    // máscara para telefone
    func maskTelefone(textField: UITextField, replacementString string: String) -> Bool
    {
        if (string.characters.count >= 1) {
            if (textField.text?.characters.count <= 14) {
                if (textField.text?.characters.count == 2) {
                    let tempStr = "(" + textField.text! + ") "
                    textField.text = tempStr
                    
                } else if (textField.text?.characters.count == 10) {
                    let tempStr = textField.text! + "-"
                    textField.text = tempStr
                }
            } else {
                return false;
            }
        }
        return true
    }
    
    
    // máscara para cpf
    func maskCpf(textField: UITextField, replacementString string: String) -> Bool
    {
        if (string.characters.count >= 1) {
            if (textField.text?.characters.count <= 13) {
                if (textField.text?.characters.count == 3) {
                    let tempStr = textField.text! + "."
                    textField.text = tempStr
                    
                } else if (textField.text?.characters.count == 7) {
                    let tempStr = textField.text! + "."
                    textField.text = tempStr
                } else if (textField.text?.characters.count == 11) {
                    let tempStr = textField.text! + "-"
                    textField.text = tempStr
                }
            } else {
                return false;
            }
        }
        return true
    }
    
    
    // máscara para cep
    func maskCep(textField: UITextField, replacementString string: String) -> Bool
    {
        if (string.characters.count >= 1) {
            if (textField.text?.characters.count <= 10) {
                if (textField.text?.characters.count == 3) {
                    let tempStr = textField.text! + "."
                    textField.text = tempStr
                    
                } else if (textField.text?.characters.count == 7) {
                    let tempStr = textField.text! + "-"
                    textField.text = tempStr
                }
            } else {
                return false;
            }
        }
        return true
    }
    
    //IMAGE
    @IBAction func imagePickerAction(sender: AnyObject)
    {
        let actionSheetCamera = UIAlertController(title: "", message: "Adicione a foto da sua habilitação", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        
        let camera = UIAlertAction(title: "Tirar foto", style: .Default, handler: { (camera) -> Void in
            self.shootPhoto()
        })
        
        let library = UIAlertAction(title: "Biblioteca de fotos", style: .Default, handler: { (camera) -> Void in
            self.photoFromLibrary()
        })
        
        let showPhoto = UIAlertAction(title: "Visualizar", style: .Default, handler: { (camera) -> Void in
            
            print("ver foto")
        })
        
        let cancel = UIAlertAction(title: "Cancelar", style: .Cancel, handler: { (cancel) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        
        if (imagePicker.imageView?.backgroundColor != chosenImage)
        {
            actionSheetCamera.addAction(showPhoto)
        }
        actionSheetCamera.addAction(camera)
        actionSheetCamera.addAction(library)
        actionSheetCamera.addAction(cancel)
        
        
        
        self.presentViewController(actionSheetCamera, animated: true, completion: nil)
        
    }
    
    //MARK: Delegates
    func imagePickerController(
        picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        imagePicker.setBackgroundImage(chosenImage, forState: UIControlState.Normal)
        dismissViewControllerAnimated(true, completion: nil) //5
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func shootPhoto() {
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.cameraCaptureMode = .Photo
            picker.modalPresentationStyle = .FullScreen
            presentViewController(picker,
                animated: true,
                completion: nil)
        }
    }
    
    func photoFromLibrary()
    {
        picker.allowsEditing = false //2
        picker.sourceType = .PhotoLibrary //3
        picker.modalPresentationStyle = .Popover
        presentViewController(picker,
            animated: true,
            completion: nil)//4
        
    }
    

    
    
    // localizacao do motorista
    
    @IBAction func sim(sender:AnyObject){
        
        //definição das classes  do delegado para locationmanager
        //especifica a precisão da localizacao e comeca a receber atualizacoes de localizacao do coreLocation
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
  
        
        
        //obter atualizacao da localizacao
    
        
    }
    //essa funcao é acionada quando novas atualizacoes de localizacao estao disponiveis
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
       
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks,error)-> Void in
            
            if (error != nil) {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks?.count > 0{
                let pm = placemarks![0] as CLPlacemark
                self.displayLocationInfo(pm)
                
            }
            
            else{
                print("Problema com Geocoder")
            }
            
                 })
        
        
        
        var locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
    }
    
    func displayLocationInfo(placemark:CLPlacemark){
        
        
        
            
            // parar de atualizar local para economizar bateria
            locationManager.stopUpdatingLocation()
        
            print(placemark.addressDictionary)
        
            print(placemark.locality)
        
            print(placemark.postalCode)
        
            print(placemark.administrativeArea)
        
            print(placemark.country)
        
     

    
        
    }
    
 

    

  
    // essa funcao e chamado quando receber erros de localizacao
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print("Erro ao atualizar a localizacao" + error.localizedDescription)
    }
    
 

    
    
}
