//
//  ContentViewModel.swift
//  AdvancedCombinePublishersAndSubscribers
//
//  Created by Fred Javalera on 12/23/21.
//

import Foundation
import Combine

class ContentViewModel: ObservableObject {
  @Published var data : [String] = []
  @Published var dataBools: [Bool] = []
  @Published var error: String = ""
  // 2 - ViewModel has reference to DataService
  let dataService = DataService()
  var cancellables = Set<AnyCancellable>()
  
  init() {
    addSubscribers()
  }
  
  private func addSubscribers() {
    // 3 - Subscribing to publisher inside of dataService.
    //    dataService.basicPublisher
    //    dataService.currentValuePublisher
//    dataService.passThroughPublisher
    // 4 - Receive data
    // Sequence operations
    /*
     //      .first()
     //      .first(where: { int in
     //        return int > 4
     //      })
     //      .tryFirst(where: { int in
     //        if int == 3 {
     //          throw URLError(.badServerResponse)
     //        }
     //
     //        return int > 1
     //      })
     //      .last()
     //      .last(where: { $0 < 4 })
     //      .tryLast(where: { int in
     //        if int == 13 {
     //          throw URLError(.badServerResponse)
     //        }
     //        return int > 1
     //      })
     //      .dropFirst()
     //      .dropFirst(3)
     //      .drop(while: { $0 < 5 })
     //      .tryDrop(while: { int in
     //        if int == 5 {
     //          throw URLError(.badServerResponse)
     //        }
     //        return int < 6
     //      })
     //      .prefix(4)
     //      .prefix(while: { $0 < 5 })
     //      .tryPrefix(while: )
     //      .output(at: 5)
     //      .output(in: 2..<4)
     */
    
    // Mathematical Operations
    /*
     //      .max()
     //      .max(by: { int1, int2 in
     //        return int1 < int2
     //      })
     //      .tryMax(by: )
     //      .min()
     //      .min(by: { int1, int2 in
     //        return int1 < int2
     //      })
     //      .tryMin(by: )
     */
    
    // Filtering/Reducing Operations
    /*
     //      .map({ String($0) })
     //      .tryMap({ int in
     //        if int == 5 {
     //          throw URLError(.badServerResponse)
     //        }
     //
     //        return String(int)
     //      })
     //      .compactMap({ int in
     //        if int == 5 {
     //          return nil
     //        }
     //        // response skips 5
     //        return String(int)
     //      })
     //      .tryCompactMap({})
     //      .filter({ int in
     //        int > 3 && int < 7
     //      })
     //      .tryFilter()
     //      .removeDuplicates()
     //      .removeDuplicates(by: { int1, int2 in
     //        return int1 == int2
     //      })
     //      .tryRemoveDuplicates(by: )
     //      .replaceNil(with: 5)
     //      .replaceEmpty(with: 5)
     //      .replaceError(with: "DEFAULT VALUE")
     //      .scan(0, { existingValue, newValue in
     //        return existingValue + newValue
     //      })
     //      .tryScan()
     //      .reduce(0, { existingValue, newValue in
     //        existingValue + newValue
     //      })
     //      .tryReduce()
     //      .collect()
     //      .collect(3)
     //      .allSatisfy({ int in
     //        // returns true
     //        int < 50
     //      })
     //      .tryAllSatisfy()
     */
    
    // Timing Operations
    /*
     //      .debounce(for: 1.0, scheduler: DispatchQueue.main)
     //      .delay(for: 2.0, scheduler: DispatchQueue.main)
     //      .measureInterval(using: DispatchQueue.main)
     //      .throttle(for: 2.0, scheduler: DispatchQueue.main, latest: true)
     //      .retry(3)
     //      .timeout(0.75, scheduler: DispatchQueue.main)
     */
    
    // Multiple Publishers/Subscribers
    /*
    //      .combineLatest(dataService.boolPublisher)
    //      .compactMap({ (int, bool) in
    //        if bool {
    //          return String(int)
    //        }
    //
    //        return nil
    //      })
    //      .merge(with: dataService.intPublisher)
    //      .zip(dataService.boolPublisher)
    //      .map( { tuple in
    //        return String(tuple.0) + ", " + tuple.1.description
    //      })
    
    //      .tryMap({ _ in
    //        throw URLError(.badServerResponse)
    //      })
    //      .catch({ error in
    //        return self.dataService.intPublisher
    //      })
    */
    
    //
    
    let sharedPublisher = dataService.passThroughPublisher
//      .dropFirst(3)
      .share()
      .multicast {
        PassthroughSubject<Int, Error>()
      }
    
    sharedPublisher
      .map({ String($0) })
      .sink { completion in
        switch completion {
        case .finished:
          break
        case .failure(let error):
          self.error = "Error: \(error.localizedDescription)"
        }
      } receiveValue: { [weak self] returnedValue in
        // 5 - Store response data in self.data.
        self?.data.append(returnedValue)
      }
      .store(in: &cancellables)
    
    sharedPublisher
      .map({ $0 > 5 ? true : false })
      .sink { completion in
        switch completion {
        case .finished:
          break
        case .failure(let error):
          self.error = "Error: \(error.localizedDescription)"
        }
      } receiveValue: { [weak self] returnedValue in
        // 5 - Store response data in self.data.
        self?.dataBools.append(returnedValue)
      }
      .store(in: &cancellables)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
      sharedPublisher
        .connect()
        .store(in: &self.cancellables)
    }
  }
}
