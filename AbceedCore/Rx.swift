import RxSwift

extension ObservableType {

    /// onErrorをnil化
    /// - Note: `.completed` 自体は流れる
    public func optionalizeError() -> Observable<Element?> {
        return materialize()
            .filter { !$0.isCompleted } // `.next(.completed)` は無視
            .map { $0.element }         // `.next(.next(element))` をflatten、 `.next(.error(someError))` は nil化
    }
}
