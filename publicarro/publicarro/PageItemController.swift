
import UIKit

class PageItemController: UIViewController
{
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var label: UILabel!
    
    var itemIndex: Int?
    var imageName: String!
    var labelName: String!
    var textTutorial: String!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        contentImageView!.image = UIImage(named: imageName!)
        label.text = labelName
        textView.text = textTutorial
    }
}