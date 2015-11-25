
import UIKit

class LogoutAnuncioTableViewCell: UITableViewCell
{
    @IBOutlet weak var imageAnuncio: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        imageAnuncio.layer.borderWidth = 2
        imageAnuncio.layer.borderColor = UIColor.whiteColor().CGColor
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}