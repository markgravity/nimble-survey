//
//  ApiRegisterTests.swift
//  NimbleSurveyTests
//
//  Created by Mark G on 02/11/2020.
//

@testable import NimbleSurvey
import XCTest
import Mockingbird
import Promises
import Nimble
import SwiftyBase

class ApiRegisterTests: XCTestCase {
    var authVM: AuthVMMock!
    var register: ApiRegister!
    var invalidTokenError: ApiException!
    var data: Data!
    var request: RequestHandler!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        authVM = mock(AuthVM.self)
        locator.mock(AuthVM.self, authVM)
        
        // Invalid Token Error
        let error = ApiError(
            source: .unauthorized,
            code: .invalidToken,
            detail: ""
        )
        let errorBag = ApiErrorBag(errors: [error])
        invalidTokenError = ApiException.other(bag: errorBag)
        
        // Request
        let data = "the data".data(using: .utf8)!
        request = {
            Promise<Data>.value(data)
        }
        self.data = data
        
        register = ApiRegister()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /// Refreshing token by using
    /// a retry policy through `ApiConfigs.retry`
    func testRefreshTokenSuccessfully() throws {
        
        // Mock
        given(
            authVM.refreshToken()
        ) ~> .success()
        
        // Simulate a request
        // with invalid token error
        waitUntil {
            let theData = try ApiConfigs.retry(
                self.invalidTokenError,
                self.request,
                ""
            )
            
            expect(theData)
                .to(equal(self.data))
        }
    }
    
    func testRefreshTokenFailure() throws {
        
        // Mock
        given(
            authVM.refreshToken()
        ) ~> .error(anError)
        
        given(
            authVM.logout()
        ) ~> .success()
        
        given(
            authVM.getIsAuthenticated()
        ) ~> .init(true)
        
        // Simulate a request
        // with invalid token error
        waitUntil {
            do {
                _ = try ApiConfigs.retry(
                    self.invalidTokenError,
                    self.request,
                    ""
                )
            } catch {
             
                expect(error).to(
                    matchError(self.invalidTokenError)
                )
                verify(self.authVM.logout())
                    .wasCalled()
            }
        }
    }

    /// Normally, only the first request with
    /// invalid token error will trigger refreshing token
    /// For the others, it will be waited until
    /// the first refreshing token completed,
    /// thenn retry the request
    func testMassiveRequestWithInvalidTokenError() throws {
        
        // Mock
        given(
            authVM.refreshToken()
        ) ~> .success()
        
        waitUntil(timeout: 5) {
            
            // Run requests
            let numbersOfRequests = 50
            let queue = DispatchQueue(label: "request", attributes: .concurrent)
            let dispatchGroup = DispatchGroup()
            
            for _ in 1...numbersOfRequests {
                
                dispatchGroup.enter()
                queue.async {
                    defer {
                        dispatchGroup.leave()
                    }
                    
                    // Retry
                    _ = try? ApiConfigs.retry(
                        self.invalidTokenError,
                        self.request,
                        ""
                    )
                }
            }
            
            dispatchGroup.wait()
            verify(self.authVM.refreshToken())
                .wasCalled(exactly(1))
            
            verify(self.authVM.logout())
                .wasNeverCalled()
        }
        
        
        
    }
}
