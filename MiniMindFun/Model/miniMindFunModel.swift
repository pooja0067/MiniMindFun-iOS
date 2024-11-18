//
//  miniMindFunModel.swift
//  MiniMindFun
//
//  Created by Pooja on 17/11/24.
//

import Foundation

struct Number: Decodable {
    let name: String
    let path: String
}

struct NumberCollection: Decodable {
    let numbers: [Number]
}
