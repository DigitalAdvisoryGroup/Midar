//
//  SocialPostTableViewCell1.swift
//  XMLRPCDemo
//
//  Created by Kuldip Mac on 04/09/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import UIKit
import Kingfisher
import SKPhotoBrowser
import AVKit
//import Alamofire
import AVFoundation
import MediaPlayer
import Cosmos

class SocialPostTableViewCell1: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var viewRating: CosmosView!
       @IBOutlet var btnRating : UIButton!
       @IBOutlet var lblrating : UILabel!
    @IBOutlet var lblDesc : UILabel!
       @IBOutlet var btnLike : UIButton!
       @IBOutlet var imgUser : UIImageView!
      @IBOutlet var lblname : UILabel!
      @IBOutlet var lbldate : UILabel!
//     @IBOutlet var imgCommentUser : UIImageView!
//    @IBOutlet var lblCommentName : UILabel!
//        @IBOutlet var lblCommentDes : UILabel!
      var objectDict = NSDictionary()
     var media_idsAry = [NSDictionary]()
          var indexPath : IndexPath!
          @IBOutlet var btncomment : UIButton!
        @IBOutlet var btndelete : UIButton!
      @IBOutlet var btnshare : UIButton!
    @IBOutlet var txtview : UITextView!
      var btnDeleteCallBack: (( _ indexPath : IndexPath)->())?

      var btnLikeCallBack: (( _ indexPath : IndexPath,_ value: Int)->())?
    
    @IBOutlet var cnCollectionHeight : NSLayoutConstraint!
      
      @IBOutlet var vShowMore : UIView!
      @IBOutlet var cnViewMoreHieght : NSLayoutConstraint!
      @IBOutlet var btnViewMore : UIButton!
    @IBOutlet var cvMedia : UICollectionView!
    
    var ViewController = UIViewController()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.cvMedia.register(UINib(nibName: "MediaColCell", bundle: nil), forCellWithReuseIdentifier: "MediaColCell")
        self.cvMedia.register(UINib(nibName: "PdfViewCell", bundle: nil), forCellWithReuseIdentifier: "PdfViewCell")

               self.cvMedia.dataSource = self
               self.cvMedia.delegate = self
    }
    func configureCellWith(viewController : UIViewController, indexPath1 : IndexPath,value: Int,object : NSDictionary)
    {
        ViewController = viewController
        indexPath = indexPath1
        lblname.text = "\(object["name"] ?? "")"
        lbldate.text = "Published by " + "\(object["post_owner"] ?? "") " + "\(object["date"] ?? "")"
         lbldate.text = "Published by " + "\(object["post_owner"] ?? "") " + "\(object["date"] ?? "")"
              
              
              lblrating.text = "\(object["rating"] ?? 0)"
              
              viewRating.settings.fillMode = .precise
              viewRating.rating = (object["rating"] as? Double)!
              
              
              txtview.isEditable = false
              txtview.dataDetectorTypes = .all
              //
              txtview.text = "\(object["message"] ?? "")"
        let likedata = object.object(forKey: "like") as? Int
        if likedata == 0
        {
            btnLike.setImage(UIImage.init(named: "LikeUnread"), for: .normal)
                      // btnLike.setTitle(" Like", for: .normal)
        }
        else
        {
            btnLike.setImage(UIImage.init(named: "likeFiled"), for: .normal)
                    //   btnLike.setTitle(" Like", for: .normal)
        }
        
        
         self.cvMedia.reloadData()
       // self.imgUser.kf.setImage(with: URL.init(string: "\(object["images"] ?? "")"))
       // self.imgUser.kf.setImage(with: URL.init(string: "\(object["images"] ?? "")"), placeholder: UIImage.init(named: "Applogo"))
        
    }

       
    @IBAction func btnLikeTapped(_ sender : UIButton){
         //  let likeOrNone : E_LikeReaction = self.socialPostDetails.myLike != 0 ? .none : .like

           let likedata = objectDict.object(forKey: "like") as? Int
          // let likeOrNone : E_LikeReaction = self.socialPostDetails.myLike != 0 ? .none : .like
           //self.btnLikeCallBack?(self.socialPostDetails, E_LikeReaction.init(rawValue: self.socialPostDetails.myLike)!, likeOrNone, self.indexPath)
           self.btnLikeCallBack?(self.indexPath,likedata!)
       }
       @IBAction func btnDeleteTapped(_ sender : UIButton){

           self.btnDeleteCallBack?(self.indexPath)
       }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCollectionHeight(_ height : CGFloat){
        print("================== Cell 1 total img:  === Heeight :\(height)")
        self.cnCollectionHeight.constant = height
        self.layoutIfNeeded()
        self.updateConstraints()
    }
     //MARK:- collection methods
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // let cellDetails = self.objectDict.object(forKey: "media_ids") as? NSArray
        
        //socialPostDetails.socialMedias[indexPath.row]
        let socialMedias = self.objectDict.object(forKey: "media_ids") as? NSArray
        //self.socialPostDetails.socialMedias
        
        if socialMedias?.count == 0{
            self.setCollectionHeight(0)
            return CGSize.zero
        }else if socialMedias?.count == 1{
            let socialMediasDict = socialMedias?[indexPath.row] as? NSDictionary
            
            var type = socialMediasDict?.object(forKey: "mimetype") as? String
            
            if type == "pdf"
            {
                //Pdf
                let newHeightRatio = collectionView.frame.size.width / CGFloat(80)//CGFloat(cellDetails.width)
                //let newHeight = CGFloat(cellDetails.height) * newHeightRatio
                let newHeight = CGFloat(30) * newHeightRatio
                
                self.setCollectionHeight(100)
                self.layoutIfNeeded()
                return CGSize(width: self.frame.size.width, height: 100)
            }
            else
            {
                // Images
                let newHeightRatio = collectionView.frame.size.width / CGFloat(80)
                //CGFloat(cellDetails.width)
                //let newHeight = CGFloat(cellDetails.height) * newHeightRatio
                let newHeight = CGFloat(30) * newHeightRatio
                
                self.setCollectionHeight(newHeight)
                self.layoutIfNeeded()
                return CGSize(width: self.frame.size.width, height: newHeight)
            }
            
            
        }else if socialMedias?.count == 2{
            let socialMediasDict = socialMedias?[indexPath.row] as? NSDictionary
            
            var type = socialMediasDict?.object(forKey: "mimetype") as? String
            
            if type == "pdf"
            {
                //                       let layout = collectionViewLayout//UICollectionViewFlowLayout()
                //                        layout.scrollDirection = .horizontal
                //                        self.cvMedia.collectionViewLayout// = layout
                //collectionViewLayout.scrollDirection = .Horizontal
                //                       layout.scrollDirection = .Horizontal
                //                        self.awesomeCollectionView.collectionViewLayout = layout
                self.setCollectionHeight(cvMedia.frame.size.width / 2)
                self.layoutIfNeeded()
                  self.updateConstraints()
                return CGSize(width: cvMedia.frame.size.width, height: cvMedia.frame.size.height / 2)
            }
            else
            {
                self.setCollectionHeight(cvMedia.frame.size.width / 2)
                self.layoutIfNeeded()
                  self.updateConstraints()
                return CGSize(width: cvMedia.frame.size.width / 2, height: cvMedia.frame.size.height)
            }
            
        }
        else if socialMedias?.count == 3{
            self.setCollectionHeight(cvMedia.frame.size.width / 2)
            self.layoutIfNeeded()
             self.updateConstraints()
            if indexPath.row == 0
            {
                return CGSize(width: cvMedia.frame.size.width , height: cvMedia.frame.size.height / 2 )
                
            }
            else
            {
                return CGSize(width: cvMedia.frame.size.width / 2, height: cvMedia.frame.size.height / 2)
                
            }
        }
        else if socialMedias!.count >= 3{
            //            let totalHeight = ceil(Double(socialMedias!.count) / 2) * Double((self.frame.size.width / 2))
            //            self.setCollectionHeight(CGFloat(437))
            self.setCollectionHeight(cvMedia.frame.size.width)
            
            self.layoutIfNeeded()
              self.updateConstraints()
            if indexPath.row + 1 >= 5{
                return CGSize(width: 0, height: 0)
            }
            else
            {
                return CGSize(width: cvMedia.frame.size.width / 2, height: cvMedia.frame.size.height / 4 )
            }
            
            
            // return CGSize(width: 105, height: 105)
            
            //  return CGSize(width: cvMedia.frame.size.width / 2   , height: cvMedia.frame.size.height / 4)
        }
        else{
            self.setCollectionHeight(0)
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return media_idsAry.count//self.socialPostDetails.socialMedias.count
       }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaColCell", for: indexPath) as! MediaColCell
        
        let socialMedias = media_idsAry[indexPath.row]//self.socialPostDetails.socialMedias
        if media_idsAry.count > 0{
            
            var type = socialMedias.object(forKey: "mimetype") as? String
            
            switch type {
            case "image":
                // cell.configureCellWith(socialMedias)
                cell.configureCellWith(socialMedias, media_idsAry: media_idsAry, IndexPath: indexPath)
                
            case "video":
                cell.configureSingleVideo(socialMedias, index: indexPath)
            case "pdf":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PdfViewCell", for: indexPath) as! PdfViewCell
                
                //let urlstr =
                var urlstr = socialMedias.object(forKey: "url") as? String
                // let str = urlstr.lastp
                let theURL = URL(string: urlstr!)  //use your URL
                let fileNameWithExt = theURL?.lastPathComponent //somePDF.pdf
                cell.lblName.text = "\(fileNameWithExt ?? "")"
                // print("fileNameWithExt:-",fileNameWithExt)
                //                    let theURL = URL(string: "yourURL/somePDF.pdf")  //use your URL
                //                    let fileNameWithExt = theURL?.lastPathComponent //somePDF.pdf
                //  let fileNameLessExt = theURL?.deletingPathExtension().lastPathComponent
                
                //  savePdf(urlString: urlstr!, fileName:fileNameLessExt!)
                
                
                //                     let url = URL(string:urlstr!)
                //                    //else { return }
                //
                //                    let urlSession = URLSession(configuration: .default, delegate: self as! URLSessionDelegate, delegateQueue: OperationQueue())
                //
                //                    let downloadTask = urlSession.downloadTask(with: url!)
                //                           downloadTask.resume()
                //
                return cell
                break
            default:
                break
            }
            
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("DidSelect CollectionView Cell")
        let socialMedias = media_idsAry[indexPath.row]
        var type = socialMedias.object(forKey: "mimetype") as? String
        switch type {
        case "image":
            // cell.configureCellWith(socialMedias)
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
            //browser.updateCloseButton(#imageLiteral(resourceName: "backArrow"))
            browser.initializePageIndex(indexPath.row)
            UIApplication.topViewController()?.present(browser, animated: true, completion: {})
            
        case "video":
            
            NotificationCenter.default.post(name: NSNotification.Name("VideoClick"), object: nil,userInfo: nil)
            // if let videoURL = URL(string: "https://bit.runbot.candidroot.com/web/image/722")
            //
            
            if let videoURL = URL(string: (socialMedias.object(forKey: "url") as? String)!)
            {
                let player = AVPlayer(url: videoURL)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                UIApplication.topViewController()?.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
                
                
            }
        case "pdf":
            let urlstr = socialMedias.object(forKey: "url") as? String
            //  let urlNS = NSURL.init(string: urlstr!)
            let playerViewController = webviewClass()
            playerViewController.str = urlstr!
            // playerViewController.fileURLs = urlNS!
            UIApplication.topViewController()?.present(playerViewController, animated: true) {
                playerViewController.title = "Test View"
                //                             playerViewController.player!.play()
                //let fileUrl = URL(string: urlstr!)!
                // playerViewController.webView.loadRequest(URLRequest(url: fileUrl))
            }
            //                             // let str = urlstr.lastp
            //                              let theURL = URL(string: urlstr!)  //use your URL
            //                              let fileNameWithExt = theURL?.lastPathComponent //somePDF.pdf
            //                            //  cell.lblName.text = "\(fileNameWithExt ?? "")"
            //
            //             let fileNameLessExt = theURL?.deletingPathExtension().lastPathComponent
            //            showSavedPdf(url: "\(urlstr!)", fileName: "\(fileNameLessExt!)")
            //          let dc = UIDocumentInteractionController(url: URL(fileURLWithPath: urlstr))
            //            dc.delegate = self
            //            dc.presentPreview(animated: true)
            
            
            
            break
            
            
        default:
            break
        }
        
        
    }
}
