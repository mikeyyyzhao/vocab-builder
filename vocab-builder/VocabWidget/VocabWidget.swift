//
//  VocabWidget.swift
//  VocabWidget
//
//  Created by Michael Zhao on 1/16/26.
//

import WidgetKit
import SwiftUI

struct VocabEntry: TimelineEntry {
    let date: Date
    let word: VocabularyWord
}

struct VocabProvider: TimelineProvider {
    func placeholder(in context: Context) -> VocabEntry {
        VocabEntry(date: Date(), word: VocabularyData.words[0])
    }

    func getSnapshot(in context: Context, completion: @escaping (VocabEntry) -> ()) {
        let entry = VocabEntry(date: Date(), word: VocabularyData.todaysWord())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<VocabEntry>) -> ()) {
        let currentWord = VocabularyData.todaysWord()
        let entry = VocabEntry(date: Date(), word: currentWord)

        // Refresh at midnight tomorrow
        let tomorrow = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)
        let timeline = Timeline(entries: [entry], policy: .after(tomorrow))
        completion(timeline)
    }
}

struct SmallWidgetView: View {
    var entry: VocabEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Word of the Day")
                .font(.caption)
                .foregroundColor(.secondary)

            Text(entry.word.word)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            Text(entry.word.definition)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(3)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct MediumWidgetView: View {
    var entry: VocabEntry

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Word of the Day")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(entry.word.word)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                Text(entry.word.definition)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

            Spacer()

            Image(systemName: "book.fill")
                .font(.largeTitle)
                .foregroundColor(.blue.opacity(0.3))
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct LargeWidgetView: View {
    var entry: VocabEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Word of the Day")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Spacer()
                Image(systemName: "book.fill")
                    .foregroundColor(.blue.opacity(0.3))
            }

            Spacer()

            Text(entry.word.word)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            Text(entry.word.definition)
                .font(.title3)
                .foregroundColor(.secondary)

            Spacer()

            Text("Updated daily at midnight")
                .font(.caption2)
                .foregroundColor(.secondary.opacity(0.7))
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

// MARK: - Lock Screen Widgets

struct AccessoryCircularView: View {
    var entry: VocabEntry

    var body: some View {
        ZStack {
            AccessoryWidgetBackground()
            VStack(spacing: 2) {
                Image(systemName: "book.fill")
                    .font(.caption)
                Text(entry.word.word.prefix(4))
                    .font(.caption2)
                    .fontWeight(.bold)
            }
        }
    }
}

struct AccessoryRectangularView: View {
    var entry: VocabEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Image(systemName: "book.fill")
                    .font(.caption)
                Text(entry.word.word)
                    .font(.headline)
                    .fontWeight(.bold)
            }
            Text(entry.word.definition)
                .font(.caption)
                .lineLimit(2)
        }
    }
}

struct AccessoryInlineView: View {
    var entry: VocabEntry

    var body: some View {
        Text("\(entry.word.word): \(entry.word.definition)")
    }
}

struct VocabWidgetEntryView: View {
    var entry: VocabEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        case .systemLarge:
            LargeWidgetView(entry: entry)
        case .accessoryCircular:
            AccessoryCircularView(entry: entry)
        case .accessoryRectangular:
            AccessoryRectangularView(entry: entry)
        case .accessoryInline:
            AccessoryInlineView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

struct VocabWidget: Widget {
    let kind: String = "VocabWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: VocabProvider()) { entry in
            if #available(iOS 17.0, *) {
                VocabWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                VocabWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Vocab Builder")
        .description("Learn a new word every day.")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .systemLarge,
            .accessoryCircular,
            .accessoryRectangular,
            .accessoryInline
        ])
    }
}

#Preview(as: .systemSmall) {
    VocabWidget()
} timeline: {
    VocabEntry(date: .now, word: VocabularyData.words[0])
}

#Preview(as: .systemMedium) {
    VocabWidget()
} timeline: {
    VocabEntry(date: .now, word: VocabularyData.words[0])
}

#Preview(as: .systemLarge) {
    VocabWidget()
} timeline: {
    VocabEntry(date: .now, word: VocabularyData.words[0])
}
