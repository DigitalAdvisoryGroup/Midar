//
//  ImprintVC.swift
//  Midar
//
//  Created by Kuldip Mac on 11/10/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import UIKit

class ImprintVC: UIViewController {

    @IBOutlet weak var tblview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "imprint".localized()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
            navigationController?.setNavigationBarHidden(false, animated: true)
           super.viewWillAppear(true)
           
          
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
extension ImprintVC: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImprintCell") as! ImprintCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
    }

}
