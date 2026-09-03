import Foundation

/// The author of the text, and the biography shown in the About drawer.
///
/// Held in code rather than `content.json` because it is chrome around the text
/// rather than the text itself. It is structured — not one prose blob — so a
/// translation can be dropped in section by section later.
struct Author: Sendable {
    struct Section: Identifiable, Sendable {
        let id: String
        let heading: String
        let body: String
    }

    let name: String
    let tibetanName: String
    let chineseName: String
    let lifespan: String
    /// One line under the name, before the sections.
    let epithet: String
    let portraitAsset: String
    let sections: [Section]
}

extension Author {
    static let sakyaPandita = Author(
        name: "Sakya Paṇḍita Kunga Gyaltsen",
        tibetanName: "ས་སྐྱ་པཎྜི་ཏ་ཀུན་དགའ་རྒྱལ་མཚན།",
        chineseName: "薩迦班智達·貢嘎堅贊",
        lifespan: "1182 – 1251",
        epithet: "Fourth of the five founding masters of the Sakya school, and author of this collection.",
        portraitAsset: "SakyaPandita",
        sections: [
            Section(
                id: "life",
                heading: "Early life",
                body: """
                Born in 1182 at Sakya in southern Tibet, into the Khön family that had led the \
                Sakya school since its founding a century earlier. His uncle, Jetsün Drakpa \
                Gyaltsen, was his principal teacher and raised him in the family's lineage of \
                tantric practice and scholarship.
                """
            ),
            Section(
                id: "scholarship",
                heading: "Scholarship",
                body: """
                He studied Sanskrit grammar, poetics, logic and epistemology under the Kashmiri \
                master Śākyaśrībhadra and the scholars travelling with him, and took full \
                ordination from him. The title Paṇḍita — uncommon for a Tibetan of his day — \
                marks command of the five major sciences, and he was the first Tibetan widely \
                granted it.
                """
            ),
            Section(
                id: "works",
                heading: "Writings",
                body: """
                His Treasury of Valid Reasoning was the first original Tibetan treatise on \
                Buddhist epistemology rather than a commentary on an Indian one. He also wrote \
                the Discrimination of the Three Vows and the Entrance Gate for the Wise — and \
                this collection, the Jewel Treasury of Elegant Sayings.
                """
            ),
            Section(
                id: "mongols",
                heading: "The Mongol court",
                body: """
                In 1244, at sixty-two, he was summoned by the Mongol prince Köden and travelled \
                east with his young nephews Phagpa and Chana Dorje, reaching Liangzhou in 1246. \
                The arrangement he reached there became the priest–patron relationship that \
                shaped dealings between Tibet and the Mongol court for generations. He died in \
                Liangzhou in 1251.
                """
            ),
            Section(
                id: "text",
                heading: "This text",
                body: """
                The Jewel Treasury of Elegant Sayings runs to 457 verses across nine chapters, \
                written in the Indian subhāṣita tradition of pithy four-line counsel. Most \
                verses pair an observation about human conduct with an image drawn from nature \
                or from a well-known story.
                """
            )
        ]
    )
}
