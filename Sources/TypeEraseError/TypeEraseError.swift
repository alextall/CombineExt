import Combine

extension Publisher {
    public func eraseToAnyError() -> Publishers.MapError<Self, Error> {
        mapError { $0 as Error }
    }
}
