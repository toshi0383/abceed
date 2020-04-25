import AbceedCore
import Foundation
import UIKit
import RxRelay
import RxSwift

public typealias Event = AbceedCore.Event

public final class EventRepositoryImpl: EventRepository {
    public let event: Observable<Event>
    public let _event = PublishRelay<Event>()

    init() {
        self.event = _event.asObservable()
    }

    public func accept(_ event: Event) {
        _event.accept(event)
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
