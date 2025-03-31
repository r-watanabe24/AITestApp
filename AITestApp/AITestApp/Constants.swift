//
//  Constants.swift
//  AITestApp
//
//  Created by L_0045_r.watanabe on 2025/03/25.
//

import Foundation

struct Constants {
    static let helpModelKey = "isUseLLM"

    struct Urls {
        private static let baseURL = "http://localhost:3000/"
        static let help = "\(baseURL)/help"
    }
}
