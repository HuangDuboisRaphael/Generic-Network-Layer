//
//  ContentView.swift
//  Generic-Network-Layer
//
//  Created by Raphaël Huang-Dubois on 02/04/2024.
//

import SwiftUI

struct ContentView: View {
    private let catService: CatServiceInterface
    @State private var text = ""
    @State private var messageError = ""
    
    init(catService: CatServiceInterface = CatService()) {
        self.catService = catService
    }
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(text)
        }
        .padding()
        .task {
            do {
                text = try await catService.getAFact().data[0]
            } catch {
                messageError = error.localizedDescription
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ContentView()
}
