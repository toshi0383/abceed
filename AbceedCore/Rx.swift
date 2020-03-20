import RxSwift
import UIKit

extension ObservableType {

    /// onErrorをnil化
    /// - Note: `.completed` 自体は流れる
    public func optionalizeError() -> Observable<Element?> {
        return materialize()
            .filter { !$0.isCompleted } // `.next(.completed)` は無視
            .map { $0.element }         // `.next(.next(element))` をflatten、 `.next(.error(someError))` は nil化
    }
}

extension Reactive where Base: UIView {
    public var tapGesture: Observable<Void> {
        objc_sync_enter(self)
        let tapGesture: UITapGestureRecognizer
        if let gesture = base.gestureRecognizers?.compactMap({ $0 as? UITapGestureRecognizer }).first {
            tapGesture = gesture
        } else {
            tapGesture = UITapGestureRecognizer()
            base.addGestureRecognizer(tapGesture)
        }
        objc_sync_exit(self)

        return tapGesture.rx.event.map { _ in }
    }

}
