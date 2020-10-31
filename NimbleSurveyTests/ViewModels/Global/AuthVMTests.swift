//
//  AuthVMTests.swift
//  NimbleSurveyTests
//
//  Created by Mark G on 31/10/2020.
//

@testable import NimbleSurvey
import XCTest
import Mockingbird
import Promises
import Nimble

class AuthVMTests: XCTestCase {
    var viewModel: AuthVM!
    var userService: UserServiceMock!
    var authService: AuthServiceMock!
    var token: UserTokenInfo!
    var user: UserInfo!
    var userDefault: UserDefaults!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // User service
        userService = mock(UserService.self)
        locator.mock(UserService.self, userService)
        
        // Auth service
        authService = mock(AuthService.self)
        locator.mock(AuthService.self, authService)
        
        // User default
        userDefault = UserDefaults(suiteName: "test")
        locator.mock(UserDefaults.self, userDefault)
        
        // Models
        token = UserTokenInfo(
            accessToken: "access token",
            refreshToken: "refresh token",
            expiresIn: 60
        )
        user = UserInfo(
            email: "dev@nimblehq.co",
            avatarURL: try? "https://api.adorable.io/avatar/dev@nimblehq.co".asURL()
        )
        
        
        viewModel = AuthVMImpl()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        userDefault.removeObject(forKey: AuthVMImpl.rawTokenKey)
        userDefault.removeSuite(named: "test")
    }
    
    func testLoginSuccessfully() throws {
        
        // Mock
        given(
            authService.login(params: any())
        ) ~> .value(self.token)
        
        given(
            userService.me()
        ) ~> .value(self.user)
        
        // 
        let params = AuthLoginParams(email: user.email, password: "password")
        _ = viewModel.login(params: params)
        expect(self.viewModel.user).emits(user)
    }
    
    func testLoginFailure() throws {
        
        // Mock
        given(
            authService.login(params: any())
        ) ~> .error(anError)
        
        given(
            userService.me()
        ) ~> .value(self.user)
        
        //
        let params = AuthLoginParams(email: user.email, password: "password")
        
        waitUntil {
            do {
                try await(
                    self.viewModel.login(params: params)
                )
            } catch {
                expect(error).to(matchError(AuthException.invalidGrant))
            }
        }
    }

    func testRetriveWithoutToken() throws {
        waitUntil {
            try await(
                self.viewModel.retrieve()
            )
            
            expect(self.viewModel.isAuthenticated.value).to(beFalse())
        }
    }
    
    func testRetriveWithValidToken() throws {
        
        // Mock
        given(
            authService.login(params: any())
        ) ~> .value(self.token)
        
        given(
            userService.me()
        ) ~> .value(self.user)
        
        
        waitUntil {
            
            // Login
            let params = AuthLoginParams(email: self.user.email, password: "password")
            try await(
                self.viewModel.login(params: params)
            )
            
            // Retrieve auth info
            try await(
                self.viewModel.retrieve()
            )
            
            //
            expect(self.viewModel.isAuthenticated.value).to(beTrue())
            expect(self.viewModel.user.value).to(equal(self.user))
        }
    }

}