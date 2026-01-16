//
//  ContentView.swift
//  vocab-builder
//
//  Created by Michael Zhao on 1/16/26.
//

import SwiftUI

struct ContentView: View {
    @State private var currentIndex: Int = {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        return (dayOfYear - 1) % VocabularyData.words.count
    }()

    private var currentWord: VocabularyWord {
        VocabularyData.words[currentIndex]
    }

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

                        Text(currentWord.word)
                            .font(.system(size: 36, weight: .bold, design: .serif))

                        Text(currentWord.definition)
                            .font(.title3)
                            .foregroundColor(.secondary)

                        Button(action: {
                            currentIndex = (currentIndex + 1) % VocabularyData.words.count
                        }) {
                            HStack {
                                Text("Next Word")
                                Image(systemName: "arrow.right")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .cornerRadius(12)
                        }
                        .padding(.top, 8)
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
