//
//  HomeViewController.swift
//  XMLRPCDemo
//
//  Created by Kuldip Mac on 27/08/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import UIKit
import KRPullLoader

import AudioToolbox
enum PlaceholderType {
    case noContent
    case noFilterContent
    case none
    case error
}
class HomeViewController: UIViewController {
    var loadMoreView: KRPullLoadView?
       
   /* private var placeholderType: PlaceholderType = .none {
        didSet {
            let allows = placeholderType == .none
            tblSocialPost.bounces = allows
            tblSocialPost.allowsSelection = allows
            
            if placeholderType == .none {
                addRefreshView(#selector(refresh))
            } else {
                removeRefreshView()
            }
        }
    }*/
    
    @IBOutlet var tblSocialPost : UITableView!
    @IBOutlet var txtSearch : UITextField!
    var Listingarray = [Any]()
    var Listingarray1 = (Any).self
    var DataDict = [NSDictionary]()
    var DataDictFilter = [NSDictionary]()
    var refreshControl:UIRefreshControl = UIRefreshControl()
    var DataDictProfie = [NSDictionary]()
    var isSearch = false
    @IBOutlet var imgUser : UIImageView!
     var isLoadMore : Bool = true
     var currentPage : Int = 1
    var categoryId = 0
    var PostId = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        navigationController?.setNavigationBarHidden(true, animated: true)
        pullToRefresh()
    
        
        self.tblSocialPost.register(UINib(nibName: "SocialPostTableViewCell", bundle: nil), forCellReuseIdentifier: "SocialPostTableViewCell")
        

        
        
        
        txtSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        //  let preArrowImage : UIImageView // also give it frame
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        imgUser.isUserInteractionEnabled = true
        imgUser.addGestureRecognizer(singleTap)
        SetGestureTableview()
        SetPushNotificationRoot()
        
          GetPostData()
        
