import ReactiveSwift
import Combine

extension Publisher {
    func signal() -> Signal<Output, Failure> {
        Signal { observer, lifetime in
            let cancellable = sink { completion in
                switch completion {
                case .failure(let error):
                    observer.send(error: error)
                case .finished:
                    observer.sendCompleted()
                }
            } receiveValue: { output in
                observer.send(value: output)
            }

            lifetime.observeEnded {
                cancellable.cancel()
            }
        }
    }

    func signalProducer() -> SignalProducer<Output, Failure> {
        SignalProducer { observer, lifetime in
            let cancellable = sink { completion in
                switch completion {
                case .failure(let error):
                    observer.send(error: error)
                case .finished:
                    observer.sendCompleted()
                }
            } receiveValue: { output in
                observer.send(value: output)
            }

            lifetime.observeEnded {
                cancellable.cancel()
            }
        }
    }
}

extension Signal {
    func publisher() -> AnyPublisher<Value, Error> {
        ReactiveSwiftPublisher(signalProducer: producer)
            .eraseToAnyPublisher()
    }
}

extension SignalProducer {
    func publisher() -> AnyPublisher<Value, Error> {
        ReactiveSwiftPublisher(signalProducer: self)
            .eraseToAnyPublisher()
    }
}
