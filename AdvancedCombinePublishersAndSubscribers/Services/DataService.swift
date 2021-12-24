//
//  DataService.swift
//  AdvancedCombinePublishersAndSubscribers
//
//  Created by Fred Javalera on 12/23/21.
//

import Foundation
import Combine
import UIKit

class DataService {
//  @Published var basicPublisher: String = "first publish"
//  let currentValuePublisher = CurrentValueSubject<String, Error>("first publish")
//  let passThroughPublisher = PassthroughSubject<String, Error>()
  let passThroughPublisher = PassthroughSubject<Int, Error>()
  let boolPublisher = PassthroughSubject<Bool, Error>()
  let intPublisher = PassthroughSubject<Int, Error>()
  
  init() {
    publishFakeData()
  }
  
  private func publishFakeData() {
//    let items: [String] = ["one", "two", "three", "four"]
    let items: [Int] = Array(1..<11)
    for index in items.indices {
      DispatchQueue.main.asyncAfter(deadline: .now() + Double(index)) {
        //        self.basicPublisher = items[index]
//        self.currentValuePublisher.send(items[index])
        self.passThroughPublisher.send(items[index])
        
        if index > 4 && index < 8 {
          self.boolPublisher.send(true)
        } else {
          self.boolPublisher.send(false)
        }
        
        if index == items.indices.last {
          self.passThroughPublisher.send(completion: .finished)
        }
      }
    }
  }
}