        // Do any additional setup after loading the view.
    }
    
    func getDataAPi()  {
        let uid = UserDefaults.standard.object(forKey: "uid")
        let DevcieToken =  UserDefaults.standard.object(forKey: "DevcieToken")
        var parther_ID = 0
        var params = [Any]()
        parther_ID = UserDefaults.standard.object(forKey: "parther_ID") as! Int
                   params = ["\(WebAPI.DBName)",uid!, "\(WebAPI.Password)","res.partner","get_partner_profile_data",[[parther_ID]]] as [Any]
                   
       
        
        let strUrl = "\(WebAPI.BaseURL)" + "object"
        // var params = ["\(WebAPI.DBName)","admin", "admin"] as [Any]
        
        
        KPNetworkManager.shared.webserviceCall(strUrl: "\(strUrl)", methodName: "execute_kw", params: params, isShowLoader: true, Isview: self.view, success: { (ObejcData) in
            
            
            if let j = ObejcData as? [String:Any]{
                if let data = j["data"]{
                    //print("data:-",data)
                   // self.DataDict = data as! [NSDictionary]
                    //print("DataDict:-",self.DataDict)
                    DispatchQueue.main.async {
                       let dataDict1 = data as! [NSDictionary]
                        UserDefaults.standard.set(data, forKey: "ProfileData")
                        UserDefaults.standard.synchronize()
                        
                        self.DataDictProfie = data as! [NSDictionary]//UserDefaults.standard.object(forKey: "ProfileData") as! [NSDictionary]
                        let object1 = self.DataDictProfie[0]
                              // let fileUrl = URL(string: "\(object1["image_1920"] ?? "")")
                               self.imgUser.kf.setImage(with: URL.init(string: "\(object1["image_1920"] ?? "")"))

//
                               
                        //

                    }
                    
                }
            }
          
            
            
            
        }) { (error) in
            print("error:-",error)
        }
        
        
    }
    func SetPushNotificationRoot()  {
        if categoryId == 0{
                    //Nothing
        //            let homevc = UIStoryboard(name: StoryboardId.HOME, bundle: nil).instantiateViewController(withIdentifier: "CommentVIewController") as! CommentVIewController
        //            // homevc.objectDict =  object
        //             homevc.idVale = 22
        //             homevc.categoryId = 133
        //            // self.show(homevc, sender: nil)
        //             self.navigationController?.pushViewController(homevc, animated: true)
                }
                else
                {
                    // CommentView
// DispatchQueue.main.async {
                        //self.showAlertWithCompletion(pTitle: "", pStrMessage: "HomeView", completionBlock: nil)
                        UserDefaults.standard.removeObject(forKey: "CommentId")
                               UserDefaults.standard.removeObject(forKey: "PostId")
                               UserDefaults.standard.synchronize()
                        let topViewController = UIApplication.topViewController()
                        let storyboard = UIStoryboard(name: StoryboardId.HOME, bundle: nil)
                                           let vc = storyboard.instantiateViewController(withIdentifier: "CommentVIewController") as! CommentVIewController
                                           vc.idVale = self.PostId
                                           vc.categoryId = self.categoryId
                                          // self.show(vc, sender: nil)
                                          // self.present(vc, animated: true, completion: nil)
                                           // self.navigationController?.pushViewController(vc, animated: true)
                                           topViewController?.navigationController?.pushViewController(vc, animated: true)
                        

                  // */ }
                    
                   
                    
                  /*   let homevc = UIStoryboard(name: StoryboardId.HOME, bundle: nil).instantiateViewController(withIdentifier: "CommentVIewController") as! CommentVIewController
                                             // homevc.objectDict =  object
                                   homevc.idVale = self.PostId
                                              homevc.categoryId = self.categoryId
                                             // self.show(homevc, sender: nil)
                                              self.navigationController?.pushViewController(homevc, animated: true) */
                   
                }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    func SetGestureTableview()  {
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        imgUser.isUserInteractionEnabled = true
        imgUser.addGestureRecognizer(singleTap)
        
        
        
        
    }
    
    
    @objc func tapDetected() {
        let homevc = UIStoryboard(name: StoryboardId.HOME, bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        //homevc.objectDict =  object
        homevc.ProfileFlag = ""
        self.navigationController?.pushViewController(homevc, animated: true)
    }
    func pullToRefresh(){
        self.refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        self.tblSocialPost.refreshControl = self.refreshControl
    }
    @objc func refresh(){
        self.currentPage = 1
               self.isLoadMore = true
        self.refreshControl.endRefreshing()
        
        GetPostData()
    }
    override func viewWillAppear(_ animated: Bool) {
         navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillAppear(true)
        //DataDict.removeAll()
       
        
//       self.currentPage = 1
//        self .isLoadMore = true
       getDataAPi()
             
            
    }
    @IBAction func InfoAction(_ sender: Any)
    {
        let homevc = UIStoryboard(name: StoryboardId.HOME, bundle: nil).instantiateViewController(withIdentifier: "ImprintVC") as! ImprintVC
        //homevc.objectDict =  object
        self.navigationController?.pushViewController(homevc, animated: true)
       
//        if let url = URL(string: "https://midar.odoo.com/app-impressum") {
//            UIApplication.shared.open(url)
//        }
    }
    
    @IBAction func ActionProfile(_ sender: Any)
    {
        
        let homevc = UIStoryboard(name: StoryboardId.HOME, bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        //homevc.objectDict =  object
         homevc.ProfileFlag = ""
        self.navigationController?.pushViewController(homevc, animated: true)
    }
    
    @objc func textFieldDidChange(textField : UITextField){
        if textField.text == "" {
            
            isSearch = false
            tblSocialPost.reloadData()
            print("Backspace has been pressed")
        }else{
            isSearch = true
            DataDictFilter.removeAll()
            for i in 0..<DataDict.count {
                let searchString: String = self.txtSearch.text!
                
                let comment = ((DataDict[i] as! NSDictionary).value(forKey: "comments") as! NSArray)
                for j in 0..<comment.count
                {
                    let dict = comment.object(at: j) as? NSDictionary
                    
                    
//                    if {
//
//                    }
                    
                    if ((((DataDict[i] ).value(forKey: "message") as! String).uppercased() as NSString).range(of: searchString.uppercased()).location) != NSNotFound || ((((DataDict[i] as! NSDictionary).value(forKey: "name") as! String).uppercased() as NSString).range(of: searchString.uppercased()).location) != NSNotFound || (((dict?.value(forKey: "author_name") as! String).uppercased() as NSString).range(of: searchString.uppercased()).location) != NSNotFound
                     {
                        DataDictFilter.append(self.DataDict[i])
                    }
                }
                
           
                
            }
            print("DataDictFilter:-",DataDictFilter)
            self.tblSocialPost.reloadData()
        }
        
        
    }
    
    
    func GetPostData()
    {
        let uid = UserDefaults.standard.object(forKey: "uid") as! Int
        let parther_ID = UserDefaults.standard.object(forKey: "parther_ID") as! Int
        //  UserDefaults.standard.set(ObejcData, forKey: "")
       // ["\(WebAPI.DBName)",uid, "\(WebAPI.Password)","social.post","get_post_api",[[],parther_ID,5,DataDict.count+5]]
        let params = ["\(WebAPI.DBName)",uid, "\(WebAPI.Password)","social.post","get_post_api",[[],parther_ID,3,0]] as [Any]
        
        print("paramsGetPostData:-",params)
        let url = "\(WebAPI.BaseURL)" + "object"
        KPNetworkManager.shared.webserviceCall(strUrl: "\(url)", methodName: "execute_kw", params: params, isShowLoader: true, Isview: self.view, success: { (ObejcData) in
            
            if self.currentPage == 1{
                self.isLoadMore = true
                
                if let j = ObejcData as? [String:Any]{
                    if let data = j["data"]{
                        //print("data:-",data)
                        self.DataDict.removeAll()
                        self.DataDict = data as! [NSDictionary]
                        //print("DataDict:-",self.DataDict)
                        DispatchQueue.main.async {
                            self.tblSocialPost.reloadData()
                        }
                        
                    }
                }
            }else{
                
                
                if let j = ObejcData as? [String:Any]{
                    if let data = j["data"] as? NSArray
                    {
                        //print("data:-",data)
//                        for i in 0..<(data as AnyObject).count
//                                   {
//                                   // let dict = data.obj//[i] as? NSDictionary
//                                     self.DataDict.append(i)
//                        }
                        for i in data{
                          //  self.arrbuy.append(i)
                            self.DataDict.append(i as! NSDictionary)
                        }
                       // self.DataDict = data as! [NSDictionary]
                        //print("DataDict:-",self.DataDict)
                        DispatchQueue.main.async {
                            self.tblSocialPost.reloadData()
                        }
                        
                    }
                }
                
                
            }
            
            
            
            
        }) { (error) in
            print("error:-",error)
            
        }
    }

        func GetPostDataLoadMore() {
            let uid = UserDefaults.standard.object(forKey: "uid") as! Int
            let parther_ID = UserDefaults.standard.object(forKey: "parther_ID") as! Int
            //  UserDefaults.standard.set(ObejcData, forKey: "")
            
            
            
            let params = ["\(WebAPI.DBName)",uid, "\(WebAPI.Password)","social.post","get_post_api",[[],parther_ID,3,DataDict.count+3]] as [Any]
            
            print("paramsGetPostDataMore:-",params)
            let url = "\(WebAPI.BaseURL)" + "object"
            KPNetworkManager.shared.webserviceCallWithoutProgessbar(strUrl: "\(url)", methodName: "execute_kw", params: params, isShowLoader: true, Isview: self.view, success: { (ObejcData) in
                
                if self.currentPage == 1{
                    self.isLoadMore = true
                    
                    if let j = ObejcData as? [String:Any]{
                        if let data = j["data"]{
                            //print("data:-",data)
                           // self.DataDict = data as! [NSDictionary]
                            //print("DataDict:-",self.DataDict)
                            DispatchQueue.main.async {
                                self.tblSocialPost.reloadData()
                            }
                            
                        }
                    }
                }else{
                    
                    
                    if let j = ObejcData as? [String:Any]{
                        if let data = j["data"] as? NSArray
                        {
                            //print("data:-",data)
    //                        for i in 0..<(data as AnyObject).count
    //                                   {
    //                                   // let dict = data.obj//[i] as? NSDictionary
    //                                     self.DataDict.append(i)
    //                        }
                            for i in data{
                              //  self.arrbuy.append(i)
                                self.DataDict.append(i as! NSDictionary)
                            }
                            if data.count == 0 {
                                 self.isLoadMore = false
                            }
                            DispatchQueue.main.async {
                                self.tblSocialPost.reloadData()
                            }
                            
                        }
                    }
                    
                    
                }
                
                
                
                
            }) { (error) in
                print("error:-",error)
                
            }
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
extension HomeViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                // delete the item here
                
                
                var object = NSDictionary()
                
                if self.isSearch
                {
                    object = self.DataDictFilter[indexPath.row] as! NSDictionary
                }
                else
                {
                    object = self.DataDict[indexPath.row] as! NSDictionary
                }
                if #available(iOS 10.0, *) {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
                self.DeleteApi(Indexpath: indexPath, object: object, issearch: self.isSearch)
                
                
            }
            deleteAction.image = UIImage(systemName: "trash")
            deleteAction.backgroundColor = .systemRed
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch
        {
            return DataDictFilter.count
        }
        return DataDict.count
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
       
        let tag = sender?.view?.tag
         print("sendertag:-",tag)
        var object = NSDictionary()
               
               if isSearch
               {
                object = DataDictFilter[tag!]
               }
               else
               {
                object = DataDict[tag!]
               }
               let homevc = UIStoryboard(name: StoryboardId.HOME, bundle: nil).instantiateViewController(withIdentifier: "CommentVIewController") as! CommentVIewController
               homevc.objectDict =  object
               self.navigationController?.pushViewController(homevc, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "SocialPostTableViewCell") as! SocialPostTableViewCell
        
       
        cell.txtview.tag = indexPath.row
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
     
        cell.txtview.addGestureRecognizer(tap)
        //DataDictFilter
        //Search Data 
       if isSearch
        {
            let object = DataDictFilter[indexPath.row] as! NSDictionary
            let mediaary = object.object(forKey: "media_ids") as? NSArray
            let commentsary = object.object(forKey: "comments") as? NSArray
            if mediaary?.count == 0 && commentsary?.count == 0
            {
                 cell.cnCollectionHeight.constant = 0
                cell.cvMedia.isHidden = true
           
               
                cell.objectDict = object
                cell.media_idsAry = object.object(forKey: "media_ids") as! [NSDictionary]
                cell.configureCellWith(viewController: self, indexPath1: indexPath, value: 0, object: object)
                
                cell.btnshare.tag = indexPath.row
                cell.btnshare.addTarget(self, action: #selector(self.SharepressButton), for: .touchUpInside) //<- use `#selector(...)`
                cell.btncomment.tag = indexPath.row
                cell.btncomment.addTarget(self, action: #selector(self.CommentAction), for: .touchUpInside) //<- use `#selector(...)`
                
                let imgesUrl = object["image"] as? String
                let IMagesURl = imgesUrl!.removeWhitespace()
                
                
                cell.imgUser.kf.setImage(with: URL.init(string: IMagesURl))
                
                cell.btnLikeCallBack = {(indexPath, value) in
                    //Api Calling
                    
                    self.likeUnlikeApi(Indexpath: indexPath, value: 0, object: object, issearch: self.isSearch)
                    
                }
                cell.btnDisLikeCallBack = {(indexPath, value) in
                    //Api Calling
                    
                    self.DislikeUnlikeApi(Indexpath: indexPath, value: 0, object: object, issearch: self.isSearch)
                    
                }
                
            
                          
                cell.layoutIfNeeded()
                cell.updateConstraints()
                return cell
            }
                
            else
            {
                
                
                if mediaary!.count > 0
                {
                    
                    if commentsary?.count == 0
                    {
                        cell.cnCollectionHeight.constant = 150
                         cell.cvMedia.isHidden = false
                      
                       
                        cell.objectDict = object
                          cell.media_idsAry = object.object(forKey: "media_ids") as! [NSDictionary]
                        cell.configureCellWith(viewController: self, indexPath1: indexPath, value: 0, object: object)
                      
                        
                        cell.btnshare.tag = indexPath.row
                        cell.btnshare.addTarget(self, action: #selector(self.SharepressButton), for: .touchUpInside) //<- use `#selector(...)`
                        
                        cell.btncomment.tag = indexPath.row
                        cell.btncomment.addTarget(self, action: #selector(self.CommentAction), for: .touchUpInside) //<- use `#selector(...)`
                        
                        
                        let imgesUrl = object["image"] as? String
                        let IMagesURl = imgesUrl!.removeWhitespace()
                        
                        
                        cell.imgUser.kf.setImage(with: URL.init(string: IMagesURl))
                        
//
                        cell.btnLikeCallBack = {(indexPath, value) in
                            //Api Calling
                            
                            self.likeUnlikeApi(Indexpath: indexPath, value: 0, object: object, issearch: self.isSearch)
                 
                            
                        }
                        cell.btnDisLikeCallBack = {(indexPath, value) in
                            //Api Calling
                            
                            self.DislikeUnlikeApi(Indexpath: indexPath, value: 0, object: object, issearch: self.isSearch)
                            
                            
                        }
                    
                       
                        if mediaary!.count >= 4
                                            {
                                               //
                                           }
                                           else
                                            {
                                               cell.layoutIfNeeded()
                                               cell.updateConstraints()
                                           }
                        
                        return cell
                    }
                    cell.cnCollectionHeight.constant = 150
                     cell.cvMedia.isHidden = false
               
                    cell.objectDict = object
                    cell.media_idsAry = object.object(forKey: "media_ids") as! [NSDictionary]
                    
                    cell.btnshare.tag = indexPath.row
                    cell.btnshare.addTarget(self, action: #selector(self.SharepressButton), for: .touchUpInside) //<- use `#selector(...)`
                    
                    cell.btncomment.tag = indexPath.row
                    cell.btncomment.addTarget(self, action: #selector(self.CommentAction), for: .touchUpInside) //<- use `#selector(...)`
                    
                    
                    let imgesUrl = object["image"] as? String
                    let IMagesURl = imgesUrl!.removeWhitespace()
                    
                
                    cell.imgUser.kf.setImage(with: URL.init(string: IMagesURl))
                    
//
                    cell.configureCellWith(viewController: self, indexPath1: indexPath, value: 0, object: object)
                    cell.btnLikeCallBack = {(indexPath, value) in
                        //Api Calling
                        
                        self.likeUnlikeApi(Indexpath: indexPath, value: 0, object: object, issearch: self.isSearch)
                        
                    }
                    cell.btnDisLikeCallBack = {(indexPath, value) in
                        //Api Calling
                        
                        self.DislikeUnlikeApi(Indexpath: indexPath, value: 0, object: object, issearch: self.isSearch)
                        
                    }
                   
                  
                    if mediaary!.count >= 4
                                        {
                                           //
                                       }
                                       else
                                        {
                                           cell.layoutIfNeeded()
                                           cell.updateConstraints()
                                       }
                    
                     return cell
                }
                else
                {
                    cell.objectDict = object
                    cell.cnCollectionHeight.constant = 0
                     cell.cvMedia.isHidden = true
                  
                                  cell.media_idsAry = object.object(forKey: "media_ids") as! [NSDictionary]

                    cell.configureCellWith(viewController: self, indexPath1: indexPath, value: 0, object: object)
                    
                    
                    //
                    cell.btnshare.tag = indexPath.row
                    cell.btnshare.addTarget(self, action: #selector(self.SharepressButton), for: .touchUpInside) //<- use `#selector(...)`
                    cell.btncomment.tag = indexPath.row
                    cell.btncomment.addTarget(self, action: #selector(self.CommentAction), for: .touchUpInside) //<- use `#selector(...)`
                    
                    
                    
                    let imgesUrl = object["image"] as? String
                    let IMagesURl = imgesUrl!.removeWhitespace()
                    
                  
                    cell.imgUser.kf.setImage(with: URL.init(string: IMagesURl))
                    
//
                    cell.btnLikeCallBack = {(indexPath, value) in
                        //Api Calling
                        
                        self.likeUnlikeApi(Indexpath: indexPath, value: 0, object: object, issearch: self.isSearch)
                        
                    }
                    cell.btnDisLikeCallBack = {(indexPath, value) in
                        //Api Calling
                        
                        self.DislikeUnlikeApi(Indexpath: indexPath, value: 0, object: object, issearch: self.isSearch)
                        
                    }
                 
                    
                             cell.layoutIfNeeded()
                             cell.updateConstraints()
                    return cell
                }
                
                
                
                
                
                
                
                
                
            }
//            cell.layoutIfNeeded()
//            cell.updateConstraints()
            return cell
        } 
        
        //Without Search Data
        let object = DataDict[indexPath.row]
        
        let mediaary = object.object(forKey: "media_ids") as? NSArray
        let commentsary = object.object(forKey: "comments") as? NSArray
        if mediaary?.count == 0 && commentsary?.count == 0
        {
             cell.cnCollectionHeight.constant = 0
            cell.cvMedia.isHidden = true

            cell.objectDict = object
            cell.media_idsAry = object.object(forKey: "media_ids") as! [NSDictionary]
            cell.configureCellWith(viewController: self, indexPath1: indexPath, value: 0, object: object)
            
            cell.btnshare.tag = indexPath.row
            cell.btnshare.addTarget(self, action: #selector(self.SharepressButton), for: .touchUpInside) //<- use `#selector(...)`
            cell.btncomment.tag = indexPath.row
            cell.btncomment.addTarget(self, action: #selector(self.CommentAction), for: .touchUpInside) //<- use `#selector(...)`
            
            let imgesUrl = object["image"] as? String
            let IMagesURl = imgesUrl!.removeWhitespace()
            
          
            cell.imgUser.kf.setImage(with: URL.init(string: IMagesURl))
            
            cell.btnDisLikeCallBack = {(indexPath, value) in
                //Api Calling
                
                self.DislikeUnlikeApi(Indexpath: indexPath, value: 0, object: object, issearch: self.isSearch)
                
            }
            
            cell.btnLikeCallBack = {(indexPath, value) in
                //Api Calling
                
                self.likeUnlikeApi(Indexpath: indexPath, value: 0, object: object, issearch: self.isSearch)
                
             

                
            }
            
            
            
            cell.layoutIfNeeded()
             // cell.updateFocusIfNeeded()
            return cell
        }
            
        else
        {
            
            
            if mediaary!.count > 0
            {
                
               /* if commentsary?.count == 0
                {
                    
                    cell.cnCollectionHeight.constant = 150
                     cell.cvMedia.isHidden = false
//
                   
                    cell.objectDict = object
                      cell.media_idsAry = object.object(forKey: "media_ids") as! [NSDictionary]
                    cell.configureCellWith(viewController: self, indexPath1: indexPath, value: 0, object: object)
                  let imgesUrl = object["image"] as? String
                                     let IMagesURl = imgesUrl!.removeWhitespace()
                                     
                                   
                                    cell.imgUser.kf.setImage(with: URL.init(string: IMagesURl))
                                     
                    
                    cell.btnshare.tag = indexPath.row
                    cell.btnshare.addTarget(self, action: #selector(self.SharepressButton), for: .touchUpInside) //<- use `#selector(...)`
                    
                    cell.btncomment.tag = indexPath.row
                    cell.btncomment.addTarget(self, action: #selector(self.CommentAction), for: .touchUpInside) //<- use `#selector(...)`
                    
                    
                   
//
                    cell.btnLikeCallBack = {(indexPath, value) in
                        //Api Calling
                        
                        self.likeUnlikeApi(Indexpath: indexPath, value: 0, object: object, issearch: self.isSearch)
                        //self.tblSocialPost.reloadRows(at: [indexPath], with: .fade)
                        
                    }
                    cell.btnDisLikeCallBack = {(indexPath, value) in
                        //Api Calling
                        
                        self.DislikeUnlikeApi(Indexpath: indexPath, value: 0, object: object, issearch: self.isSearch)
                        
                    }
                    
                    
                 
                   
                    
                     if mediaary!.count >= 4
                     {
 
                    }
                    else
                     {
                        cell.layoutIfNeeded()
                        cell.updateConstraints()
                        
                    }
                    
                    
                    return cell
                } */
                cell.cnCollectionHeight.constant = 150
                 cell.cvMedia.isHidden = false
//
                cell.objectDict = object
                cell.media_idsAry = object.object(forKey: "media_ids") as! [NSDictionary]
                
                cell.btnshare.tag = indexPath.row
                cell.btnshare.addTarget(self, action: #selector(self.SharepressButton), for: .touchUpInside) //<- use `#selector(...)`
                
                cell.btncomment.tag = indexPath.row
                cell.btncomment.addTarget(self, action: #selector(self.CommentAction), for: .touchUpInside) //<- use `#selector(...)`
                
                
                let imgesUrl = object["image"] as? String
                let IMagesURl = imgesUrl!.removeWhitespace()
                
                cell.imgUser.kf.setImage(with: URL.init(string: IMagesURl))
                
//
                cell.configureCellWith(viewController: self, indexPath1: indexPath, value: 0, object: object)
                cell.btnLikeCallBack = {(indexPath, value) in
                    //Api Calling
                    
                    self.likeUnlikeApi(Indexpath: indexPath, value: 0, object: object, issearch: self.isSearch)
                    
                }
                cell.btnDisLikeCallBack = {(indexPath, value) in
                    //Api Calling
                    
                    self.DislikeUnlikeApi(Indexpath: indexPath, value: 0, object: object, issearch: self.isSearch)
                    
                }
              
                 
                if mediaary!.count >= 4
                                    {
                                       //
                                   }
                                   else
                                    {
                                        
                                                            
                                    cell.layoutIfNeeded()
                                   // cell.updateConstraints()
                                   }
                
                 return cell
            }
            else
            {
                cell.objectDict = object
                cell.cnCollectionHeight.constant = 0
                 cell.cvMedia.isHidden = true

                        cell.media_idsAry = object.object(forKey: "media_ids") as! [NSDictionary]

                cell.configureCellWith(viewController: self, indexPath1: indexPath, value: 0, object: object)
                
                
                //
                cell.btnshare.tag = indexPath.row
                cell.btnshare.addTarget(self, action: #selector(self.SharepressButton), for: .touchUpInside) //<- use `#selector(...)`
                cell.btncomment.tag = indexPath.row
                cell.btncomment.addTarget(self, action: #selector(self.CommentAction), for: .touchUpInside) //<- use `#selector(...)`
                
                
                
                let imgesUrl = object["image"] as? String
                let IMagesURl = imgesUrl!.removeWhitespace()
                
                cell.imgUser.kf.setImage(with: URL.init(string: IMagesURl))
                
//
                cell.btnLikeCallBack = {(indexPath, value) in
                    //Api Calling
                    
                    self.likeUnlikeApi(Indexpath: indexPath, value: 0, object: object, issearch: self.isSearch)
                    
                }
                
                cell.btnDisLikeCallBack = {(indexPath, value) in
                    //Api Calling
                    
                    self.DislikeUnlikeApi(Indexpath: indexPath, value: 0, object: object, issearch: self.isSearch)
                    
                }
                
                
             
                // RatingClick
                       
                          //   cell.layoutIfNeeded()
                            cell.updateConstraints()
                                              
           
                return cell
            }
            
            
            
            
            
            
            
            
            
        }
        
       // return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if isSearch
        {
            //return DataDictFilter.count
        }
        else
        {
            

            if indexPath.row == self.DataDict.count - 1 && self.isLoadMore{
                if DataDict.count >= 3 {
                    self.currentPage += 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        // your code here
                         self.GetPostDataLoadMore()
                    }
                   
                }
                
                
            }
             // return DataDict.count
        }
      
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var object = NSDictionary()
        
        if isSearch
        {
            object = DataDictFilter[indexPath.row] 
        }
        else
        {
            object = DataDict[indexPath.row] 
        }
        let homevc = UIStoryboard(name: StoryboardId.HOME, bundle: nil).instantiateViewController(withIdentifier: "CommentVIewController") as! CommentVIewController
        homevc.objectDict =  object
        self.navigationController?.pushViewController(homevc, animated: true)
        
    }
    
    @objc func CommentAction(_ sender: UIButton){
        var object = NSDictionary()
        
        if isSearch
        {
            object = DataDictFilter[sender.tag] as! NSDictionary
        }
        else
        {
            object = DataDict[sender.tag] as! NSDictionary
        }
        let homevc = UIStoryboard(name: StoryboardId.HOME, bundle: nil).instantiateViewController(withIdentifier: "CommentVIewController") as! CommentVIewController
        homevc.objectDict =  object
        self.navigationController?.pushViewController(homevc, animated: true)
    }
    func DeleteApi(Indexpath:IndexPath,object:NSDictionary,issearch:Bool)
    {
        //  Like  Api PAra   //db_name, uid, db_password,'social.post', "set_post_delete",14, 7)
        let uid = UserDefaults.standard.object(forKey: "uid") as? Int
        let parther_ID = UserDefaults.standard.object(forKey: "parther_ID") as? Int
        let id = object.object(forKey: "id") as? Int
        let params = ["\(WebAPI.DBName)",uid!, "\(WebAPI.Password)","social.post","set_post_delete",[[id!],parther_ID!]] as [Any]
        
        
        print("params:-1",params)
        let url = "\(WebAPI.BaseURL)" + "object"
        
        KPNetworkManager.shared.webserviceCallWithoutProgessbar(strUrl: "\(url)", methodName: "execute_kw", params: params, isShowLoader: true, Isview: self.view, success: { (ObejcData) in
            if issearch
            {
                DispatchQueue.main.async {
                    
                    //  object.setValue(ObejcData, forKey: "like")
                    
                    self.DataDictFilter.remove(at: Indexpath.row)
                    self.tblSocialPost.reloadData()
                    //   self.tblSocialPost.reloadRows(at: [Indexpath], with: .none)
                }
                
                
            }
            else
            {
                // let object1 = self.DataDict[Indexpath.row]
                DispatchQueue.main.async {
                    
                    // self.DataDict[Indexpath.row] = object
                    
                    self.DataDict.remove(at: Indexpath.row)
                    self.tblSocialPost.reloadData()
                    // self.tblSocialPost.reloadRows(at: [Indexpath], with: .none)
                }
                
            }
            
            
        }) { (error) in
            print("error:-",error)
        }
        
    }
    func likeUnlikeApi(Indexpath:IndexPath,value:Int,object : NSDictionary,issearch:Bool)
    {
        let uid = UserDefaults.standard.object(forKey: "uid") as? Int
        let parther_ID = UserDefaults.standard.object(forKey: "parther_ID") as? Int
        
        
        
        var params = [Any]()
        let likevalue = object.object(forKey: "like") as? Int
        let id = object.object(forKey: "id") as? Int
                   //parther_ID!,id!,"like"
                   //[[],"\(txtEmailId.text!)","test"]
                   params = ["\(WebAPI.DBName)",uid!, "\(WebAPI.Password)","social.post","set_post_like",[[id!],parther_ID!]] as [Any]
       /* if likevalue == 0
        {
            // Like Api Para
            //Like  Api PAra   //db_name, uid, db_password,'social.post', "set_post_like",14, 7,"like")
           
        }
        else
        {
            //Dislike APi Para
            let id = object.object(forKey: "id") as? Int
            params = ["\(WebAPI.DBName)",uid!, "\(WebAPI.Password)","social.post","set_post_like",[[id!],parther_ID!,"dislike"]] as [Any]
        }
        */
        
        
        let url = "\(WebAPI.BaseURL)" + "object"
        
        KPNetworkManager.shared.webserviceCallWithoutProgessbar(strUrl: "\(url)", methodName: "execute_kw", params: params, isShowLoader: true, Isview: self.view, success: { (ObejcData) in
            if issearch
            {
                DispatchQueue.main.async {
                    if likevalue == 0
                    {
                        //like
                        object.setValue(1, forKey: "like")
                    }
                    else
                    {
                        //dislike
                        object.setValue(0, forKey: "like")
                        
                    }
                    //  object.setValue(ObejcData, forKey: "like")
                    self.DataDictFilter[Indexpath.row] = object
                 //   self.tblSocialPost.reloadData()
                    //  self.tblSocialPost.reloadRows(at: [Indexpath], with: .none)
                }
                
                
            }
            else
            {
                // let object1 = self.DataDict[Indexpath.row]
                DispatchQueue.main.async {
                    if likevalue == 0
                    {
                        //like
                        object.setValue(1, forKey: "like")
                    }
                    else
                    {
                        //dislike
                        object.setValue(0, forKey: "like")
                        
                    }
                    self.DataDict[Indexpath.row] = object
                   // self.tblSocialPost.reloadData()
                    // self.tblSocialPost.reloadRows(at: [Indexpath], with: .none)
                    //  self.tblSocialPost.reloadRows(at: [Indexpath], with: .none)
                }
                
            }
            
            
        }) { (error) in
            print("error:-",error)
        }
    }
    
    func DislikeUnlikeApi(Indexpath:IndexPath,value:Int,object : NSDictionary,issearch:Bool)
    {
        let uid = UserDefaults.standard.object(forKey: "uid") as? Int
        let parther_ID = UserDefaults.standard.object(forKey: "parther_ID") as? Int
        
        
        
        var params = [Any]()
        let likevalue = object.object(forKey: "dislike") as? Int
        let id = object.object(forKey: "id") as? Int
                   //parther_ID!,id!,"like"
                   //[[],"\(txtEmailId.text!)","test"]
                  // let id = object.object(forKey: "id") as? Int
                   params = ["\(WebAPI.DBName)",uid!, "\(WebAPI.Password)","social.post","set_post_dislike",[[id!],parther_ID!]] as [Any]
       /* if likevalue == 0
        {
            // Like Api Para
            //Like  Api PAra   //db_name, uid, db_password,'social.post', "set_post_like",14, 7,"like")
           
        }
        else
        {
            //Dislike APi Para
            let id = object.object(forKey: "id") as? Int
            params = ["\(WebAPI.DBName)",uid!, "\(WebAPI.Password)","social.post","set_post_like",[[id!],parther_ID!,"dislike"]] as [Any]
        }
        */
        
        
        let url = "\(WebAPI.BaseURL)" + "object"
        
        KPNetworkManager.shared.webserviceCallWithoutProgessbar(strUrl: "\(url)", methodName: "execute_kw", params: params, isShowLoader: true, Isview: self.view, success: { (ObejcData) in
            if issearch
            {
                DispatchQueue.main.async {
                    if likevalue == 0
                    {
                        //like
                        object.setValue(1, forKey: "dislike")
                    }
                    else
                    {
                        //dislike
                        object.setValue(0, forKey: "dislike")
                        
                    }
                    //  object.setValue(ObejcData, forKey: "like")
                    self.DataDictFilter[Indexpath.row] = object
                 //   self.tblSocialPost.reloadData()
                    //  self.tblSocialPost.reloadRows(at: [Indexpath], with: .none)
                }
                
                
            }
            else
            {
                // let object1 = self.DataDict[Indexpath.row]
                DispatchQueue.main.async {
                    if likevalue == 0
                    {
                        //like
                        object.setValue(1, forKey: "like")
                    }
                    else
                    {
                        //dislike
                        object.setValue(0, forKey: "like")
                        
                    }
                    self.DataDict[Indexpath.row] = object
                   // self.tblSocialPost.reloadData()
                    // self.tblSocialPost.reloadRows(at: [Indexpath], with: .none)
                    //  self.tblSocialPost.reloadRows(at: [Indexpath], with: .none)
                }
                
            }
            
            
        }) { (error) in
            print("error:-",error)
        }
    }
    
     @objc func RatingViewClick(_ sender: UIButton)
     {
        print("RatingViewClick",sender.tag)
        var object = NSDictionary()
               
               if isSearch
               {
                   object = DataDictFilter[sender.tag] as! NSDictionary
               }
               else
               {
                   object = DataDict[sender.tag] as! NSDictionary
               }
               let homevc = UIStoryboard(name: StoryboardId.HOME, bundle: nil).instantiateViewController(withIdentifier: "ReviewVC") as! ReviewVC
               homevc.objectDict =  object
               self.navigationController?.pushViewController(homevc, animated: true)
    }
    @objc func SharepressButton(_ sender: UIButton){ //<- needs `@objc`
        var object = NSDictionary()
        
        if isSearch
        {
            object = DataDictFilter[sender.tag] as! NSDictionary
        }
        else
        {
            object = DataDict[sender.tag] as! NSDictionary
        }
        ShareAPI(object: object)
        
        
    }
    
    func OpenShareKit(object: NSDictionary)  {
        // Setting description
        let firstActivityItem = "\(object.object(forKey: "message") ?? "")"
        
        let mediaary = object.object(forKey: "media_ids") as? NSArray
          var objectsToShare = [AnyObject]()
          objectsToShare.append(firstActivityItem as AnyObject)
        var image = UIImage()
        

        if mediaary!.count == 0
        {
            self.ShareContainText(objectsToShare: objectsToShare)
                       
        }
        else
        {
            // let socialMedias = media_idsAry[indexPath.row]
            let socialMedias = mediaary![0] as? NSDictionary
            let imgesUrl = socialMedias?.object(forKey: "url") as? String
            let IMagesURl = imgesUrl!.removeWhitespace()
            let type = socialMedias?.object(forKey: "mimetype") as? String
            let fileUrl = URL(string: IMagesURl)
            //   cell.imgUser.kf.setImage(with: URL.init(string: IMagesURl))
            
            switch type {
            case "image":
                objectsToShare.append(fileUrl  as AnyObject)

                 self.ShareContainText(objectsToShare: objectsToShare)
                
            case "video":
                objectsToShare.append(fileUrl  as AnyObject)
                 self.ShareContainText(objectsToShare: objectsToShare)
                
            case "pdf":
               objectsToShare.append(fileUrl  as AnyObject)
               self.ShareContainText(objectsToShare: objectsToShare)
                break
            default:
                break
            }
        }
        
        
        
        
    }
    func ShareContainText(objectsToShare : [AnyObject])  {
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: objectsToShare, applicationActivities: nil)
        
       
      //  activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
       
        
      
        if let popoverController = activityViewController.popoverPresentationController {
              popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
              popoverController.sourceView = self.view
              popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        popoverController.barButtonItem = self.navigationItem.leftBarButtonItem
          }
        
        // Pre-configuring activity items
       
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo,
            UIActivity.ActivityType.postToFacebook
        ]
        
       // activityViewController.isModalInPresentation = true
     
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    func ShareAPI(object: NSDictionary)  {
            self.view.frame.origin.y = 0
            view.endEditing(true)
            //Json
            let uid = UserDefaults.standard.object(forKey: "uid")
            let parther_ID = UserDefaults.standard.object(forKey: "parther_ID") as! Int
            let PostId =  object.object(forKey: "id") as! Int
            
            let jsonreuest: [String: Any] = ["post_id": PostId,"partner_id":parther_ID,"record_type":"share"]
            let params = ["\(WebAPI.DBName)",uid!, "\(WebAPI.Password)","social.bit.comments","create",[jsonreuest]] as [Any]
            
            print("params:-",params)
            let url = "\(WebAPI.BaseURL)" + "object"
            
            
            KPNetworkManager.shared.webserviceCall(strUrl: "\(url)", methodName: "execute_kw", params: params, isShowLoader: true, Isview: self.view, success: { (ObejcData) in
                print("ObejcData:-",ObejcData)
                DispatchQueue.main.async {
                    self.OpenShareKit(object: object)
                    // self.navigationController?.popViewController(animated: true)
    //                self.showAlertWithCompletion(pTitle: "", pStrMessage: "Comment added successfully") { (value) in
    //
    //                }
                }
                
            }) { (error) in
                print("error:-",error)
            }
            
            
        }
}
extension HomeViewController {
    
    
    /*func lazyDownloadImage(from url: URL, completion: (( _ error: Error?,  _ result: UIImage?) -> ())? = nil) {
        let request = Alamofire.request(url, method: .get).validate().responseData { [weak self] (response) in
            
            //self?.progressControl.lazyImageRequests[url] = nil
            
            guard let data = response.data else {
                completion?(response.error, nil)
                return
            }
            
            completion?(response.error, UIImage(data: data))
        }
        
    } */
    
}
extension HomeViewController : UITextFieldDelegate
{
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtSearch.resignFirstResponder()
        return true
    }
   
    
}
/*
extension HomeViewController: JSPullLoadDelegate {
    var tableView: UITableView! {
        if placeholderType == .none {
                       addRefreshView(#selector(refresh))
                   } else {
                       removeRefreshView()
                   }
    }
    
    
    
//    var tableView: UITableView! {
//        <#code#>
//    }
    
   
    
    
    
    var threshold: Int { return 10 }
    
    
    func fetchDataOnScroll(_ completion: @escaping (() -> ())) {
       
        var parameters: [String: Any]?
       
        
        
        
        
        /*
        //["offset": Video.count,"iAgencyID":"\(objData.iAgencyID ?? "")","CreatedBy":"le"]
        decode(ofType: MainResponse<VideoMsgModel>.self, from: "notifications/get".url, parameters: parameters) { [weak self] (error, result) in
            guard let self = self else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                if (result?.status ?? false), let sessions = result?.data {
                    if sessions.count == 0 {
                        self.canFetchMore = false
                        completion()
                        return
                    }
                    
                    var indexPaths: [IndexPath] = []
                    for i in self.Video.count..<(self.Video.count + sessions.count) {
                        indexPaths += [IndexPath(row: i, section: 0)]
                    }
                    self.Video += sessions
                   // self.applyFilter()
                    self.tableView.reloadData()
                    self.tableView.layoutIfNeeded()
                    completion()
                    self.canFetchMore = sessions.count >= self.threshold
                    //self.fetchImages(in: sessions)
                } else {
                    completion()
                    
                    
                    self.showAlert((error, result))
                }
            })
        } */
    }
}
*/
