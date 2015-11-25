//
//  AnuncioDisponivelTableViewCell.swift
//  publiCarro
//
//  Created by EDILBERTO DA SILVA RAMOS JUNIOR on 24/11/15.
//  Copyright © 2015 tambatech. All rights reserved.
//

import UIKit

class AnuncioDisponivelTableViewCell: UITableViewCell
{
    @IBOutlet weak var oneLabel: UILabel!
    @IBOutlet weak var twoLabel: UILabel!
    @IBOutlet weak var threeLabel: UILabel!
    @IBOutlet weak var fourLabel: UILabel!
    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
