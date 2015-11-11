//
//  PBCLoadAnimationViewController.swift
//  publiCarro
//
//  Created by Lúcio Barros on 10/11/15.
//  Copyright © 2015 tambatech. All rights reserved.
//

import UIKit

class PBCLoadAnimationViewController: UIViewController {

    
    @IBOutlet weak var roda1: UIImageView!
    @IBOutlet weak var roda2: UIImageView!
    @IBOutlet weak var janela3: UIImageView!
    @IBOutlet weak var janela2: UIImageView!
    @IBOutlet weak var janela1: UIImageView!
    
    @IBOutlet weak var carro: UIImageView!
    
    var valor: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        valor = self.view.bounds.width/2
        
        animacao()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animacao(){
        
        UIView.animateWithDuration(0.2, delay: 0, options: [], animations: { () -> Void in
            self.carro.center.x = self.valor
            }) { (result: Bool) -> Void in
                
                
                UIView.animateWithDuration(0.15, delay: 0, options: [], animations: { () -> Void in
                    self.janela1.center.x = self.view.bounds.width/2+30
                    }) { (result: Bool) -> Void in
                        
                        
                        UIView.animateWithDuration(0.15, delay: 0, options: [], animations: { () -> Void in
                            self.janela2.center.x = self.view.bounds.width/2 - 27
                            }) { (result: Bool) -> Void in
                                
                                
                                UIView.animateWithDuration(0.15, delay: 0, options: [], animations: { () -> Void in
                                    self.janela3.center.x = self.view.bounds.width/2 - 75
                                    }) { (result: Bool) -> Void in
                                        
                                        
                                        UIView.animateWithDuration(0.15, delay: 0, options: [], animations: { () -> Void in
                                            self.roda1.center.x = self.view.bounds.width/2 + 80
                                            }) { (result: Bool) -> Void in
                                                
                                                UIView.animateWithDuration(0.15, delay: 0, options: [], animations: { () -> Void in
                                                    self.roda2.center.x = self.view.bounds.width/2 - 78
                                                    }) { (result: Bool) -> Void in
                                                        
                                                        
                                                        UIView.animateWithDuration(0.6, delay: 0, options: [], animations: { () -> Void in
                                                            
                                                            self.carro.center.x = self.view.bounds.height
                                                            self.janela1.center.x = self.view.bounds.height
                                                            self.janela2.center.x = self.view.bounds.height
                                                            self.janela3.center.x = self.view.bounds.height
                                                            self.roda1.center.x = self.view.bounds.height
                                                            self.roda2.center.x = self.view.bounds.height
                                                            
                                                            }) { (result: Bool) -> Void in
                                                                
                                                                
                                                                if (result){
                                                                    
                                                                    print("oi")
                                                                    self.janela1.center.x = -50
                                                                    self.janela2.center.x = -50
                                                                    self.janela3.center.x = -50
                                                                    self.roda1.center.x = -50
                                                                    self.roda2.center.x = -50
                                                                    self.carro.center.x = -50
                                                                    
                                                                    self.valor = self.view.bounds.width/2
                                                                    
                                                                    self.animacao()
                                                                    
                                                                }
                                                                
                                                        }
                                                        
                                                }
                                                
                                        }
                                        
                                }
                                
                        }
                        
                }
        }
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
