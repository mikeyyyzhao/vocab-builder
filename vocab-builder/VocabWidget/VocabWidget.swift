//
//  VocabWidget.swift
//  VocabWidget
//
//  Created by Michael Zhao on 1/16/26.
//

import WidgetKit
import SwiftUI

// MARK: - Timeline Entry
struct VocabEntry: TimelineEntry {
    let date: Date
    let word: VocabularyWord
}

// MARK: - Timeline Provider
struct VocabProvider: TimelineProvider {
    func placeholder(in context: Context) -> VocabEntry {
        VocabEntry(date: Date(), word: VocabularyData.todaysWord())
    }

    func getSnapshot(in context: Context, completion: @escaping (VocabEntry) -> Void) {
        let entry = VocabEntry(date: Date(), word: VocabularyData.todaysWord())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<VocabEntry>) -> Void) {
        let currentDate = Date()
        let todaysWord = VocabularyData.todaysWord()

        // Create entry for today
        let entry = VocabEntry(date: currentDate, word: todaysWord)

        // Calculate next midnight to refresh the widget
        let calendar = Calendar.current
        let tomorrow = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: currentDate)!)

        // Create timeline that refreshes at midnight
        let timeline = Timeline(entries: [entry], policy: .after(tomorrow))
        completion(timeline)
    }
}

// MARK: - Widget Views
struct VocabWidgetEntryView: View {
    var entry: VocabProvider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(word: entry.word)
        case .systemMedium:
            MediumWidgetView(word: entry.word)
        case .systemLarge:
            LargeWidgetView(word: entry.word)
        default:
            SmallWidgetView(word: entry.word)
        }
    }
}

struct SmallWidgetView: View {
    let word: VocabularyWord

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Word of the Day")
                .font(.caption2)
                .foregroundColor(.secondary)
                .textCase(.uppercase)

            Text(word.word)
                .font(.system(size: 20, weight: .bold, design: .serif))
                .foregroundColor(.primary)
                .minimumScaleFactor(0.7)
                .lineLimit(1)

            Text(word.definition)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct MediumWidgetView: View {
    let word: VocabularyWord

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Word of the Day")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)

                Text(word.word)
                    .font(.system(size: 28, weight: .bold, design: .serif))
                    .foregroundColor(.primary)

                Text(word.definition)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)

                Spacer()
            }

            Spacer()

            VStack {
                Image(systemName: "text.book.closed.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.accentColor.opacity(0.7))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct LargeWidgetView: View {
    let word: VocabularyWord

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Word of the Day")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)

                Spacer()

                Image(systemName: "text.book.closed.fill")
                    .font(.title2)
                    .foregroundColor(.accentColor.opacity(0.7))
            }

            VStack(alignment: .leading, spacing: 12) {
                Text(word.word)
                    .font(.system(size: 36, weight: .bold, design: .serif))
                    .foregroundColor(.primary)

                Text(word.definition)
                    .font(.title3)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text("Updated daily at midnight")
                .font(.caption2)
                .foregroundColor(.secondary.opacity(0.7))
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

// MARK: - Widget Configuration
struct VocabWidget: Widget {
    let kind: String = "VocabWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: VocabProvider()) { entry in
            VocabWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Vocab Builder")
        .description("Learn a new word every day.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Widget Bundle (if you have multiple widgets)
@main
struct VocabWidgetBundle: WidgetBundle {
    var body: some Widget {
        VocabWidget()
    }
}

// MARK: - Previews
#Preview(as: .systemSmall) {
    VocabWidget()
} timeline: {
    VocabEntry(date: .now, word: VocabularyData.todaysWord())
}

#Preview(as: .systemMedium) {
    VocabWidget()
} timeline: {
    VocabEntry(date: .now, word: VocabularyData.todaysWord())
}

#Preview(as: .systemLarge) {
    VocabWidget()
} timeline: {
    VocabEntry(date: .now, word: VocabularyData.todaysWord())
}
