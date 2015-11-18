
import UIKit
import Parse

class PBCOrcamentoViewController: UIViewController, UIAlertViewDelegate
{
    @IBOutlet weak var bottonConstraint: NSLayoutConstraint!
    @IBOutlet weak var orcamentoButton: UIButton!
    
    //variavel que vai receber a view de load
    var controller: PBCLoadAnimationViewController!

    private var embeddedViewController: PBCOrcamentoTableViewController!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationController?.navigationBar.hidden = false
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func validarCampos() -> Bool
    {
        if embeddedViewController.nomeTextField.text?.isEmpty == true || embeddedViewController.emailTextField.text?.isEmpty == true || embeddedViewController.celularTextField.text?.isEmpty == true || embeddedViewController.celularTextField.text?.characters.count <= 14
        {
            var mensagem = String()
            if embeddedViewController.nomeTextField.text?.isEmpty == true
            {
                mensagem = "Informe seu nome."
            }
            else if embeddedViewController.celularTextField.text?.isEmpty == true
            {
                mensagem = "Informe seu celular."
            }
            else if embeddedViewController.celularTextField.text?.characters.count <= 14
            {
                mensagem = "Celular inválido."
            }
            else
            {
                mensagem = "Informe seu email."
            }
            //se os campos estiverem validados, carrega a view de load
            controller = storyboard!.instantiateViewControllerWithIdentifier("LoadView") as! PBCLoadAnimationViewController
            addChildViewController(controller!)
            UIView.transitionWithView(view, duration: 0.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                
                self.view.addSubview(self.controller!.view)
                self.controller.infoLabel.text = "Cadastrando..."
                
                }, completion: nil)
            
            self.controller.falha()
            self.controller.infoLabel.text = mensagem
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0*Double(NSEC_PER_SEC))),dispatch_get_main_queue(),{
                self.controller.view.removeFromSuperview()
            })
            return false
        }
        return true
    }
    
    @IBAction func orcamentoTapped(sender: AnyObject)
    {
        if validarCampos() == true
        {
            //se os campos estiverem validados, carrega a view de load
            controller = storyboard!.instantiateViewControllerWithIdentifier("LoadView") as! PBCLoadAnimationViewController
            addChildViewController(controller!)
            UIView.transitionWithView(view, duration: 0.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                
                self.view.addSubview(self.controller!.view)
                self.controller.infoLabel.text = "Cadastrando..."
                
                }, completion: nil)
            
            
            let orcamento = PFObject(className: "Orcamento")
            orcamento["nome"] = self.embeddedViewController.nomeTextField.text
            orcamento["telefone"] = self.embeddedViewController.celularTextField.text
            orcamento["email"] = self.embeddedViewController.emailTextField.text
            orcamento["carros"] = Int(self.embeddedViewController.qtdCarros.text!)
            orcamento["meses"] = Int(self.embeddedViewController.qtdMeses.text!)
            
            orcamento.saveInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil
                {
                    print("successful")
                    
                    self.controller.sucesso()
                    self.controller.infoLabel.text = "Bem sucedido"
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(3.0*Double(NSEC_PER_SEC))),dispatch_get_main_queue(),
                        {
                            self.controller!.view.removeFromSuperview()
                    })

                } else
                {
                    print("error:\(error)")

                    self.controller.infoLabel.text = "Ocorreu um erro"
                    
                    self.controller.falha()
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0*Double(NSEC_PER_SEC))),dispatch_get_main_queue(),
                        {
                            //caso tenha dado erro remove a tela de load antes de exibir o erro.
                            self.controller!.view.removeFromSuperview()
                            
                    })

                }
                
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "OrcamentoEmbedSegue"
        {
            embeddedViewController = segue.destinationViewController as? PBCOrcamentoTableViewController
        }
    }
}