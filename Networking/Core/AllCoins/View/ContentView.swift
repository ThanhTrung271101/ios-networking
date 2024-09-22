//
//  ContentView.swift
//  Networking
//
//  Created by Thành Trung on 20/9/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = CoinsViewModel()
    var body: some View {
        VStack {
            Text("\(viewModel.coin): \(viewModel.price)")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
