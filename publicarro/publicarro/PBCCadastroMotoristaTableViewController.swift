
import UIKit
import CoreLocation


class PBCCadastroMotoristaTableViewController: UITableViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate
{
    //MARK: Properties
    
    // LOCATIONS
    let locationManager = CLLocationManager()
    static var motoristaLocation = CLLocation()
    static var detalhesLocation = CLPlacemark?()
   
    // TEXTFIELDS
    @IBOutlet weak var celularTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
    @IBOutlet weak var renavamTextField: UITextField!
    @IBOutlet weak var switchControl: UISwitch!
    
    
    // IMAGE
    @IBOutlet weak var imagePicker: UIButton!
    let picker = UIImagePickerController()
    static var chosenImage : UIImage?

    //MARK: Init properties
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        celularTextField.delegate = self
        emailTextField.delegate = self
        senhaTextField.delegate = self
        renavamTextField.delegate = self
        
        picker.delegate = self

        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: TableView
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 2
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    //MARK:  TextField
    
    //Acompanha as alterções na Text Field
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        if textField == renavamTextField
        {
            if range.location >= 9
            {
                textField.resignFirstResponder()
                return false
            }
        }
        else if textField == celularTextField
        {
            if textField.text?.characters.count <= 14
            {
                if range.location == 2
                {
                    textField.text = "("+textField.text!+") 9"
                }
                else if range.location == 10
                {
                    textField.text = textField.text!+"-"
                }
            }
            else
            {
                textField.resignFirstResponder()
                return false;
            }
        }
        else if textField == senhaTextField
        {
            if range.location >= 6
            {
                return false
            }
        }
        return true
    }
    
    //Ativa a ação de tocar na Text Field
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    //Recebe a ação de toque na Text Field
    func textFieldDidBeginEditing(textField: UITextField)
    {
        if textField == celularTextField && celularTextField.text?.isEmpty != true || textField == senhaTextField && senhaTextField.text?.isEmpty != true
        {
            textField.text = ""
        }
    }
    
    //MARK:  ImagePicker
    
    //Action do botão da câmera
    @IBAction func imagePickerAction(sender: AnyObject)
    {
        //Cria um alerta do estilo Action Sheet
        let actionSheetCamera = UIAlertController(title: "", message: "Adicione a foto da sua habilitação", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        //Opção de tirar foto
        let camera = UIAlertAction(title: "Tirar foto", style: .Default, handler: { (camera) -> Void in
            self.shootPhoto()
        })
        
        //Opção de selecionar foto
        let library = UIAlertAction(title: "Biblioteca de fotos", style: .Default, handler: { (camera) -> Void in
            self.photoFromLibrary()
        })
        
        //Opção de mostrar foto
        let showPhoto = UIAlertAction(title: "Visualizar", style: .Default, handler: { (camera) -> Void in
            
            self.performSegueWithIdentifier("segueImagemCNH", sender: nil)
        })
        
        //Opção de cancelar
        let cancel = UIAlertAction(title: "Cancelar", style: .Cancel, handler: { (cancel) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        
        //Somente adiciona a opção de mostrar foto se já existir uma foto selecionada
        if (imagePicker.imageView?.backgroundColor != PBCCadastroMotoristaTableViewController.chosenImage)
        {
            //Adicionar a opção de mostrar foto
            actionSheetCamera.addAction(showPhoto)
        }
        
        //Adiciona opções ao Action Sheet
        actionSheetCamera.addAction(camera)
        actionSheetCamera.addAction(library)
        actionSheetCamera.addAction(cancel)
        
        self.presentViewController(actionSheetCamera, animated: true, completion: nil)
        
    }
    
    //Recebe a imagem fotografada ou selecionada
    func imagePickerController(
        picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        //Adiciona a imagem a variável static
        PBCCadastroMotoristaTableViewController.chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        //Seta a imagem no backgroud do botão.
        imagePicker.setBackgroundImage(PBCCadastroMotoristaTableViewController.chosenImage, forState: UIControlState.Normal)
        
        //Remove ação da câmera
        dismissViewControllerAnimated(true, completion: nil) //5
    }
    
    //Esconde a câmera
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //Acessa a câmera do iPhone
    func shootPhoto()
    {
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
    
    //Acessa a biblioteca de fotos do iPhone
    func photoFromLibrary()
    {
        picker.allowsEditing = false //2
        picker.sourceType = .PhotoLibrary //3
        picker.modalPresentationStyle = .Popover
        presentViewController(picker,
            animated: true,
            completion: nil)//4
    }
    
    //MARK: - Location
    
    @IBAction func sim(sender:AnyObject)
    {
        locationManager.startUpdatingLocation()
    }
    
    
    //Recebe novas atualizacoes de localizacões disponíveis
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        locationManager.stopUpdatingLocation()
        
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks,error)-> Void in
            
            if (error != nil) {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks?.count > 0
            {
                PBCCadastroMotoristaTableViewController.detalhesLocation = placemarks!.last! as CLPlacemark
                
                PBCCadastroMotoristaTableViewController.printLocationMotorista(PBCCadastroMotoristaTableViewController.detalhesLocation!)

            } else
            {
                print("Problema com Geocoder")
            }
        })
    }
    
    
    //Recebe erros de localizacao
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print("Erro ao atualizar a localizacao" + error.localizedDescription)
    }
    

    //Imprime a localização do motorista.
    static func printLocationMotorista(placemark:CLPlacemark)
    {
        print("\n")
        print(placemark.location?.coordinate.latitude)
        print(placemark.location?.coordinate.longitude)
        print(placemark.country)
        print(placemark.administrativeArea)
        print(placemark.locality)
        print(placemark.postalCode)
        print(placemark.subLocality)
        print(placemark.thoroughfare)
        
    }
    
    
    //Abre os Ajustes para ativar a localização.
    @IBAction func abrirSettings(sender: AnyObject) {
        let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
        if let url = settingsUrl {
            UIApplication.sharedApplication().openURL(url)
        }
    }

    ////MARK: Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        
        if(segue.identifier == "segueImagemCNH")
        {
            print("Visualizando imagem")
        }
        
    }

    
}
