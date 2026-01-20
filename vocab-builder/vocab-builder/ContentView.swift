//
//  ContentView.swift
//  vocab-builder
//
//  Created by Michael Zhao on 1/16/26.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var currentIndex: Int = {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        return (dayOfYear - 1) % VocabularyData.words.count
    }()

    private let synthesizer = AVSpeechSynthesizer()

    private var currentWord: VocabularyWord {
        VocabularyData.words[currentIndex]
    }

    private func pronounceWord() {
        let utterance = AVSpeechUtterance(string: currentWord.word)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.4
        synthesizer.speak(utterance)
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

                        HStack(alignment: .firstTextBaseline, spacing: 8) {
                            Text(currentWord.word)
                                .font(.system(size: 36, weight: .bold, design: .serif))

                            Text("(\(currentWord.partOfSpeech.rawValue))")
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            Button(action: pronounceWord) {
                                Image(systemName: "speaker.wave.2.fill")
                                    .font(.title2)
                                    .foregroundColor(.accentColor)
                            }
                        }

                        Text(currentWord.definition)
                            .font(.title3)
                            .foregroundColor(.secondary)

                        Text("\"\(currentWord.example)\"")
                            .font(.body)
                            .foregroundColor(.secondary.opacity(0.8))
                            .italic()
                            .padding(.top, 4)

                        HStack(spacing: 12) {
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
