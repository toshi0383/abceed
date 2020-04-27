import Foundation
import RxRelay
import RxSwift

public typealias Event = EventType

public final class EventBusImpl: EventBus {
    public let _event = PublishRelay<Event>()

    public init() {}

    public func accept(_ event: Event) {
        _event.accept(event)
    }

    public func observe<T>(_ eventType: T.Type) -> Observable<T> {
        return _event.asObservable()
            .flatMap { (e: Event) -> Observable<T> in
                e is T ? .just(e as! T) : .empty()
            }
    }
}
