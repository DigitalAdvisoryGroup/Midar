//
//  CommentVIewController.swift
//  XMLRPCDemo
//
//  Created by Kuldip Mac on 03/09/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import UIKit
import GrowingTextView
//import Alamofire
import Photos
import SKPhotoBrowser

class CommentVIewController: UIViewController,GrowingTextViewDelegate,UITextFieldDelegate,UIDocumentPickerDelegate {
    @IBOutlet var tblCommentPost : UITableView!
    @IBOutlet weak var inputToolbar: UIView!
    @IBOutlet weak var textView: GrowingTextView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var btnPost: UIButton!
    var objectDict  = NSDictionary()
    var CommentAry = [NSDictionary]()
    @IBOutlet var btnUploaded : UIButton!
    var DataDictProfie = [NSDictionary]()
    var idVale = 0
    var UserImagesSelected = UIImage()
    var base64 = String()
    var fileName = String()
    var ImagesSize = 0
    var upload_limit = 0
    var categoryId = 0
    var strSelectOptionImages = 0
    @IBOutlet weak var lblFileName: UILabel!
    @IBOutlet weak var ViewImages: UIView!
    @IBOutlet weak var viewHeightFileName: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ImagesSize = 0
        btnPost.isUserInteractionEnabled = false
        btnPost.setTitleColor(UIColor.lightGray, for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfPresent(notification:)), name: NSNotification.Name("LikeUnlike"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodreload(notification:)), name: NSNotification.Name("TableViewReload"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
        SetTextData()
        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    @objc func methodreload(notification: Notification)
    {
        tblCommentPost.reloadData()
    }
    @objc func methodOfPresent(notification: Notification)
    {
        //print("userInfo:-",notification.userInfo)
        print("Deleted Call")
        
        self.CommentAry.removeAll()
        GetPostDetails(postId: idVale)
        
        
        
    }
    func SetTextData() {
        textView.placeholder = "Leave your thoughts here..".localized()
        self.title = "Post".localized()
        btnPost.setTitle("post".localized(), for: .normal)
        if categoryId == 0{
            //Nothing
            idVale = (objectDict.object(forKey: "id") as? Int)!
        }
        else
        {
            let topViewController = UIApplication.topViewController()
            //let PostId = objectDict.object(forKey: "id") as! Int
            //idVale = PostId
            let homevc = UIStoryboard(name: StoryboardId.HOME, bundle: nil).instantiateViewController(withIdentifier: "ReplayCommentVC") as! ReplayCommentVC
            homevc.PostId = idVale
            homevc.categoryId = categoryId
            
            topViewController?.navigationController?.pushViewController(homevc, animated: true)
            
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
            if #available(iOS 11, *) {
                if keyboardHeight > 0 {
                    keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom
                }
            }
            //textViewBottomConstraint.constant = keyboardHeight + 8
            self.view.frame.origin.y =  -keyboardHeight //+ 8
            view.layoutIfNeeded()
        }
    }
    @objc func tapGestureHandler() {
        view.endEditing(true)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        // navigationController?.navigationBar.barTintColor = UIColor.blue
        print("Comment:-",objectDict)
        self.CommentAry.removeAll()
        GetPostDetails(postId: idVale)
        
        if ImagesSize == 1
        {
            //alert
            
            ViewImages.isHidden = true
            viewHeightFileName.constant = 0
            fileName = ""
            base64 = ""
            ImagesSize = 0
            btnUploaded.setImage(UIImage.init(named: "Attachement"), for: .normal)
            let strmsg = "Maximum images size " + "\(upload_limit)" + "MB uploaded"
            self.showAlertWithCompletion(pTitle: "", pStrMessage: "\(strmsg)", completionBlock: nil)
        }
        self.DataDictProfie = UserDefaults.standard.object(forKey: "ProfileData") as! [NSDictionary]
        let object1 = DataDictProfie[0]
        let imgesUrl = object1["image_1920"] as? String
        let IMagesURl = imgesUrl!.removeWhitespace()
        if IMagesURl == ""
        {
            
        }else
        {
            self.imgUser.kf.setImage(with: URL.init(string: IMagesURl))
            
            
        }
        
        
        
    }
    //UiTextFiled Method
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text == ""
        {
            btnPost.isUserInteractionEnabled = false
            btnPost.setTitleColor(UIColor.lightGray, for: .normal)
            
        }
        else
        {
            btnPost.isUserInteractionEnabled = true
            btnPost.setTitleColor(UIColor.systemBlue, for: .normal)
            
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""
        {
            btnPost.isUserInteractionEnabled = false
            btnPost.setTitleColor(UIColor.lightGray, for: .normal)
            
        }
        else
        {
            btnPost.isUserInteractionEnabled = true
            btnPost.setTitleColor(UIColor.systemBlue, for: .normal)
            
        }
    }
    //MARK: Button Action
    
