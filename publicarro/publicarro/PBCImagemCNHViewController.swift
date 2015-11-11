//
//  PBCImagemCNHViewController.swift
//  publiCarro
//
//  Created by EDILBERTO DA SILVA RAMOS JUNIOR on 11/11/15.
//  Copyright © 2015 tambatech. All rights reserved.
//

import UIKit

class PBCImagemCNHViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var chosenImage:UIImage?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.scrollView.minimumZoomScale = 1.0;
        self.scrollView.maximumZoomScale = 6.0;
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
    {
        self.imageView.image = PBCCadastroMotoristaTableViewController.chosenImage
        return self.imageView
    }
}
