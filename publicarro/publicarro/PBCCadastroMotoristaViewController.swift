
import UIKit
import Parse

class PBCCadastroMotoristaViewController: UIViewController
{
    //Instância da classe com os outlets
    private var embeddedCadastroMotoristaViewController : PBCCadastroMotoristaTableViewController!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        navigationController?.navigationBar.hidden = false

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func validandoTextFields() -> Int
    {
        let fields = [
            embeddedCadastroMotoristaViewController.nome,
            embeddedCadastroMotoristaViewController.telefone,
            embeddedCadastroMotoristaViewController.email,
            embeddedCadastroMotoristaViewController.senha,
            embeddedCadastroMotoristaViewController.cpf,
            embeddedCadastroMotoristaViewController.cep,
            embeddedCadastroMotoristaViewController.estado,
            embeddedCadastroMotoristaViewController.cidade,
            embeddedCadastroMotoristaViewController.bairro,
            embeddedCadastroMotoristaViewController.endereco,
            embeddedCadastroMotoristaViewController.renavamCarro
        ]
        
        for (index, element) in fields.enumerate() {
            
            if(element.text == "" || element.text == " " || element.text == "  " || element.text == "   ")
            {
                print("vazio \(index): \(element.text)")
                
                //Existe algum campo vazio
                return 0
            }
            
        }
        
        if(embeddedCadastroMotoristaViewController.senha.text?.characters.count < 6)
        {
            //A senha é muito curta
            return 1
            
        }
        
        //Todos os campos são válidos
        return 2
        
    }
    
    @IBAction func cadastro(sender: AnyObject)
    {
        let sucessTextFields = validandoTextFields()
    
        if(sucessTextFields == 2)
        {
    
            //Objeto da classes _User
            let user = PFUser()
        
            user.username = embeddedCadastroMotoristaViewController.email.text
            user.email = embeddedCadastroMotoristaViewController.email.text
            user.password = embeddedCadastroMotoristaViewController.senha.text
        
        
            //Salvando usuário class (_User)
            user.signUpInBackgroundWithBlock { (sucessUser, errorUser) -> Void in
                
                if(errorUser?.code == 125)
                {
                    print("email invalido")
                }
                
                if(errorUser == nil)
                {
                    print("\n\nUser sucess")
                
                    //Objeto da classe Motorista
                    let motorista = PFObject(className: "Motorista")
                    motorista["user"] = user
                    motorista["nome"] = self.embeddedCadastroMotoristaViewController.nome.text
                    motorista["telefone"] = self.embeddedCadastroMotoristaViewController.telefone.text
                    motorista["cpf"] = self.embeddedCadastroMotoristaViewController.cpf.text
                    motorista["cep"] = self.embeddedCadastroMotoristaViewController.cep.text
                    motorista["cidade"] = self.embeddedCadastroMotoristaViewController.cidade.text
                    motorista["bairro"] = self.embeddedCadastroMotoristaViewController.bairro.text
                    motorista["endereco"] = self.embeddedCadastroMotoristaViewController.endereco.text
                
                
                    //Salvando motorista class (Motorista)
                    motorista.saveInBackgroundWithBlock({ (sucessMotorista, errorMotorista) -> Void in
                
                    
                        if( sucessMotorista == true)
                        {
                            print("\n\nMotorista sucess")
                        
                            //Objeto da classe Carro
                            let carro = PFObject(className: "Carro")
                            carro["motorista"] = motorista
                            carro["renavam"] = self.embeddedCadastroMotoristaViewController.renavamCarro.text
                
                        
                            //Salvando carro class (Carro)
                            carro.saveInBackgroundWithBlock({ (sucessCarro, errorCarro) -> Void in
                            
                                if( sucessCarro == true)
                                {
                                    print("\n\nCarro sucess")
                                }
                                else
                                {
                                    print("\n\nCarro error: \(errorCarro)")
                                }
                            })
                
                        }
                        else
                        {
                            print("\n\nMotorista error: \(errorMotorista)")
                        }
                    })
                }
                else
                {
                    print("\n\nUser error: \(errorUser)")
                }
            }
        }else if(sucessTextFields == 0)
        {
            print("\n\nExiste campos vazios")
        }else if(sucessTextFields == 1)
        {
            print("\n\nSenha muito curta")
        }
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        //segue que acessa a classe dos outlets
        if(segue.identifier == "CadastroMotoristaEmbedSegue")
        {
            embeddedCadastroMotoristaViewController = segue.destinationViewController as? PBCCadastroMotoristaTableViewController
        }
    }

}


/*
let alert = UIAlertController(title: "Alerta", message: "teste", preferredStyle: UIAlertControllerStyle.Alert)

let subview = alert.view.subviews.first! as UIView

let alertContentView = subview.subviews.first! as UIView

let ok = UIAlertAction(title: "ok", style: .Default, handler: { (ok) -> Void in
alert.dismissViewControllerAnimated(true, completion: nil)
})

let attributedMessage = NSAttributedString(string: "Message message message", attributes: [
NSFontAttributeName : UIFont.systemFontOfSize(15, weight: 3),
NSForegroundColorAttributeName : UIColor.whiteColor()
])

let attributedTitle = NSAttributedString(string: "Title of alert", attributes: [
NSFontAttributeName : UIFont.systemFontOfSize(20, weight: 5),
NSForegroundColorAttributeName : UIColor.whiteColor()
])

alert.setValue(attributedMessage, forKey: "attributedMessage")
alert.setValue(attributedTitle, forKey: "attributedTitle")

alertContentView.backgroundColor = UIColor(red:0.11, green:0.15, blue:0.18, alpha:1.0)
alertContentView.layer.cornerRadius = 5;

alert.view.tintColor = UIColor.whiteColor();

alert.addAction(ok)

self.presentViewController(alert, animated: true, completion: nil)
*/



/*
//Define a color
let color = UIColor.redColor()

//Make a controller
let alertVC = UIAlertController(title: "Dont care what goes here, since we're about to change below", message: "", preferredStyle: UIAlertControllerStyle.Alert)

//Title String
var hogan = NSMutableAttributedString(string: "Presenting the great... Hulk Hogan!")

//Make the attributes, like size and color
hogan.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(40.0), range: NSMakeRange(24, 11))

hogan.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(0, NSString(string: hogan.string).length))

//Set the new title
//Use "attributedMessage" for the message
alertVC.setValue(hogan, forKey: "attributedTitle")

//This will change the button color
alertVC.view.tintColor = UIColor.orangeColor()

//Make the button
let button:UIAlertAction  = UIAlertAction(title: "Label text", style: UIAlertActionStyle.Default, handler: { (e:UIAlertAction!) -> Void in
print("\(e)")
})

//You can add images to the button
let accessoryImage:UIImage = UIImage(named: "pessoaIcon")!
button.setValue(accessoryImage, forKey:"image")

//Add the button to the alert
alertVC.addAction(button)

//Finally present it
self.presentViewController(alertVC, animated: true, completion:  nil)
*/
