//
//  UnSubScribePostView.swift
//  XMLRPCDemo
//
//  Created by Kuldip Mac on 17/09/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import UIKit

class UnSubScribePostView: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var objtableview: UITableView!
     var DataDict = [NSDictionary]()
    

  //  @IBOutlet weak var objtablview: UITableViewCell!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
        
        return cell
        
    }
}
