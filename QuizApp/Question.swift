//
//  Question.swift
//  QuizApp
//
//  Created by 王柏凱 on 2020/12/28.
//

import Foundation

struct Question: Decodable {
    
    var question:String?
    var answers:[String]?
    var correctAnswerIndex:Int?
    var feedback:String?
    
}
