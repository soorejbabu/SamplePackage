import Foundation
import Alamofire
import SwiftyJSON

let prepaidCardStagingBaseURL:String = "https://aceneobank.dev.acepe.co.in/api/"
let loginWebServiceURL:String = "login-sdk-mpin"
var webServicesAndParams = [String:Any]()
var token = String()

public struct SamplePackage {
    public private(set) var text = "Hello, World!"

    public init() {
    }
    
    public static func initialise(params:[String:Any], env:String, completion:@escaping([String:Any]) -> Void)
    {
        var url = String()
        switch env
        {
            case "STAGE": url = prepaidCardStagingBaseURL + loginWebServiceURL
                break
//            case "PROD": url = prepaidCardLiveBaseURL + loginWebServiceURL
//                break
            default: completion(["errors":"Environment not passed"])
                break
        }
//        print("Url:\(url)")
        AF.request("\(url)", method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).response(completionHandler:
        {
            response -> Void in
            switch response.result
            {
                case .success(let data):
                    do
                    {
                        let responseJSON = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : Any]
                        let json = JSON(data!)
                        if ((json["status"] == true) && (json["meta"]["code"].stringValue == "200") && (json["meta"]["message"].stringValue == "success"))
                        {
                            token = json["token"].stringValue
                            var i:Int = 0
                            while i < json["data"].count
                            {
                                let tempMethodString = json["data"][i]["method"].stringValue
                                let tempMethodURLString = "\(json["base_url"].stringValue)\(json["data"][i]["api"].stringValue)"
                                webServicesAndParams[tempMethodString] = ["url":tempMethodURLString,
                                                                          "type":json["data"][i]["type"].stringValue,
                                                                          "params":json["data"][i]["params"]]
                                i+=1
                            }
//                            print("\n\n\nWeb Services And Params:\(webServicesAndParams)\n\n\n")
//                            completion(["message":"success"])
                        }
                        else
                        {
                            token = ""
                            if json["errors"][0]["message"] != JSON.null
                            {
                                completion(["errors":"\(json["errors"][0]["message"].stringValue)"])
                            }
                        }
                        completion(responseJSON)
                    }
                    catch
                    {
                        let responseCode = response.response?.statusCode ?? 404
                        let str = String(decoding: data!, as: UTF8.self)
//                        print("Error Response Data:\n\(str)")
                        let errorDictResponse = ["ErrorResponseStatusCode":"\(String(describing: responseCode))"]
                        completion(errorDictResponse)
                    }
                    break
                case .failure(let error):
                    let errorDictResponse = ["ErrorResponse":"\(error)"]
                    completion(errorDictResponse)
                    break
            }
        })
    }
}
