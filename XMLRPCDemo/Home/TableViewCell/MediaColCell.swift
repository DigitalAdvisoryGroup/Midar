//
//  MediaColCell.swift
//  XMLRPCDemo
//
//  Created by Kuldip Mac on 02/09/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Alamofire
import SDWebImage

class MediaColCell: UICollectionViewCell {
    @IBOutlet weak var imgMedia: UIImageView!
       @IBOutlet weak var imgMediaIcon: UIImageView!
       @IBOutlet weak var lblName: UILabel!
       
       @IBOutlet var vThumbImgs : UIView!
       @IBOutlet var vAutoPlayVideo : UIView!
       
       @IBOutlet var vPlayer : UIView!
       @IBOutlet var btnPlayPause : UIButton!
       @IBOutlet var btnMuteUnmute : UIButton!
       
//       var mediaDetails : SocialMedias = SocialMedias()
//
//       var awardimages : AwardsImage = AwardsImage()
      // let faceDetector = FaceDetector()
       
       var AVPLAYER:AVPlayer?
       let avpController = AVPlayerViewController()
    var playerItem: AVPlayerItem?
    var avPlayerLayer: AVPlayerLayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
         NotificationCenter.default.addObserver(self, selector: #selector(self.methodVideoClick), name: NSNotification.Name("VideoClick"), object: nil)
        // Initialization code
    }

    func configureCellWith(_ media_ids : NSDictionary,media_idsAry : [NSDictionary],IndexPath : IndexPath){
           // self.mediaDetails = cellDetails
            
            self.vThumbImgs.isHidden = false
            self.vAutoPlayVideo.isHidden = true
            let type = media_ids.object(forKey: "mimetype") as? String
            
            switch type {
            case "image":
                self.imgMediaIcon.isHidden = true
                   
                if 3 >= IndexPath.row
                {
                    let imgesUrl = media_ids.object(forKey: "url") as? String
                                    let IMagesURl = imgesUrl!.removeWhitespace()

//                    let image = UIImage(data: try! Data(contentsOf: URL(string: IMagesURl)!))!
//
//                   // let thumb1 = image.resized(withPercentage: 0.1)
//                    let thumb2 = image.resized(toWidth: 72.0)
//                    self.imgMedia.image = thumb2
                   // self.imgMedia.sd_setImage(with: URL(string: IMagesURl), placeholderImage: UIImage(named: "BlueImages"))

                    
//                                   let imgesUrl = media_ids.object(forKey: "url") as? String
//                                                let IMagesURl = imgesUrl!.removeWhitespace()
//
//                                                let fileUrl = URL(string: IMagesURl)
//                                                //cell.imgUser.kf.setImage(with: URL.init(string: IMagesURl))
//
//                                                            lazyDownloadImage(from:fileUrl!) { (Error, Image) in
//                                                                self.imgMedia.image = Image
//                                                                //self.imageSizeAspectFit(imgview: self.imgMedia)
//                                                            }
                    
                  self.imgMedia.kf.setImage(with: URL.init(string: IMagesURl))
                    
                   // self.imgMedia.kf.setImage(with: URL(string: IMagesURl)!,options: [.onlyLoadFirstFrame])
                   //
                   
                     lblName.isHidden = true
                  //  self.imgMedia.contentMode = .scaleToFill
                    if IndexPath.row == 3
                    {
                       let count = media_idsAry.count - 4
                        if count == 0
                        {
                            lblName.isHidden = true
                        }
                        else
                        {
                            lblName.isHidden = false
                                                   lblName.text = "+ \(media_idsAry.count - 4)"
                        }
                       
                    }
                   
                    if 3 >= media_idsAry.count
                    {
                        self.imgMedia.contentMode = .scaleAspectFit
                    }
                    else
                    {
                        self.imgMedia.contentMode = .scaleToFill
                    }
                    
                    
                }
                else
                {
                     lblName.isHidden = true
                     print("IndexPath.row:-",IndexPath.row)
                    break
                }
                
                
             
//
               
            case "video":
               // self.imgMediaIcon.isHidden = true
                //self.imgMedia.kf.setImage(with: URL.init(string: (media_ids.object(forKey: "url") as? String)!))
                self.imgMediaIcon.isHidden = false
                              self.imgMedia.kf.setImage(with: URL.init(string: (media_ids.object(forKey: "url") as? String)!))
                  
                               self.imgMediaIcon.image = #imageLiteral(resourceName: "vdo_play_icon")
            default:
                break
            }
           /* switch self.type//mediaDetails.smediaType
            {
            case "image": //Image
                self.imgMediaIcon.isHidden = true
                self.imgMedia.kf.setImage(with: URL.init(string: (media_ids.object(forKey: "mimetype") as? String)!))
            case "1": //Video
                self.imgMediaIcon.isHidden = false
               // self.imgMedia.kf.setImage(with: URL.init(string: self.mediaDetails.smediaThumb))
   
                self.imgMediaIcon.image = #imageLiteral(resourceName: "vdo_play_icon")
            case "2": //Music
                self.imgMediaIcon.isHidden = false
                self.imgMedia.image = UIImage(named: "img_music_back")
                self.imgMediaIcon.image = #imageLiteral(resourceName: "icon_music")
            default:
                break
            } */
        }
    

