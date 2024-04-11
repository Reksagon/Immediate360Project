import Foundation

struct NewsResponse: Codable {
    let totalArticles: Int
    let articles: [Article]
}

struct Article: Codable {
    let title: String
    let description: String
    let content: String
    let url: URL
    let image: URL
    let publishedAt: String
    let source: Source
}

struct Source: Codable {
    let name: String
    let url: URL
}
