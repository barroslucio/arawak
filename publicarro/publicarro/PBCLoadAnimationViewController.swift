//
//  PBCLoadAnimationViewController.swift
//  publiCarro
//
//  Created by Lúcio Barros on 10/11/15.
//  Copyright © 2015 tambatech. All rights reserved.
//

import UIKit

class PBCLoadAnimationViewController: UIViewController {

    
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet weak var roda1: UIImageView!
    @IBOutlet weak var roda2: UIImageView!
    @IBOutlet weak var janela3: UIImageView!
    @IBOutlet weak var janela2: UIImageView!
    @IBOutlet weak var janela1: UIImageView!
    
    @IBOutlet var respostaImage: UIImageView!
    @IBOutlet var carroView: UIView!
    @IBOutlet weak var carro: UIImageView!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var respostaView: UIView!
    
    var valor: CGFloat?
    var stop: Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        respostaView.hidden = true
        if (backgroundView != nil){
        backgroundView.layer.cornerRadius = 10
        }
        animacao()
        
        
        // Do any additional setup after loading the view.
    }
    
    func sucesso(){
        self.respostaView.hidden = false
        self.respostaImage.image = UIImage(named:"checkIcon.pdf")
        
        
        if (self.carroView != nil){
            self.carroView.hidden = true
        }
        
    }
    
    func falha(){
        
        self.respostaView.hidden = false
        self.respostaImage.image = UIImage(named:"failIcon.pdf")
        
        
        if (self.carroView != nil){
            self.carroView.hidden = true
        }
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    
    func animacao(){
        
     
        UIView.animateWithDuration(0.4,
            delay: 0.0,
            options: .CurveLinear,
            animations: {
                if(self.roda1 != nil && self.roda2 != nil){
                self.roda1.transform = CGAffineTransformRotate(self.roda1.transform, 3.1415926)
                self.roda2.transform = CGAffineTransformRotate(self.roda2.transform, 3.1415926)
                }
            },
            completion: {finished in self.animacao()})
        

        
       
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
