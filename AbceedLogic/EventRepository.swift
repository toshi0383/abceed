import AbceedCore
import Foundation
import UIKit
import RxRelay
import RxSwift

public typealias Event = AbceedCore.EventType

public final class EventRepositoryImpl: EventRepository {
    public let _event = PublishRelay<Event>()

    init() {
    }

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

public final class EventRepositoryPool {
    public static let shared = EventRepositoryPool()

    private var map: [Int: EventRepositoryImpl] = [:]

    init() {
        NotificationCenter.default.addObserver(forName: UIScene.didEnterBackgroundNotification, object: nil, queue: nil) { not in
            print("enterBG: \(self.map.count)")
        }
        NotificationCenter.default.addObserver(forName: UIScene.didDisconnectNotification, object: nil, queue: nil) { not in

            print("disconnected")

            guard let scene = not.object as? UIWindowScene else {
                fatalError()
            }

            self.map.removeValue(forKey: scene.hashValue)
        }
    }

    public func getEventRepository(forScene scene: NSObject) -> EventRepositoryImpl {

        if let r = map[scene.hashValue] { return r }

        let r = EventRepositoryImpl()
        map[scene.hashValue] = r

        return r
    }
}
