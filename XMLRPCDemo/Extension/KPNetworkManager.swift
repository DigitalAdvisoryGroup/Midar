//
//  KPNetworkManager.swift
//  XMLRPCDemo
//
//  Created by Kuldip Mac on 25/08/20.
//  Copyright © 2020 Nyusoft. All rights reserved.
//

import Foundation
//import Alamofire
//import AEXML
//import AlamofireXMLRPC
import wpxmlrpc
import MBProgressHUD

typealias RequestCompletion = (_ response : Response) -> Void

extension Encodable {
    func toJSONData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
    
    func asDictionary() throws -> [String: Any] {
      let data = try JSONEncoder().encode(self)
      guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
        throw NSError()
      }
      return dictionary
    }
}
struct Response{
    var status : Bool = false
    var data : Any?
    var message : String?
    var currentBalance : Int?
    func isStatusTrue()->Bool{
        return status
    }
}
class KPNetworkManager: NSObject{

class var shared : KPNetworkManager {
    struct Static{
        static let instance = KPNetworkManager()
    }
    return Static.instance
}
    fileprivate override init(){}
    
    
    func webserviceCall(strUrl:String,methodName:String, params : [Any]? = [],isShowLoader : Bool = true,Isview:UIView,success: @escaping (_ value: (Any)) -> Void,
    failure: @escaping (_ error: String) -> Void) -> Void
    {
        if !Connectivity.isConnectedToInternet(){
                     //No Internet Connection
                     //CommonFunction.Instance.showMesaageBar(message: "No Internet Connection", bstyle: .danger)
                     if let topVC = UIApplication.topViewController(){
                         topVC.showAlertWithCompletion(pTitle: "", pStrMessage: "Please Check Your Internet Connection.", completionBlock: nil)
                     }
                     return
                 }
                
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: Isview, animated: true)
        }
       
              
               let anURL = URL(string: strUrl)
               var request: NSMutableURLRequest? = nil
        
    
               if let anURL = anURL {
                   request = NSMutableURLRequest(url: anURL)
               }
               request?.httpMethod = "POST"
               request?.setValue("application/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
      
               let encoder = WPXMLRPCEncoder(method: "\(methodName)", andParameters:params)
               do {
                   request?.httpBody = try encoder.dataEncoded()//dataEncoded()
               } catch {
               }
               
       let session = URLSession(configuration: URLSessionConfiguration.default)
        
       // session.mul
       
     //   let session = URLSession(configuration: URLSessionConfiguration.default)
        //  let session = URLSession.shared

          let dataTask = session.dataTask(with: request as! URLRequest) {data,response,error in
              let httpResponse = response as? HTTPURLResponse
            
            DispatchQueue.main.async {
                      MBProgressHUD.hide(for: Isview, animated: true)
                   }
              if (error != nil) {
               print(error)
               } else {
               print(httpResponse)
                  var requestReply: String? = nil
//                  if let data = data {
//                      requestReply = String(data: data, encoding: .ascii)
//                  }
//                  let responseData = requestReply?.data(using: .utf8)
//                    print("responseData:-",responseData)
                  let decoder = WPXMLRPCDecoder(data: data!)
                  if (decoder?.isFault())! {
                      print("XML-RPC error \(decoder?.faultCode()): \(decoder?.faultString())")
                    failure(decoder?.faultString() ?? "")
                  } else {
                      print("XML-RPC response: \(decoder?.object())")
                    success(decoder?.object())
                  }
               }

              DispatchQueue.main.async {
                 //Update your UI here
              }

          }
          dataTask.resume()
        
        
        
        //API calll
/*
                AlamofireXMLRPC.request(strUrl, methodName: methodName, parameters: params).responseXMLRPC
                     */
        // New code
        /*
                AlamofireXMLRPC.request(strUrl, methodName: methodName, parameters: params).responseXMLRPC  */
        
        
    }
    
    func webserviceCallWithoutProgessbar(strUrl:String,methodName:String, params : [Any]? = [],isShowLoader : Bool = true,Isview:UIView,success: @escaping (_ value: (Any)) -> Void,
        failure: @escaping (_ error: String) -> Void) -> Void
        {
            if !Connectivity.isConnectedToInternet(){
                         //No Internet Connection
                         //CommonFunction.Instance.showMesaageBar(message: "No Internet Connection", bstyle: .danger)
                         if let topVC = UIApplication.topViewController(){
                             topVC.showAlertWithCompletion(pTitle: "", pStrMessage: "Please Check Your Internet Connection.", completionBlock: nil)
                         }
                         return
                     }
                    
            
                   let anURL = URL(string: strUrl)
                   var request: NSMutableURLRequest? = nil
                   if let anURL = anURL {
                       request = NSMutableURLRequest(url: anURL)
                   }
                   request?.httpMethod = "POST"
                   request?.setValue("application/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
                   let encoder = WPXMLRPCEncoder(method: "\(methodName)", andParameters:params)
                   do {
                       request?.httpBody = try encoder.dataEncoded()
                   } catch {
                   }
                   
           let session = URLSession(configuration: URLSessionConfiguration.default)
            
            
       

              let dataTask = session.dataTask(with: request as! URLRequest) {data,response,error in
                  let httpResponse = response as? HTTPURLResponse
                
                  if (error != nil) {
                   print(error)
                   } else {
                   print(httpResponse)
                      var requestReply: String? = nil
//                      if let data = data {
//                          requestReply = String(data: data, encoding: .ascii)
//                      }
//                      let responseData = requestReply?.data(using: .utf8)

                      let decoder = WPXMLRPCDecoder(data: data!)
                      if (decoder?.isFault())! {
                          print("XML-RPC error \(decoder?.faultCode()): \(decoder?.faultString())")
                        failure(decoder?.faultString() ?? "")
                      } else {
                          print("XML-RPC response: \(decoder?.object())")
                        success(decoder?.object())
                      }
                   }

                  DispatchQueue.main.async {
                     //Update your UI here
                  }

              }
              dataTask.resume()
            
            
            
            //API calll
    /*
                    AlamofireXMLRPC.request(strUrl, methodName: methodName, parameters: params).responseXMLRPC
                         */
            // New code
            /*
                    AlamofireXMLRPC.request(strUrl, methodName: methodName, parameters: params).responseXMLRPC  */
            
            
        }
}


