
import UIKit

class PBCCadastroPopUpViewController: UIViewController
{
    @IBOutlet weak var btClose: UIButton!
    @IBOutlet weak var viewPopUp: UIView!
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        viewPopUp.layer.cornerRadius = 10
        btClose.layer.cornerRadius = 25
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func button(sender: AnyObject)
    {
        UIView.transitionWithView(view, duration: 0.4, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {self.view.hidden = true}, completion: nil)
    }
    
  
    
    override func viewDidDisappear(animated: Bool)
    {
        view.removeFromSuperview()
    }
}