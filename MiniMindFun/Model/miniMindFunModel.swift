//
//  miniMindFunModel.swift
//  MiniMindFun
//
//  Created by Pooja on 17/11/24.
//

import Foundation

struct ItemType: Decodable {
    let name: String
    let path: String
}

struct ItemCollection: Decodable {
    let numbers: [ItemType]
    let shapes: [ItemType]
    let fruits: [ItemType]
    let vegetables: [ItemType]
    let colors: [ItemType]
    let birds: [ItemType]
    let animals: [ItemType]
    let profession: [ItemType]
    let vehicals: [ItemType]
    let alphabets: [ItemType]
}
