
import UIKit

class PBCLoadAnimationViewController: UIViewController
{
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var roda1: UIImageView!
    @IBOutlet weak var roda2: UIImageView!
    @IBOutlet weak var respostaImage: UIImageView!
    @IBOutlet weak var carroView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var respostaView: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        respostaView.hidden = true
        backgroundView.layer.cornerRadius = 10
        animacao()
    }
    
    func sucesso()
    {
        respostaView.hidden = false
        respostaImage.image = UIImage(named:"checkIcon.pdf")
        carroView.hidden = true
    }
    
    func falha()
    {
        respostaView.hidden = false
        respostaImage.image = UIImage(named:"failIcon.pdf")
        carroView.hidden = true
    }
    
    func animacao()
    {
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveLinear, animations:
            {
                if(self.roda1 != nil && self.roda2 != nil)
                {
                    self.roda1.transform = CGAffineTransformRotate(self.roda1.transform, 3.1415926)
                    self.roda2.transform = CGAffineTransformRotate(self.roda2.transform, 3.1415926)
                }
            }, completion: {finished in self.animacao()
        })
    }
}