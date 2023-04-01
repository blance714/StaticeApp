//
//  Youdao.swift
//  Statice
//
//  Created by blance on 2023/4/1.
//

import Foundation
import CryptoKit

func md5Hash(_ input: String) -> String {
    let digest = Insecure.MD5.hash(data: input.data(using: .utf8)!)
    return digest.map { String(format: "%02hhx", $0) }.joined()
}

func getSign(param: String, salt: String) -> String {
    return md5Hash("fanyideskweb" + param + salt + "Ygy_4c=r#e#4EX^NUGUc5")
}

func youdaoTranslateSentence(param: String, handler: @escaping (String) -> Void) {
    let appVersion = "5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36 Edg/103.0.1264.62"
    
    let param = param.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "")
    
    let time = String(Int(Date().timeIntervalSince1970 * 1000))
    let salt = time + String(Int.random(in: 0..<10))
    let body: [String: String] = [
        "i": param,
        "from": "AUTO",
        "to": "AUTO",
        "smartresult": "dict",
        "client": "fanyideskweb",
        "salt": salt,
        "sign": getSign(param: param, salt: salt),
        "lts": time,
        "bv": md5Hash(appVersion),
        "doctype": "json",
        "version": "2.1",
        "keyfrom": "fanyi.web",
        "action": "FY_BY_CLICKBUTTION"
    ]
    
    let bodyString = body.map { "\($0)=\($1)" }.joined(separator: "&").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    
    var request = URLRequest(url: URL(string: "https://fanyi.youdao.com/translate_o?smartresult=dict&smartresult=rule")!)
    request.httpMethod = "POST"
    request.httpBody = Data(bodyString.utf8)
    request.setValue("application/json, text/javascript, */*; q=0.01", forHTTPHeaderField: "accept")
    request.setValue("ja,en;q=0.9,en-GB;q=0.8,en-US;q=0.7", forHTTPHeaderField: "accept-language")
    request.setValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "content-type")
    request.setValue("OUTFOX_SEARCH_USER_ID=1796239350@10.110.96.157", forHTTPHeaderField: "cookie")
    request.setValue("https://fanyi.youdao.com/", forHTTPHeaderField: "Referer")
    request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36 Edg/111.0.1661.62", forHTTPHeaderField: "User-Agent")
    
    URLSession.shared.dataTask(with: request) { data, _, error in
        do {
            if let data = data, let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let errorCode = json["errorCode"] as? Int,
               errorCode == 0,
               let translateResult = json["translateResult"] as? [[[String: Any]]] {
                
                if let smartResult = json["smartResult"] as? [String: Any],
                   let entries = smartResult["entries"] as? [String],
                   entries.count > 1 {
                    handler(entries[1])
                } else {
                    var string = ""
                    for result in translateResult {
                        if let tgt = result[0]["tgt"] as? String {
                            string = string + tgt;
                        }
                    }
                    handler(string)
                }
            } else {
                handler("")
            }
        } catch {
            handler("")
        }
    }.resume()
}

