//
//  CommentCell.swift
//  XMLRPCDemo
//
//  Created by Kuldip Mac on 02/09/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import UIKit
import Kingfisher
//import Alamofire

class CommentCell: UITableViewCell {
    @IBOutlet var lblDesc : UILabel!
     @IBOutlet var btnLike : UIButton!
     @IBOutlet var imgUser : UIImageView!
    @IBOutlet var lblname : UILabel!
    @IBOutlet var lbldate : UILabel!
    var objectDict = NSDictionary()
     var media_idsAry = [NSDictionary]()
        var indexPath : IndexPath!
        @IBOutlet var btncomment : UIButton!
      @IBOutlet var btndelete : UIButton!
    @IBOutlet var btnshare : UIButton!
    var btnDeleteCallBack: (( _ indexPath : IndexPath)->())?

    var btnLikeCallBack: (( _ indexPath : IndexPath,_ value: Int)->())?
    @IBOutlet var imgCommentUser : UIImageView!
       @IBOutlet var lblCommentName : UILabel!
           @IBOutlet var lblCommentDes : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configureCellWith(viewController : UIViewController, indexPath1 : IndexPath,value: Int,object : NSDictionary)
    {
        indexPath = indexPath1
       //btnLike.tag = indexPath.row
        
        if let commentary = object.object(forKey: "comments") as? NSArray
        {
            if commentary.count == 0
            {
                
            }
            else
            {
                let dict = commentary.lastObject as? NSDictionary
                
                lblCommentName.text = "\(dict?.object(forKey: "author_name") as! String)"
                lblCommentDes.text = "\(dict?.object(forKey: "comment") as! String)"
                let imgesUrl = dict?.object(forKey: "author_image") as? String
                                              let IMagesURl = imgesUrl!.removeWhitespace()
                             //  let fileUrl = URL(string: IMagesURl)
                imgCommentUser.kf.setImage(with: URL.init(string: IMagesURl))

               // let fileUrl = URL(string: "\(dict?.object(forKey: "author_image") ?? "")")
                
//                lazyDownloadImage(from:fileUrl!) { (Error, Image) in
//                    self.imgCommentUser.image = Image
//                }
            }
            
        }
        
        lblname.text = "\(object["name"] ?? "")"
        lbldate.text = "Published by " + "\(object["post_owner"] ?? "") " + "\(object["date"] ?? "")"
        lblDesc.text = "\(object["message"] ?? "")"
              lblDesc.numberOfLines = 0
               lblDesc.sizeToFit()
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
        
      
        
    }
    
      /*  func lazyDownloadImage(from url: URL, completion: (( _ error: Error?,  _ result: UIImage?) -> ())? = nil) {
            let request = Alamofire.request(url, method: .get).validate().responseData { [weak self] (response) in
                
                //self?.progressControl.lazyImageRequests[url] = nil
                
                guard let data = response.data else {
                    completion?(response.error, nil)
                    return
                }
                
                completion?(response.error, UIImage(data: data))
            }
    //        if progressControl.lazyImageRequests == nil {
    //            progressControl.lazyImageRequests = [url: request]
    //        } else {
    //            progressControl.lazyImageRequests![url] = request
    //        }
        } */
    
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
    
}
