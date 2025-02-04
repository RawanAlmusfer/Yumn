//
//  BloodDonQuestionsViewController.swift
//  Yumn
//
//  Created by Nouf AlShalhoub on 19/03/2022.
//

import UIKit

class BloodDonationQuestionsViewController: UIViewController {
    
        
    @IBOutlet weak var q1Btn: UIButton!
    
    @IBOutlet weak var q1Radio: UIButton!
    
    @IBOutlet weak var q2Btn: UIButton!
    
    @IBOutlet weak var blackBlurredView: UIView!
    
    @IBOutlet weak var q2Radio: UIButton!
    
    @IBOutlet weak var q3btn: UIButton!
    
    @IBOutlet weak var q3Radio: UIButton!
    
    @IBOutlet weak var q4Btn: UIButton!
    
    @IBOutlet weak var q4Radio: UIButton!
    
    @IBOutlet weak var q5Btn: UIButton!
    
    @IBOutlet weak var q5Radio: UIButton!
    
    @IBOutlet weak var q6Btn: UIButton!
    
    @IBOutlet weak var q6Radio: UIButton!
    
    @IBOutlet weak var q7Btn: UIButton!
    
    @IBOutlet weak var q7Radio: UIButton!
    
    @IBOutlet weak var contBtn: UIButton!
        
    @IBOutlet weak var popupView: UIView!
    
    @IBOutlet weak var popupTitle: UILabel!
    
    @IBOutlet weak var popupMsg: UILabel!
    
    @IBOutlet weak var okBtn: UIButton!
    
    var questions = [false, false,false, false, false, false, false]
    
