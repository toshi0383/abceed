import AbceedCore

public final class BookDetailUseCaseImpl: BookDetailUseCase {

    private let mybookRepository: MybookRepository

    public init(mybookRepository: MybookRepository) {
        self.mybookRepository = mybookRepository
    }

    public func isMybook(_ bookID: String) -> AbceedCore.Property<Bool> {
        return mybookRepository.isMybook(bookID)
    }

    public func registerMybook(_ bookID: String) {
        return mybookRepository.registerMybook(bookID)
    }

    public func unregisterMybook(_ bookID: String) {
        return mybookRepository.unregisterMybook(bookID)
    }
}
