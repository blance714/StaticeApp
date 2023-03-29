//
//  URLSessionDelegate.swift
//  Statice
//
//  Created by blance on 2023/3/23.
//

import Foundation
import SwiftUI

class MyDelegate: NSObject, URLSessionDataDelegate {

    var dataTask: URLSessionDataTask!
    var receivedData: Data = Data()
    var expectedContentLength: Int64 = 0
    var currentContentLength: Int64 = 0
    
    @Binding var progressBar: Double
    @Binding var totalData: Int64
    init(_ progress: Binding<Double>, _ totalData: Binding<Int64>) {
        _progressBar = progress
        _totalData = totalData
    }

    // 接收到服务器响应
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        expectedContentLength = response.expectedContentLength
        completionHandler(.allow)
    }

    // 接收到数据
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        receivedData.append(data)
        currentContentLength += Int64(data.count)

        let progress = Double(currentContentLength) / Double(expectedContentLength)
        print("Download progress: \(progress)")
        progressBar = progress
        totalData = currentContentLength
    }
}