    func configureSingleVideo(_ media_ids : NSDictionary,index: IndexPath){
           // self.mediaDetails = cellDetails
            
            self.vThumbImgs.isHidden = true
            self.vAutoPlayVideo.isHidden = false
            let type = media_ids.object(forKey: "url") as? String
     
            
        vPlayer.tag = index.row
        //https://fra1.digitaloceanspaces.com/channel/SampleVideo_1280x720_2mb.mp4
                AVPLAYER = AVPlayer(url: URL.init(string: ((media_ids.object(forKey: "url") as? String)!))!)

       // AVPLAYER = AVPlayer(url: URL.init(string: ("https://v.cdn.vine.co/r/videos/AA3C120C521177175800441692160_38f2cbd1ffb.1.5.13763579289575020226.mp4"))!)
            self.avpController.player = AVPLAYER
            avpController.view.frame = self.vPlayer.frame
        
         self.vPlayer.addSubview(avpController.view)
        

//        let url = URL(string: ((media_ids.object(forKey: "url") as? String)!))
//        let player = AVPlayer()
//        let asset = AVURLAsset(url: url!)
//        let playerItem = AVPlayerItem(asset: asset)
//        player.replaceCurrentItem(with: playerItem)
//         self.avpController.player = player
//        avpController.view.frame = self.vPlayer.frame
//
//               self.vPlayer.addSubview(avpController.view)
//        player.play()
     /*
        let asset = AVAsset(url: url!)
        let playerItem = AVPlayerItem(asset: asset)
        playerItem.videoComposition = .init(propertiesOf: asset)
        let player = AVPlayer(playerItem: playerItem)
        
        //3. Create AVPlayerLayer object
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.vPlayer.bounds //bounds of the view in which AVPlayer should be displayed
        playerLayer.videoGravity = .resizeAspect
        
        //4. Add playerLayer to view's layer
        self.vPlayer.layer.addSublayer(playerLayer)
        
        //5. Play Video
        player.play()
        */
        
           // avpController.player?.play()
            //AVPLAYE
            // AVPLAYER?.automaticallyWaitsToMinimizeStalling = false
            
           
           // self.avpController.player?.pause()
           // AVPLAYER?.pause()
            //creates URL from string
       /*     let url = URL(string: type!)
             
             let asset = AVAsset(url: url!)
             let playerItem = AVPlayerItem(asset: asset)
             let player = AVPlayer(playerItem: playerItem)
             
             let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.vPlayer.bounds
             playerLayer.videoGravity = .resizeAspect
            
             let playerViewController = AVPlayerViewController()
             playerViewController.player = player
             
            //gets the frame size of table view cell view
            playerViewController.view.frame = self.vPlayer.frame//CGRect (x:0, y:0, width:cell.videoPlayer.frame.size.width, height:cell.videoPlayer.frame.size.height)
             
             self.addChild(playerViewController)
            self.vPlayer.c
             //adds the video to the tableView cell
            self.vPlayer.addSubview(playerViewController.view)
            // cell.videoPlayer.addSubview(playerViewController.view)
             playerViewController.didMove(toParent: self)
             
             //plays the video
             playerViewController.player?.play()
          
            */
    
        }
    @objc func methodVideoClick(notification: Notification)
    {
        //print("userInfo:-",notification.userInfo)
        print("methodVideoClick")
        AVPLAYER?.pause()
       
        
        
    }
    
    /*   func lazyDownloadImage(from url: URL, completion: (( _ error: Error?,  _ result: UIImage?) -> ())? = nil) {
       
        Alamofire.request("https://httpbin.org/image/png").responseImage { response in
            debugPrint(response)

            print(response.request)
            print(response.response)
            debugPrint(response.result)

            if case .success(let image) = response.result {
                print("image downloaded: \(image)")
            }
        }
       
      /*  let req = Alamofir
        let request = Alamofire.request(url, method: .get).validate().responseData { [weak self] (response) in
                
                //self?.progressControl.lazyImageRequests[url] = nil
                
                guard let data = response.data else {
                    completion?(response.error, nil)
                    return
                }
                
                completion?(response.error, UIImage(data: data))
            }*/
    //        if progressControl.lazyImageRequests == nil {
    //            progressControl.lazyImageRequests = [url: request]
    //        } else {
    //            progressControl.lazyImageRequests![url] = request
    //        }
        }
    */
    
    
}
extension String {
  func replace(string:String, replacement:String) -> String {
      return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
  }

  func removeWhitespace() -> String {
      return self.replace(string: " ", replacement: "")
  }
}



// Images Comprees Code
extension UIImage {
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}

