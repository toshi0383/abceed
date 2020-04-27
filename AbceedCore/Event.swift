public protocol EventType { }

public struct SelectBook: EventType {
    public let book: Book
    public init(_ book: Book) {
        self.book = book
    }
}
