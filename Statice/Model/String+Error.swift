//
//  String+Error.swift
//  Statice
//
//  Created by blance on 2023/4/10.
//

import Foundation

extension String: LocalizedError {
    public var errorDescription: String? { self }
}
