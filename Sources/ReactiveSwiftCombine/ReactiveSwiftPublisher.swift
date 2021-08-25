import Combine
import ReactiveSwift

struct ReactiveSwiftPublisher<Output, Failure: Error>: Publisher {

    private let signalProducer: SignalProducer<Output, Failure>

    init(signalProducer: SignalProducer<Output, Failure>) {
        self.signalProducer = signalProducer
    }

    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        let subscription = ReactiveSwiftSubscription(signalProducer: signalProducer, subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}

class ReactiveSwiftSubscription<S, Output, Failure>: Subscription where S: Subscriber, S.Input == Output, S.Failure == Failure {

    private let signalProducer: SignalProducer<Output, Failure>

    private let subscriber: S
    private let disposable: Disposable

    init(signalProducer: SignalProducer<Output, Failure>, subscriber: S) {
        self.signalProducer = signalProducer
        self.subscriber = subscriber

        disposable = signalProducer.start { [subscriber] event in
            switch event {
            case .interrupted: subscriber.receive(completion: .finished)
            case .completed: subscriber.receive(completion: .finished)
            case .failed(let error): subscriber.receive(completion: .failure(error))
            case .value(let value): _ = subscriber.receive(value)
            }
        }
    }

    func request(_ demand: Subscribers.Demand) { }

    func cancel() {
        disposable.dispose()
    }
}
