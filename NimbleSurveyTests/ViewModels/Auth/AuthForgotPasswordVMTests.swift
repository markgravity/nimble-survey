//
//  AuthForgotPasswordVMTests.swift
//  NimbleSurveyTests
//
//  Created by Mark G on 31/10/2020.
//

@testable import NimbleSurvey
import XCTest
import Mockingbird
import Promises
import Nimble

class AuthForgotPasswordVMTests: XCTestCase {
    var authVM: AuthVMMock!
    var viewModel: AuthForgotPasswordVM!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        authVM = mock(AuthVM.self)
        locator.mock(AuthVM.self, authVM)
        
        viewModel = AuthForgotPasswordVMImpl()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        reset(authVM)
    }

    func testInitialState() throws {
        expect(self.viewModel.isValid)
            .emits(beFalse())
    }
    
    func testResetSuccessfully() throws {
        
        // Mock
        given(
            authVM.forgotPassword(params: any())
        ) ~> .success()
        
        _ = viewModel.reset()
        
        expect(self.viewModel.state)
            .emits(
                inOrder(
                    .initial,
                    .resetting,
                    .resetted,
                    .initial
                )
            )
    }
    
    func testLoginFailure() throws {
        
        // Mock
        given(
            authVM.forgotPassword(params: any())
        ) ~> .error(anError)
        
        _ = viewModel.reset()
        
        expect(self.viewModel.state)
            .emits(
                inOrder(
                    .initial,
                    .resetting,
                    .error(anError),
                    .initial
                )
            )
    }
    
    /// TODO: Write test
    func testLogingWhileNotInInititalState() {
        
    }
    
    func testIsValid() {
        
        // Email is nil
        viewModel.setEmail(nil)
        expect(self.viewModel.isValid)
            .emits(beFalse())
        
        // Email is not nil
        viewModel.setEmail("email")
        expect(self.viewModel.isValid)
            .emits(beTrue())
    }

}
