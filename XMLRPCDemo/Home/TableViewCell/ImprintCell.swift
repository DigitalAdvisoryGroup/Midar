//
//  ImprintCell.swift
//  Midar
//
//  Created by Kuldip Mac on 11/10/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import UIKit

class ImprintCell: UITableViewCell {
    @IBOutlet var lblpublisByMain : UILabel!
     @IBOutlet var lblOnlineHelpSystem : UILabel!
     @IBOutlet var lblTechinacal : UILabel!
    @IBOutlet var lblDevlopBy : UILabel!
    @IBOutlet var lblSourceCode : UILabel!
    @IBOutlet var lblDevlopBy2 : UILabel!
    
    
    @IBOutlet var lblpublisBy : UILabel!
     @IBOutlet var lblpublisBy1 : UILabel!
     @IBOutlet var lblpublisBy2 : UILabel!
     @IBOutlet var lblCall : UILabel!
    @IBOutlet var lblOnlineHelp : UILabel!
    @IBOutlet var lblHelp : UILabel!
 @IBOutlet var lbllegal : UILabel!
       @IBOutlet var lblversion : UILabel!
     @IBOutlet var lbllicensed : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setdata()
        // Initialization code
    }
    func setdata()
{
    lblDevlopBy2.numberOfLines = 0
    lblDevlopBy2.sizeToFit()
    lbllegal.text = "Legal".localized()
    lblpublisByMain.text = "Published byImpre".localized()
    lblOnlineHelpSystem.text = "Online help".localized()
    lblTechinacal.text = "Technical support".localized()
     lblDevlopBy.text = "Developed by".localized()
    lblSourceCode.text = "Source code".localized()
    lbllicensed.text = "This app is licensed subject to the condition of the MPL 2 license".localized()
    lbllicensed.numberOfLines = 0
    lbllicensed.sizeToFit()
    
     let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    lblversion.text = "Version " + "\(appVersion!)"
    lblpublisBy.text = "Published by ".localized()
  
    let str = "Schweizerische Eidgenossenschaft".localized() + "\n"
     let str1 = "Confederation suisse".localized() + "\n"
      let str2 = "Confederazione Svizzera".localized() + "\n"
      let str3 = "Confederaziun sviara".localized()
    lblpublisBy1.text = "\(str)" + "\(str1)" + "\(str2)" + "\(str3)"
    lblpublisBy1.numberOfLines = 0
    lblpublisBy1.sizeToFit()
    
    
//    Bundesamt für Informatik und  Telekommunikation BIT
//    Office féderal de l’informatique et de la télécommunication OFIT
//    Ufficio federale dell’informatica e della telecomunicazione UFIT
//    Federal Office of Information Technology, Systems and Telecommunication FOITT
    lblpublisBy2.text = "Bundesamt für Informatik und Telekommunikation BIT \nOffice féderal de l’informatique et de la télécommunication OFIT \nUfficio federale dell’informatica e della telecomunicazione UFIT \nFederal Office of Information Technology, Systems and Telecommunication FOITT "
    lblpublisBy2.numberOfLines = 0
       lblpublisBy2.sizeToFit()
    lblOnlineHelp.text = "www.midar.swiss/help".localized()
    lblOnlineHelp.numberOfLines = 0
    lblOnlineHelp.sizeToFit()
    lblHelp.text = "Data protection statement & Conditions of Use".localized()
    
    lblHelp.numberOfLines = 0
       lblHelp.sizeToFit()
    lblCall.attributedText = CommonFunction.Instance.stringWithImage(image: UIImage.init(named: "call")!, value: "+41 (0)58 465 88 88")
    
    }
    @IBAction func btnCallTapped(_ sender : UIButton){
        let busPhone = "41584658888"
        if let url = URL(string: "tel://\(busPhone)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
               
            }
    @IBAction func btnDevlopByTapped(_ sender : UIButton){
              if let url = URL(string: "https://github.com/digitaladvisorygroup/midar") {
                                 UIApplication.shared.open(url)
                             }
          }
    @IBAction func btnDigitTapped(_ sender : UIButton){
           if let url = URL(string: "https://www.digitaladvisorygroup.io/") {
                              UIApplication.shared.open(url)
                          }
       }
    @IBAction func btnOnlineHelpTapped(_ sender : UIButton){
        if let url = URL(string: "https://www.midar.swiss/app-netiquette") {
                           UIApplication.shared.open(url)
                       }
    }
    @IBAction func btnOnlineHelpSystemTapped(_ sender : UIButton){
        
        let Strurl = "www.midar.swiss/helpButton".localized()
        //"https://www.midar.swiss/help"
                if let url = URL(string: "\(Strurl)") {
                    UIApplication.shared.open(url)
                }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
