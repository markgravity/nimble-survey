//
//  LoginVMTests.swift
//  NimbleSurveyTests
//
//  Created by Mark G on 31/10/2020.
//

@testable import NimbleSurvey
import XCTest
import Mockingbird
import Promises
import Nimble

class LoginVMTests: XCTestCase {
    var authVM: AuthVMMock!
    var viewModel: LoginVM!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        authVM = mock(AuthVM.self)
        locator.mock(AuthVM.self, authVM)
        
        viewModel = LoginVMImpl()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        reset(authVM)
        
    }

    func testInitialState() throws {
        expect(self.viewModel.isValid)
            .emits(beFalse())
    }
    
    func testLoginSuccessfully() throws {
        
        // Mock
        given(
            authVM.login(params: any())
        ) ~> .success()
        
        _ = viewModel.login()
        
        expect(self.viewModel.state)
            .emits(
                inOrder(
                    .initial,
                    .logging,
                    .logged
                )
            )
    }
    
    func testLoginFailure() throws {
        
        // Mock
        given(
            authVM.login(params: any())
        ) ~> .error(anError)
        
        _ = viewModel.login()
        
        expect(self.viewModel.state)
            .emits(
                inOrder(
                    .initial,
                    .logging,
                    .error(anError),
                    .initial
                )
            )
    }
    
    /// TODO: Write test
    func testLogingWhileNotInInititalState() {
        
    }
    
    func testIsValid() {
        
        // All nil
        viewModel.setEmail(nil)
        viewModel.setPassword(nil)
        expect(self.viewModel.isValid)
            .emits(beFalse())
        
        // One nil
        viewModel.setEmail(nil)
        viewModel.setPassword("password")
        expect(self.viewModel.isValid)
            .emits(beFalse())
        
        viewModel.setEmail("email")
        viewModel.setPassword(nil)
        expect(self.viewModel.isValid)
            .emits(beFalse())
        
        // All non-nil
        viewModel.setEmail("email")
        viewModel.setPassword("password")
        expect(self.viewModel.isValid)
            .emits(beTrue())
    }

}
