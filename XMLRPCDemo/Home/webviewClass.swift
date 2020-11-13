//
//  webviewClass.swift
//  XMLRPCDemo
//
//  Created by Kuldip Mac on 16/09/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import UIKit
import WebKit
import PDFKit
import QuickLook
class webviewClass: UIViewController {
    
   // 1
    var fileURLs = NSURL()//[NSURL]()
   
    var document = PDFDocument()
    var pdfView = PDFView()
       var pdfURL: URL!
    var str = ""
   @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
    let button = UIButton(type: UIButton.ButtonType.custom)
    button.setImage(UIImage(named: "share"), for: .normal)
    button.addTarget(self, action:#selector(callMethod), for: .touchUpInside)
    button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    let barButton = UIBarButtonItem(customView: button)
   //[barButton] self.navigationItem.leftBarButtonItems = [barButton]
        self.navigationItem.rightBarButtonItem = barButton
      //  let fileUrl = URL(string: str)!
         let theURL = URL(string: str)  //use your URL
        let fileNameWithExt = theURL?.lastPathComponent
        self.title = "\(String(describing: fileNameWithExt!))"//somePDF.pdf
               pdfURL = URL(string: str)
        view.addSubview(pdfView)
        
        

//               DispatchQueue.main.asyncAfter(deadline: .now()+3) {
//                   self.dismiss(animated: true, completion: nil)
//               }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        let theURL = URL(string: str)  //use your URL
              let fileNameWithExt = theURL?.lastPathComponent
              self.title = "\(String(describing: fileNameWithExt!))"//somePDF.pdf
                    let pdfURL = URL(string: str)
        if let document = PDFDocument(url: pdfURL!) {
               pdfView.document = document
            self.document = document
        pdfView.autoScales = true
        
           }
    }

    open func dataRepresentation() -> Data?{
        
        guard let data = try? Data(contentsOf: pdfURL),
            let page = PDFDocument(data: data)?.page(at: 0) else
        {
                return nil
        }
        return data
        
    }
    @objc func callMethod() {
       //do stuff here
        print("Share")
        guard let data = self.document.dataRepresentation() else { return }
        let activityController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        if let popoverController = activityController.popoverPresentationController {
                    popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
                    popoverController.sourceView = self.view
                    popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
              popoverController.barButtonItem = self.navigationItem.leftBarButtonItem
                }
        self.present(activityController, animated: true, completion: nil)
    }
    override func viewDidLayoutSubviews() {
           pdfView.frame = view.frame
       }
  
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
