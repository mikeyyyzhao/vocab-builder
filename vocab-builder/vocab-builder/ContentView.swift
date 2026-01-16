//
//  ContentView.swift
//  vocab-builder
//
//  Created by Michael Zhao on 1/16/26.
//

import SwiftUI

struct ContentView: View {
    let todaysWord = VocabularyData.todaysWord()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Today's Word Card
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Word of the Day")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .textCase(.uppercase)

                            Spacer()

                            Image(systemName: "text.book.closed.fill")
                                .font(.title2)
                                .foregroundColor(.accentColor)
                        }

                        Text(todaysWord.word)
                            .font(.system(size: 36, weight: .bold, design: .serif))

                        Text(todaysWord.definition)
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    .padding(24)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)

                    // Instructions
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Add Widget to Home Screen", systemImage: "plus.square.on.square")
                            .font(.headline)

                        Text("Long press on your home screen, tap the + button, search for \"Vocab Builder\", and add the widget to see a new word every day.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Vocab Builder")
        }
    }
}

#Preview {
    ContentView()
}
