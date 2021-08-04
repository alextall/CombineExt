import Combine
@testable import TypeEraseError
import XCTest

final class TypeEraseErrorTests: XCTestCase {
    enum MockError: Error {
        case test
    }

    var expectation: XCTestExpectation!
    var bag: Set<AnyCancellable>!

    override func setUp() {
        bag = .init()
        expectation = expectation(description: "Expectation")
    }

    override func tearDown() {
        bag.forEach { $0.cancel() }
        bag = nil
        expectation = nil
    }

    func testEraseError() {
        Fail(error: MockError.test)
            .eraseToAnyError()
            .sink { completion in
                switch completion {
                case .finished:
                    XCTAssertFalse(true, "Publisher should not complete successfully.")
                case .failure(let error):
                    XCTAssert(error.self is Error)
                }

                self.expectation.fulfill()
            } receiveValue: {
                XCTAssertFalse(true, "Publisher should not emit values .")
            }
            .store(in: &bag)

        wait(for: [expectation], timeout: 1)
    }
}
