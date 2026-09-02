#if DEBUG
import Foundation

extension Library {
    /// A small slice of the real text, so previews and tests never depend on the bundle.
    static let preview = Library(chapters: [
        Chapter(
            id: 1,
            title: LocalizedText(
                tibetan: "ལེའུ་དང་པོ། མཁས་པ་བརྟག་པ།",
                english: "Chapter 1 - An Examination of the Wise",
                chinese: "第一章 辨智者篇"
            ),
            verseRange: VerseRange(start: 1, end: 3),
            verses: [
                Verse(
                    id: 1,
                    chapter: 1,
                    tibetan: "མཁས་པ་ཡོན་ཏན་མཛོད་འཛིན་པ།།",
                    english: "The wise who nourish a treasury of good qualities\nGather to themselves precious good advice.",
                    chinese: "智者是学问的宝藏,\n他们拥有智慧格言;"
                ),
                Verse(
                    id: 2,
                    chapter: 1,
                    tibetan: "སྐྱེ་བོ་ཡོན་ཏན་ཡོད་མེད་པའི།།",
                    english: "People may or may not be knowledgeable, but\nThe wise are judicious in what to do and what to avoid.",
                    chinese: "不管本人有无学问,\n能辨别是非是智者;"
                ),
                Verse(
                    id: 3,
                    chapter: 1,
                    tibetan: "ལེགས་བཤད་མཁས་པའི་བློ་གྲོས་ཀྱིས།།",
                    english: "Skilled in good advice, the wise know,\nBut foolish people do not.",
                    chinese: "智者用智慧理解格言,\n愚人却没有这种能力;"
                )
            ]
        ),
        Chapter(
            id: 2,
            title: LocalizedText(
                tibetan: "ལེའུ་གཉིས་པ། དམ་པ་བརྟག་པ།",
                english: "Chapter 2 - An Examination of the Noble",
                chinese: "第二章 辨正士篇"
            ),
            verseRange: VerseRange(start: 4, end: 5),
            verses: [
                Verse(
                    id: 4,
                    chapter: 2,
                    tibetan: "དམ་པ་རྣམས་ནི་ཡོན་ཏན་གྱིས།།",
                    english: "The noble are known by their qualities.",
                    chinese: "正士以功德著称。"
                ),
                Verse(
                    id: 5,
                    chapter: 2,
                    tibetan: "དམ་པའི་ཚུལ་ལ་གནས་པ་ཡི།།",
                    english: "Those who abide in noble conduct.",
                    chinese: "安住于正士之道者。"
                )
            ]
        )
    ])
}

extension SavedStore {
    /// A store backed by a throwaway defaults suite, so previews never touch real bookmarks.
    static func preview(saving verseIDs: [Verse.ID] = []) -> SavedStore {
        let store = SavedStore(defaults: .throwaway())
        for id in verseIDs.reversed() { store.toggle(id) }
        return store
    }
}

extension ReadingSettings {
    static func preview(
        primary: ReadingLanguage = .english,
        secondary: ReadingLanguage? = .tibetan
    ) -> ReadingSettings {
        let settings = ReadingSettings(defaults: .throwaway())
        settings.primary = primary
        settings.secondary = secondary
        return settings
    }
}

extension UserDefaults {
    static func throwaway() -> UserDefaults {
        UserDefaults(suiteName: "preview.\(UUID().uuidString)") ?? .standard
    }
}
#endif
