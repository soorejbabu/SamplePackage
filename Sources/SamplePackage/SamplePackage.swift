import Foundation
import Alamofire
import SwiftyJSON

let prepaidCardLiveBaseURL:String = "https://aceneobank.com/api/"
let prepaidCardStagingBaseURL:String = "https://aceneobank.dev.acepe.co.in/api/"
let loginWebServiceURL:String = "login-sdk-mpin"
let prepaidCardBaseURLForInternalMethods = String()
var webServicesAndParams = [String:Any]()
var token = String()

public enum Method:String
{
    case mpinCheck = "Mpincheck"
    case getPhoneNumberTransactions = "GetPhonenoDetailstxn"
    case getVPATransactions = "GetVpaDetailstxn"
    case mpinLogin = "login-mpin"
    case registerCardUser = "registerCredUsers"
    case registerUser = "registerUserApi"
    case registerUserOTP = "registerUserOtp"
    case userMinKYC = "registerUserMinkyc"
    case cardHistory = "creditCardHistory"
    case cardDetails = "creditCardDetails"
    case cardSettings = "creditCardSettings"
    case setPinForCard = "creditCardSetPin"
    case cardBalance = "creditCardBalance"
    case cardTransactionLimit = "creditCardTxnLimit"
    case fetchCardLimit = "creditCardFetchLimit"
    case fetchCardChannel = "creditCardFetchChannel"
    case cardChannelSettings = "creditCardChannelSettings"
    case checkCardExist = "creditCardExist"
    case cardStatus = "creditCardStatus"
    case checkCardUserExist = "creditCardUserExist"
    case cardDynamicQR = "creditCardDynamicQr"
    case loadAmountToCard = "creditCardLoadAmount"
    case loadAmountThroughPaymentGateway = "creditCardLoadAmountPG"
    case cardRequest = "creditCardRequest"
    case virtualCard = "creditCardVirtual"
    case cardAssignCheck = "creditCardAssignCheck"
    case getCardProfile = "creditCardGetProfile"
}

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
            case "PROD": url = prepaidCardLiveBaseURL + loginWebServiceURL
                break
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
                            completion(["message":"success"])
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
    
    public static func request(params:[String:Any], method:Method, /*env:String,*/ completion:@escaping([String:Any]) -> Void)
    {
        var url = String()
        var methodType = HTTPMethod.post
        let webServiceDetails = JSON(webServicesAndParams)
        switch method
        {
            case .mpinCheck:url = webServiceDetails["Mpincheck"]["url"].stringValue
                switch webServiceDetails["Mpincheck"]["type"].stringValue
                {
                    case "POST": methodType = HTTPMethod.post
                        break
                    case "GET": methodType = HTTPMethod.get
                        break
                    default: break
                }
                break
            case .getPhoneNumberTransactions:url = webServiceDetails["GetPhonenoDetailstxn"]["url"].stringValue
                switch webServiceDetails["GetPhonenoDetailstxn"]["type"].stringValue
                {
                    case "POST": methodType = HTTPMethod.post
                        break
                    case "GET": methodType = HTTPMethod.get
                        break
                    default: break
                }
                break
            case .getVPATransactions:url = webServiceDetails["GetVpaDetailstxn"]["url"].stringValue
                switch webServiceDetails["GetVpaDetailstxn"]["type"].stringValue
                {
                    case "POST": methodType = HTTPMethod.post
                        break
                    case "GET": methodType = HTTPMethod.get
                        break
                    default: break
                }
                break
            case .mpinLogin:url = webServiceDetails["login-mpin"]["url"].stringValue
                switch webServiceDetails["login-mpin"]["type"].stringValue
                {
                    case "POST": methodType = HTTPMethod.post
                        break
                    case "GET": methodType = HTTPMethod.get
                        break
                    default: break
                }
                break
            case .registerCardUser:url = webServiceDetails["registerCredUsers"]["url"].stringValue
                switch webServiceDetails["registerCredUsers"]["type"].stringValue
                {
                    case "POST": methodType = HTTPMethod.post
                        break
                    case "GET": methodType = HTTPMethod.get
                        break
                    default: break
                }
                break
            case .registerUser:url = webServiceDetails["registerUserApi"]["url"].stringValue
                switch webServiceDetails["registerUserApi"]["type"].stringValue
                {
                    case "POST": methodType = HTTPMethod.post
                        break
                    case "GET": methodType = HTTPMethod.get
                        break
                    default: break
                }
                break
            case .registerUserOTP:url = webServiceDetails["registerUserOtp"]["url"].stringValue
                switch webServiceDetails["registerUserOtp"]["type"].stringValue
                {
                    case "POST": methodType = HTTPMethod.post
                        break
                    case "GET": methodType = HTTPMethod.get
                        break
                    default: break
                }
                break
            case .userMinKYC:url = webServiceDetails["registerUserMinkyc"]["url"].stringValue
                switch webServiceDetails["registerUserMinkyc"]["type"].stringValue
                {
                    case "POST": methodType = HTTPMethod.post
                        break
                    case "GET": methodType = HTTPMethod.get
                        break
                    default: break
                }
                break
            case .cardHistory:url = webServiceDetails["creditCardHistory"]["url"].stringValue
                switch webServiceDetails["creditCardHistory"]["type"].stringValue
                {
                    case "POST": methodType = HTTPMethod.post
                        break
                    case "GET": methodType = HTTPMethod.get
                        break
                    default: break
                }
                break
            case .cardDetails:url = webServiceDetails["creditCardDetails"]["url"].stringValue
                switch webServiceDetails["creditCardDetails"]["type"].stringValue
                {
                    case "POST": methodType = HTTPMethod.post
                        break
                    case "GET": methodType = HTTPMethod.get
                        break
                    default: break
                }
                break
            case .cardSettings:url = webServiceDetails["creditCardSettings"]["url"].stringValue
                switch webServiceDetails["creditCardSettings"]["type"].stringValue
                {
                    case "POST": methodType = HTTPMethod.post
                        break
                    case "GET": methodType = HTTPMethod.get
                        break
                    default: break
                }
                break
            case .setPinForCard:url = webServiceDetails["creditCardSetPin"]["url"].stringValue
                switch webServiceDetails["creditCardSetPin"]["type"].stringValue
                {
                    case "POST": methodType = HTTPMethod.post
                        break
                    case "GET": methodType = HTTPMethod.get
                        break
                    default: break
                }
                break
            case .cardBalance:url = webServiceDetails["creditCardBalance"]["url"].stringValue
                switch webServiceDetails["creditCardBalance"]["type"].stringValue
                {
                    case "POST": methodType = HTTPMethod.post
                        break
                    case "GET": methodType = HTTPMethod.get
                        break
                    default: break
                }
                break
            case .cardTransactionLimit:url = webServiceDetails["creditCardTxnLimit"]["url"].stringValue
                switch webServiceDetails["creditCardTxnLimit"]["type"].stringValue
                {
                    case "POST": methodType = HTTPMethod.post
                        break
                    case "GET": methodType = HTTPMethod.get
                        break
                    default: break
                }
                break
            case .fetchCardLimit:url = webServiceDetails["creditCardFetchLimit"]["url"].stringValue
                switch webServiceDetails["creditCardFetchLimit"]["type"].stringValue
                {
                    case "POST": methodType = HTTPMethod.post
                        break
                    case "GET": methodType = HTTPMethod.get
                        break
                    default: break
                }
                break
            case .fetchCardChannel:url = webServiceDetails["creditCardFetchChannel"]["url"].stringValue
                switch webServiceDetails["creditCardFetchChannel"]["type"].stringValue
                {
                    case "POST": methodType = HTTPMethod.post
                        break
                    case "GET": methodType = HTTPMethod.get
                        break
                    default: break
                }
                break
            case .cardChannelSettings:url = webServiceDetails["creditCardChannelSettings"]["url"].stringValue
                switch webServiceDetails["creditCardChannelSettings"]["type"].stringValue
                {
                    case "POST": methodType = HTTPMethod.post
                        break
                    case "GET": methodType = HTTPMethod.get
                        break
                    default: break
                }
                break
            case .checkCardExist:url = webServiceDetails["creditCardExist"]["url"].stringValue
                switch webServiceDetails["creditCardExist"]["type"].stringValue
                {
                    case "POST": methodType = HTTPMethod.post
                        break
                    case "GET": methodType = HTTPMethod.get
                        break
                    default: break
                }
                break
            case .cardStatus:url = webServiceDetails["creditCardStatus"]["url"].stringValue
                switch webServiceDetails["creditCardStatus"]["type"].stringValue
                {
                    case "POST": methodType = HTTPMethod.post
                        break
                    case "GET": methodType = HTTPMethod.get
                        break
                    default: break
                }
                break
            case .checkCardUserExist:url = webServiceDetails["creditCardUserExist"]["url"].stringValue
                switch webServiceDetails["creditCardUserExist"]["type"].stringValue
                {
                    case "POST": methodType = HTTPMethod.post
                        break
                    case "GET": methodType = HTTPMethod.get
                        break
                    default: break
                }
                break
            case .cardDynamicQR:url = webServiceDetails["creditCardDynamicQr"]["url"].stringValue
                switch webServiceDetails["creditCardDynamicQr"]["type"].stringValue
                {
                    case "POST": methodType = HTTPMethod.post
                        break
                    case "GET": methodType = HTTPMethod.get
                        break
                    default: break
                }
                break
            case .loadAmountToCard:url = webServiceDetails["creditCardLoadAmount"]["url"].stringValue
                switch webServiceDetails["creditCardLoadAmount"]["type"].stringValue
                {
                    case "POST": methodType = HTTPMethod.post
                        break
                    case "GET": methodType = HTTPMethod.get
                        break
                    default: break
                }
                break
            case .loadAmountThroughPaymentGateway:url = webServiceDetails["creditCardLoadAmountPG"]["url"].stringValue
                switch webServiceDetails["creditCardLoadAmountPG"]["type"].stringValue
                {
                    case "POST": methodType = HTTPMethod.post
                        break
                    case "GET": methodType = HTTPMethod.get
                        break
                    default: break
                }
                break
            case .cardRequest:url = webServiceDetails["creditCardRequest"]["url"].stringValue
                switch webServiceDetails["creditCardRequest"]["type"].stringValue
                {
                    case "POST": methodType = HTTPMethod.post
                        break
                    case "GET": methodType = HTTPMethod.get
                        break
                    default: break
                }
                break
            case .virtualCard:url = webServiceDetails["creditCardVirtual"]["url"].stringValue
                switch webServiceDetails["creditCardVirtual"]["type"].stringValue
                {
                    case "POST": methodType = HTTPMethod.post
                        break
                    case "GET": methodType = HTTPMethod.get
                        break
                    default: break
                }
                break
            case .cardAssignCheck:url = webServiceDetails["creditCardAssignCheck"]["url"].stringValue
                switch webServiceDetails["creditCardAssignCheck"]["type"].stringValue
                {
                    case "POST": methodType = HTTPMethod.post
                        break
                    case "GET": methodType = HTTPMethod.get
                        break
                    default: break
                }
                break
            case .getCardProfile:url = webServiceDetails["creditCardGetProfile"]["url"].stringValue
                switch webServiceDetails["creditCardGetProfile"]["type"].stringValue
                {
                    case "POST": methodType = HTTPMethod.post
                        break
                    case "GET": methodType = HTTPMethod.get
                        break
                    default: break
                }
                break
        }
        AF.request(url, method: methodType, parameters: params, encoding: JSONEncoding.default, headers: nil).response(completionHandler:
        {
            response -> Void in
            switch response.result
            {
                case .success(let data):
                    do
                    {
                        let responseJSON = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : Any]
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
                case .failure(let error):
                    let errorDictResponse = ["ErrorResponse":"\(error)"]
                    completion(errorDictResponse)
                    break
            }
        })
    }
}