class ParseXMLData: NSObject, XMLParserDelegate {

var parser: XMLParser
var elementArr = [String]()
var arrayElementArr = [String]()
var str = "{"

init(xml: String) {
    parser = XMLParser(data: xml.replaceAnd().replaceAposWithApos().data(using: String.Encoding.utf8)!)
    super.init()
    parser.delegate = self
}

func parseXML() -> String {
    parser.parse()

    // Do all below steps serially otherwise it may lead to wrong result
    for i in self.elementArr{
        if str.contains("\(i)@},\"\(i)\":"){
            if !self.arrayElementArr.contains(i){
                self.arrayElementArr.append(i)
            }
        }
        str = str.replacingOccurrences(of: "\(i)@},\"\(i)\":", with: "},") //"\(element)@},\"\(element)\":"
    }

    for i in self.arrayElementArr{
        str = str.replacingOccurrences(of: "\"\(i)\":", with: "\"\(i)\":[") //"\"\(arrayElement)\":}"
    }

    for i in self.arrayElementArr{
        str = str.replacingOccurrences(of: "\(i)@}", with: "\(i)@}]") //"\(arrayElement)@}"
    }

    for i in self.elementArr{
        str = str.replacingOccurrences(of: "\(i)@", with: "") //"\(element)@"
    }

    // For most complex xml (You can ommit this step for simple xml data)
    self.str = self.str.removeNewLine()
    self.str = self.str.replacingOccurrences(of: ":[\\s]?\"[\\s]+?\"#", with: ":{", options: .regularExpression, range: nil)

    return self.str.replacingOccurrences(of: "\\", with: "").appending("}")
}

// MARK: XML Parser Delegate
func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {

    //print("\n Start elementName: ",elementName)

    if !self.elementArr.contains(elementName){
        self.elementArr.append(elementName)
    }

    if self.str.last == "\""{
        self.str = "\(self.str),"
    }

    if self.str.last == "}"{
        self.str = "\(self.str),"
    }

    self.str = "\(self.str)\"\(elementName)\":{"

    var attributeCount = attributeDict.count
    for (k,v) in attributeDict{
        //print("key: ",k,"value: ",v)
        attributeCount = attributeCount - 1
        let comma = attributeCount > 0 ? "," : ""
        self.str = "\(self.str)\"_\(k)\":\"\(v)\"\(comma)" // add _ for key to differentiate with attribute key type
    }
}

func parser(_ parser: XMLParser, foundCharacters string: String) {
    if self.str.last == "{"{
        self.str.removeLast()
        self.str = "\(self.str)\"\(string)\"#" // insert pattern # to detect found characters added
    }
}

func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {

    //print("\n End elementName \n",elementName)
    if self.str.last == "#"{ // Detect pattern #
        self.str.removeLast()
    }else{
        self.str = "\(self.str)\(elementName)@}"
    }
}
}
extension String{
    // remove amp; from string
func removeAMPSemicolon() -> String{
    return replacingOccurrences(of: "amp;", with: "")
}

// replace "&" with "And" from string
func replaceAnd() -> String{
    return replacingOccurrences(of: "&", with: "And")
}

// replace "\n" with "" from string
func removeNewLine() -> String{
    return replacingOccurrences(of: "\n", with: "")
}

func replaceAposWithApos() -> String{
    return replacingOccurrences(of: "Andapos;", with: "'")
}
}
