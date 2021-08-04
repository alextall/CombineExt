import Combine

extension Publisher {
    func asResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        return map(Result.success)
            .catch { Just(Result.failure($0)) }
            .eraseToAnyPublisher()
    }
}

extension Publisher {
    func values<S, F: Error>() -> AnyPublisher<S, Never> where Output == Result<S, F>, Failure == Never {
        return flatMap { (result) -> AnyPublisher<S, Never> in
            switch result {
            case .success(let value):
                return Just(value).eraseToAnyPublisher()

            case .failure:
                return Empty().eraseToAnyPublisher()
            }
        }.eraseToAnyPublisher()
    }

    func errors<S, F: Error>() -> AnyPublisher<F, Never> where Output == Result<S, F>, Failure == Never {
        return flatMap { (result) -> AnyPublisher<F, Never> in
            switch result {
            case .success:
                return Empty().eraseToAnyPublisher()

            case .failure(let error):
                return Just(error).eraseToAnyPublisher()
            }
        }.eraseToAnyPublisher()
    }
}
