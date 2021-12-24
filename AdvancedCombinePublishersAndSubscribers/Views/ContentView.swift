//
//  ContentView.swift
//  AdvancedCombinePublishersAndSubscribers
//
//  Created by Fred Javalera on 12/23/21.
//

import SwiftUI

struct ContentView: View {
  // 1 - View has reference to ViewModel.
  @StateObject private var viewModel = ContentViewModel()
  var body: some View {
    ScrollView {
      HStack {
        VStack {
          ForEach(viewModel.data, id: \.self) {
            Text($0)
              .font(.largeTitle)
              .fontWeight(.black)
          }
          
          if !viewModel.error.isEmpty {
            Text(viewModel.error)
          }
        }
        VStack {
          ForEach(viewModel.dataBools, id: \.self) {
            Text($0.description)
              .font(.largeTitle)
              .fontWeight(.black)
          }
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
