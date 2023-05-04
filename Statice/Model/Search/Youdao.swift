//
//  Youdao.swift
//  Statice
//
//  Created by blance on 2023/4/28.
//

import Foundation
import CryptoKit
import Combine
import CryptoSwift

func youdaoTranslateSentence(param: String, handler: @escaping (String) -> Void) {
    let client = "fanyideskweb"
    let product = "webfanyi"
    let pointParam = "client%2CmysticTime%2Cproduct"
    let appVersion = "1.0.0"
    let vendor = "web"
    let keyfrom = "fanyi.web"
    let mysticTime = Int(Date().timeIntervalSince1970) * 1000
    
    let key = "fsdsogkndfokasodnaso"
    
    let query: [String: String] = [
        "i": param.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
        "from": "ja",
        "to": "zh-CHS",
        "dictResult": "true",
        "keyid": "webfanyi",
    ]
    
    var params: [String: String] = query
    params["sign"] = Insecure.MD5.hash(data: "client=\(client)&mysticTime=\(mysticTime)&product=\(product)&key=\(key)".data(using: .utf8)!).map { String(format: "%02x", $0) }.joined()
    params["client"] = client
    params["product"] = product
    params["appVersion"] = appVersion
    params["vendor"] = vendor
    params["pointParam"] = pointParam
    params["mysticTime"] = mysticTime.description
    params["keyfrom"] = keyfrom
    
    let bodyStr =  ["i","from","to","dictResult","keyid","sign","client","product","appVersion","vendor","pointParam","mysticTime","keyfrom"].map{($0, params[$0]!)}.map{ (tag, value) in  "\(tag)=\(value)" }.joined(separator: "&")
    
    let url = URL(string: "https://dict.youdao.com/webtranslate")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json, text/plain, */*", forHTTPHeaderField: "accept")
    request.addValue("en,zh;q=0.9,ja;q=0.8", forHTTPHeaderField: "accept-language")
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
    request.addValue("OUTFOX_SEARCH_USER_ID=1796239350@10.110.96.157;", forHTTPHeaderField: "cookie")
    request.addValue("https://fanyi.youdao.com/", forHTTPHeaderField: "Referer")
    request.httpBody = bodyStr.data(using: .utf8)
    
    URLSession.shared.dataTask(with: request) { data, _, error in
        do {
            if let data = data,
               let stringData = String(data: data, encoding: .utf8),
               let decodedData = decodeAES128(stringData)?.data(using: .utf8),
               let json = try JSONSerialization.jsonObject(with: decodedData, options: []) as? [String: Any],
               let errorCode = json["code"] as? Int,
               errorCode == 0,
               let translateResults = json["translateResult"] as? [[[String: Any]]]
            {
                handler(translateResults.map{ $0.map { $0["tgt"] as? String ?? ""}.joined() }.joined())
            } else {
                handler("")
            }
        } catch {
            handler("")
        }
    }.resume()
}

func decodeAES128(_ t: String) -> String? {
    let key = "ydsecret://query/key/B*RGygVywfNBwpmBaZg*WT7SIOUP2T0C9WHMZN39j^DAdaZhAnxvGcCY6VYFwnHl"
    let lv = "ydsecret://query/iv/C@lZe2YzHtZ2CYgaXKSVfsb7Y4QWHjITPPZ0nQp87fBeJ!Iv6v^6fvi2WN@bYpJ4"
    
    guard let keyData = key.data(using: .utf8),
          let lvData = lv.data(using: .utf8) else {
        return nil
    }
    
    let base64String = t.replacingOccurrences(of: "-", with: "+").replacingOccurrences(of: "_", with: "/")
    guard let tData = Data(base64Encoded: base64String) else {
        return nil
    }
    
    
    let fo = Insecure.MD5.hash(data: keyData)
    let fn = Insecure.MD5.hash(data: lvData)
    
    let a = Data(fo)
    let i = Data(fn)
    
    do {
        let aes = try AES(key: [UInt8](a), blockMode: CBC(iv: [UInt8](i)), padding: .pkcs7)
        let decryptedData = try aes.decrypt([UInt8](tData))
        return String(data: Data(decryptedData), encoding: .utf8)
    } catch {
        print("Error decrypting: \(error)")
        return nil
    }
}
