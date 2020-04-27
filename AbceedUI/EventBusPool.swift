import AbceedCore
import UIKit

public final class EventBusPool {
    public static let shared = EventBusPool()

    private var map: [Int: EventBusImpl] = [:]

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

    public func getEventBus(forScene scene: NSObject) -> EventBusImpl {

        if let r = map[scene.hashValue] { return r }

        let r = EventBusImpl()
        map[scene.hashValue] = r

        return r
    }
}
