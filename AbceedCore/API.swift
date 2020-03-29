import Foundation
import RxCocoa
import RxSwift

public func requestMockBookAll() -> Observable<MockBookAllResponse> {
    let url = URL(string: "https://2zw3cqudp7.execute-api.ap-northeast-1.amazonaws.com/dev//mock/book/all")!
    let req = URLRequest(url: url)
    return URLSession.shared.rx.data(request: req)
        .flatMap { data -> Observable<MockBookAllResponse> in
            let decoder = JSONDecoder()
            return .just(try decoder.decode(MockBookAllResponse.self, from: data))
        }
}

public struct MockBookAllResponse: Decodable, Equatable {
    public let topCategories: [TopCategory]

    enum CodingKeys: String, CodingKey {
        case topCategories = "top_category_list"
    }
}

public struct TopCategory: Decodable, Hashable, Identifiable {
    public let id: String
    public let name: String
    public let subCategories: [Category]

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(subCategories)
    }

    enum CodingKeys: String, CodingKey {
        case id = "id_top_category"
        case name = "name_category"
        case subCategories = "sub_category_list"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        subCategories = try values.decode([Category].self, forKey: .subCategories)
    }
}

public struct Category: Decodable, Hashable, Identifiable {
    public let id: String
    public let name: String
    public let books: [Book]

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(books)
    }

    enum CodingKeys: String, CodingKey {
        case id = "id_category"
        case name = "name_category"
        case books = "book_list"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        books = try values.decode([Book].self, forKey: .books)
    }
}

public struct Book: Decodable, Hashable, Identifiable {
    public let id: String
    public let name: String
    public let publisher: String
    public let author: String
    public let imgURL: String

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(publisher)
        hasher.combine(author)
        hasher.combine(imgURL)
    }

    enum CodingKeys: String, CodingKey {
        case id = "id_book"
        case name = "name_book"
        case publisher = "publisher"
        case author = "author"
        case imgURL = "img_url"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        publisher = try values.decode(String.self, forKey: .publisher)
        author = try values.decode(String.self, forKey: .author)
        imgURL = try values.decode(String.self, forKey: .imgURL)
    }
}
