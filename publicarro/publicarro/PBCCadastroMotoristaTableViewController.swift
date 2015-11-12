
import UIKit
import CoreLocation


class PBCCadastroMotoristaTableViewController: UITableViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate
{
    
    let locationManager = CLLocationManager()

    @IBOutlet weak var celularTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
    @IBOutlet weak var renavamTextField: UITextField!
    
    @IBOutlet weak var imagePicker: UIButton!
    let picker = UIImagePickerController()
    @IBAction func abrirSettings(sender: AnyObject) {
        let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
        if let url = settingsUrl {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        //        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        //        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
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
        else if textField == emailTextField
        {
            if range.location >= 20
            {
                return false
            }
        }
        else
        {
            if range.location >= 6
            {
                return false
            }
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        if textField == celularTextField && celularTextField.text?.isEmpty != true || textField == senhaTextField && senhaTextField.text?.isEmpty != true
        {
            textField.text = ""
        }
    }
    
    @IBAction func imagePickerAction(sender: AnyObject)
    {
        
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        picker.cameraCaptureMode = .Photo
        picker.modalPresentationStyle = .FullScreen
        presentViewController(picker,
            animated: true,
            completion: nil)
    }
    
    //MARK: Delegates
    func imagePickerController(
        picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        
        imagePicker.imageView?.contentMode = .ScaleAspectFit
        imagePicker.imageView!.image = chosenImage //4
        //        view.backgroundColor = UIColor(patternImage: chosenImage) //4
        
        dismissViewControllerAnimated(true, completion: nil) //5
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
}