    override func viewDidLoad() {
                
        
        contBtn.layer.cornerRadius = 25
        okBtn.layer.cornerRadius = 20
        popupView.layer.cornerRadius = 30
        q1Btn.contentHorizontalAlignment = .right
        q2Btn.contentHorizontalAlignment = .right
        q3btn.contentHorizontalAlignment = .right
        q4Btn.contentHorizontalAlignment = .right
        q5Btn.contentHorizontalAlignment = .right
        q6Btn.contentHorizontalAlignment = .right
        q6Btn.contentHorizontalAlignment = .right
        q7Btn.contentHorizontalAlignment = .right
                
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        super.viewDidLoad()
        
        q1Radio.setImage(UIImage(named: "emptyRadio"), for: .normal)
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onPressedBAckBtn(_ sender: Any) {
        
        
        
        self.navigationController?.popViewController(animated:true)
        
        
        
    }
    
    /*
     override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
     
     let isValidDonor = questions[0]&&questions[1]&&questions[2]&&questions[3]&&questions[4]&&questions[5]&&questions[6]
     
     if (!isValidDonor){
     
     popupTitle.text = "مقدرين حبك للمساعدة"
     popupMsg.text = "للأسف أنت غير مؤهل للتبرع بالدم"
     popupView.isHidden = false
     blackBlurredView.isHidden = false
     return false
     }
     
     else {
     return true
     }
     
     
     
     
     
     
     }*/
    
    override func viewWillAppear(_ animated: Bool) {
        //        self.navigationController?.navigationBar.tintColor = UIColor.white
        super.viewWillAppear(animated)
        
        let nav = self.navigationController?.navigationBar
        guard let customFont = UIFont(name: "Tajawal-Bold", size: 25) else {
            fatalError("""
                Failed to load the "Tajawal" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        nav?.tintColor = UIColor.white
        nav?.barTintColor = UIColor.init(named: "mainLight")
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: customFont]
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
//        var nav = self.navigationController?.navigationBar
//        guard let customFont = UIFont(name: "Tajawal-Bold", size: 25) else {
//            fatalError("""
//                Failed to load the "Tajawal" font.
//                Make sure the font file is included in the project and the font name is spelled correctly.
//                """
//            )
//        }
//        nav?.tintColor = UIColor.init(named: "mainLight")
//        nav?.barTintColor = UIColor.init(named: "mainLight")
//        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(named: "mainLight")!, NSAttributedString.Key.font: customFont]
    }
    
    
    
    @IBAction func onPressedCont(_ sender: Any) {
        
        print("heeree")
        
        let isValidDonor = questions[0]&&questions[1]&&questions[2]&&questions[3]&&questions[4]&&questions[5]&&questions[6]
        
        if (!isValidDonor){
            
            popupTitle.text = "مقدرين حبك للمساعدة"
            //        popupMsg.text = "للأسف أنت غير مؤهل للتبرع بالدم"
            blackBlurredView.superview?.bringSubviewToFront(blackBlurredView)
            popupView.superview?.bringSubviewToFront(popupView)

            popupView.isHidden = false
            blackBlurredView.isHidden = false
            
        }
        
        else{
            print("heeree222")
            //Go to next page
            performSegue(withIdentifier: "goToAppointments", sender: nil)
            
        }
    }
    
    
    
    @IBAction func onPressedQ1Radio(_ sender: Any) {
        
        questions[0] = !questions[0]
        print (questions)
        
        if (q1Radio.currentImage == UIImage(named: "fullRadio")){
            
            
            q1Radio.setImage(UIImage(named: "emptyRadio"), for: .normal)
            
        }
        else {
            
            q1Radio.setImage(UIImage(named: "fullRadio"), for: .normal)
            
            
        }
    }
    
    
    @IBAction func onPressedQ2(_ sender: Any) {
        
        questions[1] = !questions[1]
        print (questions)
        
        if (q2Radio.currentImage == UIImage(named: "fullRadio")){
            
            
            q2Radio.setImage(UIImage(named: "emptyRadio"), for: .normal)
            
        }
        else {
            
            q2Radio.setImage(UIImage(named: "fullRadio"), for: .normal)
            
            
        }
        
        
    }
    
    
    
    
    
    @IBAction func onPressedQ3(_ sender: Any) {
        
        questions[2] = !questions[2]
        print (questions)
        
        if (q3Radio.currentImage == UIImage(named: "fullRadio")){
            
            
            q3Radio.setImage(UIImage(named: "emptyRadio"), for: .normal)
            
        }
        else {
            
            q3Radio.setImage(UIImage(named: "fullRadio"), for: .normal)
            
            
        }
    }
    
    
    
    
    
    
    @IBAction func onPressedQ4(_ sender: Any) {
        questions[3] = !questions[3]
        print (questions)
        
        if (q4Radio.currentImage == UIImage(named: "fullRadio")){
            
            
            q4Radio.setImage(UIImage(named: "emptyRadio"), for: .normal)
            
        }
        else {
            
            q4Radio.setImage(UIImage(named: "fullRadio"), for: .normal)
            
            
        }
    }

    
    
    @IBAction func onPressedQ5(_ sender: Any) {
        
        questions[4] = !questions[4]
        print (questions)
        
        if (q5Radio.currentImage == UIImage(named: "fullRadio")){
            
            
            q5Radio.setImage(UIImage(named: "emptyRadio"), for: .normal)
            
        }
        else {
            
            q5Radio.setImage(UIImage(named: "fullRadio"), for: .normal)
            
            
        }
    }
    
    
    
    @IBAction func onPressedRadio6(_ sender: Any) {
        
        
        questions[5] = !questions[5]
        print (questions)
        
        if (q6Radio.currentImage == UIImage(named: "fullRadio")){
            
            
            q6Radio.setImage(UIImage(named: "emptyRadio"), for: .normal)
            
        }
        else {
            
            q6Radio.setImage(UIImage(named: "fullRadio"), for: .normal)
            
            
        }
    }
    
    
    
    @IBAction func onPressedRadio7(_ sender: Any) {
        
        questions[6] = !questions[6]
        print (questions)
        
        if (q7Radio.currentImage == UIImage(named: "fullRadio")){
            
            
            q7Radio.setImage(UIImage(named: "emptyRadio"), for: .normal)
            
        }
        else {
            
            q7Radio.setImage(UIImage(named: "fullRadio"), for: .normal)
            
            
        }
    }
    
    
    
    
    @IBAction func onPressedOk(_ sender: Any) {
        
        blackBlurredView.isHidden = true
        popupView.isHidden = true
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    // override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
}



