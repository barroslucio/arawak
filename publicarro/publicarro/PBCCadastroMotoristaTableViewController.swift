
import UIKit

class PBCCadastroMotoristaTableViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
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
        
        
    }
    
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