    @IBAction func ShareAction(_ sender: Any)
    {
        ShareAPI()
    }
    func OpenShareKit()  {
        
        
        let firstActivityItem = "\(objectDict.object(forKey: "message") ?? "")"
        
        let mediaary = objectDict.object(forKey: "media_ids") as? NSArray
        var objectsToShare = [AnyObject]()
        objectsToShare.append(firstActivityItem as AnyObject)
        
        
        
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
        
        
        
        // Setting description
        
    }
    
    func ShareContainText(objectsToShare : [AnyObject])  {
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: objectsToShare, applicationActivities: nil)
        
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            popoverController.barButtonItem = self.navigationItem.leftBarButtonItem
        }
        
        
        
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
        
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func ShareAPI()  {
        self.view.frame.origin.y = 0
        view.endEditing(true)
        //Json
        let uid = UserDefaults.standard.object(forKey: "uid")
        let parther_ID = UserDefaults.standard.object(forKey: "parther_ID") as! Int
        let PostId =  objectDict.object(forKey: "id") as! Int
        
        let jsonreuest: [String: Any] = ["post_id": PostId,"partner_id":parther_ID,"record_type":"share"]
        let params = ["\(WebAPI.DBName)",uid!, "\(WebAPI.Password)","social.bit.comments","create",[jsonreuest]] as [Any]
        
        print("params:-",params)
        let url = "\(WebAPI.BaseURL)" + "object"
        
        
        KPNetworkManager.shared.webserviceCall(strUrl: "\(url)", methodName: "execute_kw", params: params, isShowLoader: true, Isview: self.view, success: { (ObejcData) in
            print("ObejcData:-",ObejcData)
            DispatchQueue.main.async {
                self.OpenShareKit()
                
            }
            
        }) { (error) in
            print("error:-",error)
        }
        
        
    }
    @IBAction func ActionCloseImages(_ sender: Any)
    {
        ViewImages.isHidden = true
        viewHeightFileName.constant = 0
        fileName = ""
        base64 = ""
        ImagesSize = 0
        btnUploaded.setImage(UIImage.init(named: "Attachement"), for: .normal)
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print("DocumentUrl:-",urls)
        // documentUrl = urls[0]//url[0]
        print("documentUrlStr:-",urls)
        print(urls[0].lastPathComponent)
        
        lblFileName.text = urls[0].lastPathComponent
        fileName = "\(lblFileName.text!)"
        var Size = Float()
        let data = NSData(contentsOf: urls[0])
        
        //let imageData:NSData = image.pngData()! as NSData
        let strBase64:String = data!.base64EncodedString(options: .lineLength64Characters)
        
        Size = Float(Double(data!.count)/1024/1024)
        if Int(Size) <= upload_limit
        {
            print("ImagesSize:-",Size)
            //ImagesSize = 0
            base64 = strBase64
            ViewImages.isHidden = false
            viewHeightFileName.constant = 50
            // Here your image
        }
        else
        {
            
            ViewImages.isHidden = true
            viewHeightFileName.constant = 0
            fileName = ""
            base64 = ""
            ImagesSize = 0
            btnUploaded.setImage(UIImage.init(named: "Attachement"), for: .normal)
            let strmsg = "Maximum images size " + "\(upload_limit)" + "MB uploaded"
            self.showAlertWithCompletion(pTitle: "", pStrMessage: "\(strmsg )", completionBlock: nil)
            // ImagesSize = 1
            //  self.showAlertWithCompletion(pTitle: "", pStrMessage: "Maximum images size 3 MB uploaded", completionBlock: nil)
            
        }
        
    }
    //MARK: API Calling
    @IBAction func btnImagesProfileAction(_ sender: Any)
    {
        let alert = UIAlertController(title: "", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Photo", style: .default , handler:{ (UIAlertAction)in
            print("User click Approve button")
            
            self.OpenImagesSlectedSheet()
            //
        }))
        
        alert.addAction(UIAlertAction(title: "Document", style: .default , handler:{ (UIAlertAction)in
            print("User click Edit button")
            //
            //                }
            
            let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.text", "com.apple.iwork.pages.pages", "public.data","ppt"], in: .import)
            //let documentPicker = UIDocumentPickerViewController(documentTypes: ["ppt"], in: .import)
            documentPicker.delegate = self
            documentPicker.modalPresentationStyle = .popover
            
            if let popoverController = documentPicker.popoverPresentationController {
                popoverController.sourceView =  self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y:  self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            self.present(documentPicker, animated: true, completion: nil)
        }))
        
        
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView =  self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y:  self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        UIApplication.topViewController()?.present(alert, animated: true) {
            print("completion block")
        }
        
    }
    func  OpenImagesSlectedSheet()  {
        let alert = UIAlertController(title: "", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "From Gallery", style: .default , handler:{ (UIAlertAction)in
            print("User click Approve button")
            self.strSelectOptionImages = 0
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.modalPresentationStyle = .fullScreen
            vc.delegate = self
            
            UIApplication.topViewController()?.present(vc, animated: true) {
                //print("completion block")
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            print("User click Edit button")
            self.strSelectOptionImages = 1
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            
            vc.modalPresentationStyle = .fullScreen
            vc.delegate = self
            
            UIApplication.topViewController()?.present(vc, animated: true) {
                //print("completion block")
            }
        }))
        
        
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView =  self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y:  self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        UIApplication.topViewController()?.present(alert, animated: true) {
            print("completion block")
        }
        
    }
    
    @IBAction func PostAction(_ sender: Any)
    {
        self.view.frame.origin.y = 0
        view.endEditing(true)
        //Json
        let uid = UserDefaults.standard.object(forKey: "uid")
        let parther_ID = UserDefaults.standard.object(forKey: "parther_ID") as! Int
        let PostId =  objectDict.object(forKey: "id") as! Int
        
        let jsonreuest: [String: Any] = ["post_id": PostId,"partner_id":parther_ID,"comment":"\(textView.text!)","filename":"\(fileName)","content":"\(base64)"]
        let params = ["\(WebAPI.DBName)",uid!, "\(WebAPI.Password)","social.bit.comments","create",[jsonreuest]] as [Any]
        
        //   print("params:-",params)
        let url = "\(WebAPI.BaseURL)" + "object"
        
        
        KPNetworkManager.shared.webserviceCall(strUrl: "\(url)", methodName: "execute_kw", params: params, isShowLoader: true, Isview: self.view, success: { (ObejcData) in
            print("ObejcData:-",ObejcData)
            DispatchQueue.main.async {
                self.fileName = ""
                self.base64 = ""
                self.textView.text = ""
                self.ViewImages.isHidden = true
                self.viewHeightFileName.constant = 0
                
                self.ImagesSize = 0
                self.btnUploaded.setImage(UIImage.init(named: "Attachement"), for: .normal)
                self.viewWillAppear(true)
                
            }
            
        }) { (error) in
            print("error:-",error)
        }
        
        
    }
    
    
    func GetPostDetails(postId: Int) {
        let uid = UserDefaults.standard.object(forKey: "uid") as! Int
        let parther_ID = UserDefaults.standard.object(forKey: "parther_ID") as! Int
        //  UserDefaults.standard.set(ObejcData, forKey: "")
        
        let params = ["\(WebAPI.DBName)",uid, "\(WebAPI.Password)","social.post","get_post_api",[[postId],parther_ID]] as [Any]
        let url = "\(WebAPI.BaseURL)" + "object"
        KPNetworkManager.shared.webserviceCall(strUrl: "\(url)", methodName: "execute_kw", params: params, isShowLoader: true, Isview: self.view, success: { (ObejcData) in
            if let j = ObejcData as? [String:Any]{
                if let data = j["data"] as? NSArray{
                    
                    self.objectDict = data[0] as! NSDictionary
                    self.upload_limit = (self.objectDict.object(forKey: "upload_limit") as? Int)!
                    self.CommentAry = self.objectDict.object(forKey: "comments") as! [NSDictionary]
                    
                    DispatchQueue.main.async {
                        self.tblCommentPost.reloadData()
                    }
                    
                }
            }
            
            
        }) { (error) in
            print("error:-",error)
            
        }
    }
    
    
    
    
}
extension CommentVIewController: UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CommentAry.count + 1
    }
    @objc func handleTapLblName(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        
        
        
        let homevc = UIStoryboard(name: StoryboardId.HOME, bundle: nil).instantiateViewController(withIdentifier: "CampagionVC") as! CampagionVC
        
        homevc.objectDict = objectDict
        self.navigationController?.pushViewController(homevc, animated: true)
        
    }
    @objc func handleTaplblDate(_ sender: UITapGestureRecognizer? = nil) {
        
        let homevc = UIStoryboard(name: StoryboardId.HOME, bundle: nil).instantiateViewController(withIdentifier: "CampagionVC") as! CampagionVC
        
        homevc.objectDict = objectDict
        self.navigationController?.pushViewController(homevc, animated: true)
        
        
        
    }
    @objc func handleTapImgUser(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        
        // let tag = sender?.view?.tag
        let homevc = UIStoryboard(name: StoryboardId.HOME, bundle: nil).instantiateViewController(withIdentifier: "CampagionVC") as! CampagionVC
        
        homevc.objectDict = objectDict
        self.navigationController?.pushViewController(homevc, animated: true)
        
        
    }
    @objc func handleCommentUserImages(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        
        let tag = sender?.view?.tag
        //   print("handleCommentUserImages:-",tag)
        let  object = CommentAry[tag!]
        let homevc = UIStoryboard(name: StoryboardId.HOME, bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        homevc.partner_idINt = object.object(forKey: "partner_id") as! Int
        homevc.ProfileFlag = "1"
        self.navigationController?.pushViewController(homevc, animated: true)
    }
    @objc func handleCommentUserName(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        
        let tag = sender?.view?.tag
        //   print("handleCommentUserImages:-",tag)
        let  object = CommentAry[tag!]
        let homevc = UIStoryboard(name: StoryboardId.HOME, bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        homevc.partner_idINt = object.object(forKey: "partner_id") as! Int
        homevc.ProfileFlag = "1"
        self.navigationController?.pushViewController(homevc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentProfileCell") as! CommentProfileCell
            
            //Tap Gesture
            cell.lblname.tag = indexPath.row
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapLblName))
            cell.lblname.addGestureRecognizer(tap)
            
            cell.lbldate.tag = indexPath.row
            let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTaplblDate))
            cell.lbldate.addGestureRecognizer(tap1)
            
            cell.imgUser.tag = indexPath.row
            let tapImg = UITapGestureRecognizer(target: self, action: #selector(self.handleTapImgUser))
            cell.imgUser.addGestureRecognizer(tapImg)
            
            if let dict = objectDict.object(forKey: "media_ids") as? [NSDictionary]
            {
                cell.media_idsAry = objectDict.object(forKey: "media_ids") as! [NSDictionary]
                
                
                cell.configureCellWith(viewController: self, indexPath1: indexPath, object: objectDict)
            }
            
            
            
            cell.btnLikeCallBack = {(indexPath, value) in
                //Api Calling
                
                self.likeUnlikeApiProfile(Indexpath: indexPath, value: 0, object: self.objectDict)
                
            }
            
            cell.btnDisLikeCallBack = {(indexPath, value) in
                //Api Calling
                
                self.DislikeUnlikeApiProfile(Indexpath: indexPath, value: 0, object: self.objectDict)
                
            }
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentListCell") as! CommentListCell
        if CommentAry.count == 0{
            return cell
        }
        let object = CommentAry[indexPath.row - 1] as! NSDictionary
        cell.objectDict = object
        cell.imgCommentUser.tag = indexPath.row - 1
        let tapImagesUser = UITapGestureRecognizer(target: self, action: #selector(self.handleCommentUserImages))
        cell.imgCommentUser.addGestureRecognizer(tapImagesUser)
        
        cell.lblCommentName.tag = indexPath.row - 1
        let tapCommentName = UITapGestureRecognizer(target: self, action: #selector(self.handleCommentUserName))
        cell.lblCommentName.addGestureRecognizer(tapCommentName)
        
        
        cell.btnreplay.tag = indexPath.row - 1
        cell.btnreplay.addTarget(self, action: #selector(self.ReplayCommentClick), for: .touchUpInside) //<- use `#selector(...)`
        
        cell.configureCellWith(viewController: self, indexPath1: indexPath, object: object)
        cell.DeleteDropDown.selectionAction = { [weak self] (index, item) in
            
            print("DeletedCOmmentAPi",cell.DeleteDropDown.tag)
            
            let dataDict = self?.CommentAry[indexPath.row - 1] as! NSDictionary
            let id = dataDict.object(forKey: "id") as! Int
            print("Comment ID:-",id)
            self?.CommentAry.remove(at: indexPath.row - 1)
            self?.DeleteCommentAPI(CommentID: id)
            //APi
        }
        
        
        cell.btnLikeCallBack = {(indexPath, value) in
            //Api Calling
            
            self.likeUnlikeApi(Indexpath: indexPath, value: 0, object: object)
            
            
        }
        cell.btnDisLikeCallBack = {(indexPath, value) in
            //Api Calling
            
            self.DislikeUnlikeApi(Indexpath: indexPath, value: 0, object: object)
            
        }
        
        var media_idsAry = [NSDictionary]()
        media_idsAry = object.object(forKey: "media_ids") as! [NSDictionary]
        
        
        if media_idsAry.count == 0
        {
            // 0 size
            cell.cnImagesViewHeight.constant = 0
            cell.ViewPDF.isHidden = true
        }
        else
        {
            let dict = media_idsAry[0] as? NSDictionary
            cell.cnImagesViewHeight.constant = 128
            let type = dict!.object(forKey: "mimetype") as? String
            
            if type == "pdf"
            {
                cell.ViewPDF.isHidden = false
                let imgesUrl = dict!.object(forKey: "url") as? String
                let IMagesURl = imgesUrl!.removeWhitespace()
                
                let theURL = URL(string: IMagesURl)  //use your URL
                let fileNameWithExt = theURL?.lastPathComponent //somePDF.pdf
                cell.lblPdfName.text = "\(fileNameWithExt ?? "")"
                cell.lblPdfName.numberOfLines =  0
                cell.lblPdfName.sizeToFit()
                
                cell.ViewPDF.tag = indexPath.row - 1
                let tapImagesCommentUser = UITapGestureRecognizer(target: self, action: #selector(self.handlePdfViewOpen))
                cell.ViewPDF.addGestureRecognizer(tapImagesCommentUser)
                cell.ViewPDF.isUserInteractionEnabled = true
                
                
            }
            else
            {
                cell.ViewPDF.isHidden = true
                cell.imgCommentUserImages.tag = indexPath.row - 1
                let tapImagesCommentUser = UITapGestureRecognizer(target: self, action: #selector(self.handleImagesViewOpen))
                cell.imgCommentUserImages.addGestureRecognizer(tapImagesCommentUser)
                cell.imgCommentUserImages.isUserInteractionEnabled = true
                
                
                let imgesUrl = dict!.object(forKey: "url") as? String
                let IMagesURl = imgesUrl!.removeWhitespace()
                let fileUrl = URL(string: IMagesURl)
                cell.imgCommentUserImages.kf.setImage(with: URL.init(string: IMagesURl))
                
                //                                  lazyDownloadImage(from:fileUrl!) { (Error, Image) in
                //                                      cell.imgCommentUserImages.image = Image
                //                                  }
            }
            
            
            
            
        }
        
        
        return cell
    }
    // comment Images
    @objc func handlePdfViewOpen(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        
        let tag = sender?.view?.tag
        let  object = CommentAry[tag!] as! NSDictionary
        var media_idsAry = [NSDictionary]()
        media_idsAry = object.object(forKey: "media_ids") as! [NSDictionary]
        let dict = media_idsAry[0] as? NSDictionary
        
        let urlstr = dict!.object(forKey: "url") as? String
        let IMagesURl = urlstr!.removeWhitespace()
        
        let playerViewController = webviewClass()
        playerViewController.str = IMagesURl
        // playerViewController.fileURLs = urlNS!
        UIApplication.topViewController()?.show(playerViewController, sender: nil)
    }
    
    @objc func handleImagesViewOpen(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        
        let tag = sender?.view?.tag
        //   print("handleCommentUserImages:-",tag)
        let  object = CommentAry[tag!] as! NSDictionary
        var media_idsAry = [NSDictionary]()
        media_idsAry = object.object(forKey: "media_ids") as! [NSDictionary]
        let dict = media_idsAry[0] as? NSDictionary
        var images = [SKPhoto]()
        SKPhotoBrowserOptions.displayAction = false
        
        for i in 0..<media_idsAry.count
        {
            let dict = media_idsAry[i] as? NSDictionary
            let imgesUrl = dict?.object(forKey: "url") as? String
            let IMagesURl = imgesUrl!.removeWhitespace()
            let photo = SKPhoto.photoWithImageURL(IMagesURl as! String)
            photo.shouldCachePhotoURLImage = true
            images.append(photo)
            // print("i:-",i)
        }
        
        
        let browser = SKPhotoBrowser(photos: images)
        SKPhotoBrowserOptions.displayAction = true
        //browser.updateCloseButton(#imageLiteral(resourceName: "backArrow"))
        browser.initializePageIndex(1)
        UIApplication.topViewController()?.present(browser, animated: true, completion: {})
        
        
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Did Select Tableview Comment")
    }
    func DislikeUnlikeApiProfile(Indexpath:IndexPath,value:Int,object : NSDictionary)
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
        
        
        
        let url = "\(WebAPI.BaseURL)" + "object"
        
        KPNetworkManager.shared.webserviceCallWithoutProgessbar(strUrl: "\(url)", methodName: "execute_kw", params: params, isShowLoader: true, Isview: self.view, success: { (ObejcData) in
            
            DispatchQueue.main.async {
                if likevalue == 0
                {
                    //like
                    self.objectDict.setValue(1, forKey: "dislike")
                }
                else
                {
                    //dislike
                    self.objectDict.setValue(0, forKey: "dislike")
                    
                }
                
            }
            
            
            
        }) { (error) in
            print("error:-",error)
        }
    }
    func likeUnlikeApiProfile(Indexpath:IndexPath,value:Int,object : NSDictionary)
    {
        let uid = UserDefaults.standard.object(forKey: "uid") as? Int
        let parther_ID = UserDefaults.standard.object(forKey: "parther_ID") as? Int
        
        
        
        var params = [Any]()
        let likevalue = object.object(forKey: "like") as? Int
        let id = object.object(forKey: "id") as? Int
        //parther_ID!,id!,"like"
        //[[],"\(txtEmailId.text!)","test"]
        params = ["\(WebAPI.DBName)",uid!, "\(WebAPI.Password)","social.post","set_post_like",[[id!],parther_ID!]] as [Any]
        
        
        
        let url = "\(WebAPI.BaseURL)" + "object"
        
        KPNetworkManager.shared.webserviceCallWithoutProgessbar(strUrl: "\(url)", methodName: "execute_kw", params: params, isShowLoader: true, Isview: self.view, success: { (ObejcData) in
            
            DispatchQueue.main.async {
                if likevalue == 0
                {
                    //like
                    self.objectDict.setValue(1, forKey: "like")
                }
                else
                {
                    //dislike
                    self.objectDict.setValue(0, forKey: "like")
                    
                }
                
            }
            
            
        }) { (error) in
            print("error:-",error)
        }
    }
    @objc func RatingViewClick(_ sender: UIButton)
    {
        print("RatingViewClick",sender.tag)
        //var object = NSDictionary()
        
        //   object = DataDict[sender.tag] as! NSDictionary
        let homevc = UIStoryboard(name: StoryboardId.HOME, bundle: nil).instantiateViewController(withIdentifier: "ReviewVC") as! ReviewVC
        homevc.objectDict =  objectDict
        self.navigationController?.pushViewController(homevc, animated: true)
    }
    @objc func ReplayCommentClick(_ sender: UIButton)
    {
        print("ReplayCommentClick",sender.tag)
        
        
        // var CommentAryTep = [NSDictionary]()
        var object = NSDictionary()
        
        object = CommentAry[sender.tag] as! NSDictionary
        print("objectDict:-",objectDict)
        print("object",object)
        //  CommentAryTep.append(object)
        let PostId = objectDict.object(forKey: "id") as! Int
        let categoryId  = object.object(forKey: "id") as! Int
        //  let categoryId = 0
        let homevc = UIStoryboard(name: StoryboardId.HOME, bundle: nil).instantiateViewController(withIdentifier: "ReplayCommentVC") as! ReplayCommentVC
        homevc.PostId = PostId
        homevc.categoryId = categoryId
        //     homevc.CommentAry =  CommentAryTep
        //homevc.objectDict = objectDict
        self.navigationController?.pushViewController(homevc, animated: true)
    }
    //MARK: API CAlling
    func likeUnlikeApi(Indexpath:IndexPath,value:Int,object : NSDictionary)
    {
        
        let likevalue = object.object(forKey: "comment_like") as? Int
        let uid = UserDefaults.standard.object(forKey: "uid")
        let parther_ID = UserDefaults.standard.object(forKey: "parther_ID") as! Int
        
        let parent_id =  object.object(forKey: "id") as! Int
        
        let params = ["\(WebAPI.DBName)",uid!, "\(WebAPI.Password)","social.bit.comments","set_comment_like",[[parent_id],parther_ID]] as [Any]
        
        print("params:-",params)
        let url = "\(WebAPI.BaseURL)" + "object"
        
        
        KPNetworkManager.shared.webserviceCall(strUrl: "\(url)", methodName: "execute_kw", params: params, isShowLoader: true, Isview: self.view, success: { (ObejcData) in
            print("ObejcData:-",ObejcData)
            DispatchQueue.main.async {
                // let object1 = self.DataDict[Indexpath.row]
                DispatchQueue.main.async {
                    if likevalue == 0
                    {
                        //like
                        object.setValue(1, forKey: "comment_like")
                    }
                    else
                    {
                        //dislike
                        object.setValue(0, forKey: "comment_like")
                        
                    }
                    self.CommentAry[Indexpath.row - 1] = object
                    
                }
            }
            
        }) { (error) in
            print("error:-",error)
        }
        
    }
    func DislikeUnlikeApi(Indexpath:IndexPath,value:Int,object : NSDictionary)
    {
        
        
        let likevalue = object.object(forKey: "comment_dislike") as? Int
        let uid = UserDefaults.standard.object(forKey: "uid")
        let parther_ID = UserDefaults.standard.object(forKey: "parther_ID") as! Int
        let parent_id =  object.object(forKey: "id") as! Int
        
        let params = ["\(WebAPI.DBName)",uid!, "\(WebAPI.Password)","social.bit.comments","set_comment_dislike",[[parent_id],parther_ID]] as [Any]
        
        print("params:-",params)
        let url = "\(WebAPI.BaseURL)" + "object"
        
        
        KPNetworkManager.shared.webserviceCall(strUrl: "\(url)", methodName: "execute_kw", params: params, isShowLoader: true, Isview: self.view, success: { (ObejcData) in
            print("ObejcData:-",ObejcData)
            DispatchQueue.main.async {
                // let object1 = self.DataDict[Indexpath.row]
                DispatchQueue.main.async {
                    if likevalue == 0
                    {
                        //like
                        object.setValue(1, forKey: "comment_dislike")
                    }
                    else
                    {
                        //dislike
                        object.setValue(0, forKey: "comment_dislike")
                        
                    }
                    self.CommentAry[Indexpath.row - 1] = object
                    
                }
            }
            
        }) { (error) in
            print("error:-",error)
        }
        
    }
    
    func DeleteCommentAPI(CommentID: Int)  {
        let uid = UserDefaults.standard.object(forKey: "uid")
        
        let params = ["\(WebAPI.DBName)",uid!, "\(WebAPI.Password)","social.bit.comments","unlink",[CommentID]] as [Any]
        
        print("params:-",params)
        let url = "\(WebAPI.BaseURL)" + "object"
        
        
        KPNetworkManager.shared.webserviceCall(strUrl: "\(url)", methodName: "execute_kw", params: params, isShowLoader: true, Isview: self.view, success: { (ObejcData) in
            print("ObejcData:-",ObejcData)
            
            let data = ObejcData as? Bool
            
            if data == true
            {
                
                DispatchQueue.main.async {
                    
                    self.tblCommentPost.reloadData()
                    /* self.showAlertWithCompletion(pTitle: "", pStrMessage: "Comment deleted successfully") { (value) in
                     
                     //  self.navigationController?.popViewController(animated: true)
                     } */
                }
            }
            else
            {
                
            }
            
            
        }) { (error) in
            print("error:-",error)
        }
        
    }
    
}
//MARK: Images Picker Delegate

extension CommentVIewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    
    
    
    
    // Image Picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var Size = Float()
        
        if strSelectOptionImages == 1
        {
            // camera
            
            
            if let image = info[.originalImage] as? UIImage {
                // imgUser.image = image
                UserImagesSelected = image
                let imagessd = image.jpeg(.medium)
                let imageData1:NSData = imagessd! as NSData
                let strBase64:String = imageData1.base64EncodedString(options: .lineLength64Characters)
                Size = Float(Double(imageData1.count)/1024/1024)
                
                
                if Int(Size) <= upload_limit
                {
                    print("ImagesSize:-",Size)
                    ImagesSize = 0
                    base64 = strBase64
                    ViewImages.isHidden = false
                    viewHeightFileName.constant = 50
                    // Here your image
                }
                else
                {
                    ImagesSize = 1
                    //  self.showAlertWithCompletion(pTitle: "", pStrMessage: "Maximum images size 3 MB uploaded", completionBlock: nil)
                    
                }
                
                
                //
                let timestamp = NSDate().timeIntervalSince1970
                
                // print("File Name:-",fileUrl.lastPathComponent)
                fileName = "\(timestamp)"//fileUrl.lastPathComponent
                lblFileName.text = "\(timestamp)"
                lblFileName.numberOfLines = 0
                lblFileName.sizeToFit()
                btnUploaded.setImage(UIImage.init(named: "AttachementBlue"), for: .normal)
                
                strSelectOptionImages = 0
                
            }
        }
        else
        {
            // Gallery
            
            if let image = info[.originalImage] as? UIImage {
                // imgUser.image = image
                UserImagesSelected = image
                let imagessd = image.jpeg(.medium)
                let imageData1:NSData = imagessd as! NSData
                Size = Float(Double(imageData1.count)/1024/1024)
                
                //  let image : UIImage = imgUser.image!//UIImage(named:"imageNameHere")!
                //Now use image to create into NSData format
                let imageData:NSData = image.pngData()! as NSData
                let strBase64:String = imageData.base64EncodedString(options: .lineLength64Characters)
                
                Size = Float(Double(imageData.count)/1024/1024)
                if Int(Size) <= upload_limit
                {
                    print("ImagesSize:-",Size)
                    ImagesSize = 0
                    base64 = strBase64
                    ViewImages.isHidden = false
                    viewHeightFileName.constant = 50
                    // Here your image
                }
                else
                {
                    ImagesSize = 1
                    //  self.showAlertWithCompletion(pTitle: "", pStrMessage: "Maximum images size 3 MB uploaded", completionBlock: nil)
                    
                }
                
                
                
                
                
            }
            guard let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else {
                
                return
                
            }
            print("File Name:-",fileUrl.lastPathComponent)
            fileName = fileUrl.lastPathComponent
            lblFileName.text = "\(fileName)"
            lblFileName.numberOfLines = 0
            lblFileName.sizeToFit()
            btnUploaded.setImage(UIImage.init(named: "AttachementBlue"), for: .normal)
        }
        
        
        
        
        
        
        //ImagesUploadedAPI()
        //colMedia.reloadData()
        // UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    /* */
}
extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
