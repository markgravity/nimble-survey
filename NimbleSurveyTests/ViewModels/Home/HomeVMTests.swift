//
//  HomeVMTests.swift
//  NimbleSurveyTests
//
//  Created by Mark G on 01/11/2020.
//

@testable import NimbleSurvey
import XCTest
import Mockingbird
import Promises
import Nimble

class HomeVMTests: XCTestCase {
    var surveyService: SurveyServiceMock!
    var dateService: DateServiceMock!
    var timerService: TimerServiceMock!
    
    var viewModel: HomeVM!
    var userDefault: UserDefaults!
    var items: [SurveyInfo]!
    var cachedItems: [SurveyInfo]!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // Survey Service
        surveyService = mock(SurveyService.self)
        locator.mock(SurveyService.self, surveyService)
        
        // Date Service
        dateService = mock(DateService.self)
        locator.mock(DateService.self, dateService)
        
        // Timer Service
        timerService = mock(TimerService.self)
        locator.mock(TimerService.self, timerService)
        
        // User Default
        userDefault = UserDefaults(suiteName: "test")
        locator.mock(UserDefaults.self, userDefault)
        
        // Items
        items = [
            SurveyInfo(
                title: "1",
                description: "1",
                coverImageURL: URL(string: "http://1.com")
            ),
            SurveyInfo(
                title: "2",
                description: "2",
                coverImageURL: URL(string: "http://2.com")
            )
        ]
        
        // Cached Items
        cachedItems = [
            SurveyInfo(
                title: "1",
                description: "1",
                coverImageURL: URL(string: "http://1.com")
            ),
            SurveyInfo(
                title: "3",
                description: "3",
                coverImageURL: URL(string: "http://3.com")
            )
        ]
        
        // For tick that called
        // at the init
        given(
            dateService.now()
        ) ~> Date()
        
        given(
            timerService.scheduledTimer(
                withTimeInterval: any(),
                repeats: any(),
                block: any()
            )
        ) ~> Timer()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        userDefault.removeObject(forKey: HomeVMImpl.cachedRawItemsKey)
        userDefault.removeSuite(named: "test")
    }

    /// Refresh without cached
    func testRefreshWithoutCached() throws {
        
        viewModel = HomeVMImpl()
        
        // Mock
        let response = ListResponse<SurveyInfo>(items: items)
        given(
            surveyService.list(params: any())
        ) ~> .value(response)
        
        
        _ = viewModel.refresh(force: true)
        
        expect(self.viewModel.items).emits(items)
    }
    
    /// Refresh with cached available
    func testRefreshWithCached() throws {
        
        viewModel = HomeVMImpl()
        
        // Mock
        userDefault.setValue(cachedItems.toJSONString()!, forKey: HomeVMImpl.cachedRawItemsKey)
        
        
        _ = viewModel.refresh(force: false)
        
        expect(self.viewModel.items).emits(cachedItems)
    }
    
    /// Force to refresh
    /// even cached available
    func testForceRefreshWhileCachedAvailable() throws {
        
        viewModel = HomeVMImpl()
        
        // Mock
        userDefault.setValue(cachedItems.toJSONString()!, forKey: HomeVMImpl.cachedRawItemsKey)
        
        let response = ListResponse<SurveyInfo>(items: items)
        given(
            surveyService.list(params: any())
        ) ~> .value(response)
        
        // Excute
        _ = viewModel.refresh(force: true)
        
        expect(self.viewModel.items).emits(items)
    }
    
    /// Focus index should be reseted
    /// when it's out of bounds
    /// in new refreshed items
    func testFocusIndexWhenOutOfBoundsInNewItems() {
        
        viewModel = HomeVMImpl()
        
        // Mock
        let response = ListResponse<SurveyInfo>(items: items)
        given(
            surveyService.list(params: any())
        ) ~> .value(response)
        
        // Excute
        waitUntil {
            try await(
                self.viewModel.refresh(force: true)
            )
            
            // Set focus index to 1
            self.viewModel.setFocusIndex(1)
            
            // Mock another items
            var smallerItems = self.items!
            smallerItems.remove(at: 1)
            
            let response = ListResponse<SurveyInfo>(items: smallerItems)
            given(
                self.surveyService.list(params: any())
            ) ~> .value(response)
            
            // Refresh again
            try await(
                self.viewModel.refresh(force: true)
            )
            
            // Expect
            expect(self.viewModel.focusIndex.value)
                .to(equal(0))
        }
    }
    
    /// Focus index should be retain
    /// when it not out of bounds
    /// in new refreshed items
    func testFocusIndexWhenNotOutOfBoundsInNewItems() {
        
        viewModel = HomeVMImpl()
        
        // Mock
        let response = ListResponse<SurveyInfo>(items: items)
        given(
            surveyService.list(params: any())
        ) ~> .value(response)
        
        // Excute
        waitUntil {
            try await(
                self.viewModel.refresh(force: true)
            )
            
            // Set focus index to 1
            self.viewModel.setFocusIndex(1)
            
            // Mock another items
            let response = ListResponse<SurveyInfo>(items: self.cachedItems)
            given(
                self.surveyService.list(params: any())
            ) ~> .value(response)
            
            // Refresh again
            try await(
                self.viewModel.refresh(force: true)
            )
            
            // Expect
            expect(self.viewModel.focusIndex.value)
                .to(equal(1))
        }
    }
    
    func testCurrentDateText() {
        
        // Mock
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: "2020-06-15")!
        given(
            dateService.now()
        ) ~> date
        
        viewModel = HomeVMImpl()
        expect(self.viewModel.currentDateText)
            .emits("MONDAY, JUNE 15")
    }
    
    /// A new text should be update
    /// after start of the next day
    func testCurrentDateTextUpdated() {
        
        // Mock
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: "2020-06-15 00:00:01")!
        given(
            dateService.now()
        ) ~> date
        
        // Excute
        viewModel = HomeVMImpl()
        
        // Capture interval
        let timeIntervalCaptor = ArgumentCaptor<TimeInterval>()
        verify(
            timerService.scheduledTimer(
                withTimeInterval: timeIntervalCaptor.matcher,
                repeats: any(),
                block: any()
            )
        ).wasCalled()
        
        expect(timeIntervalCaptor.value)
            .to(equal(86400))
    }

    func testFocusItem() {
        
        viewModel = HomeVMImpl()
        
        // Mock
        let response = ListResponse<SurveyInfo>(items: items)
        given(
            surveyService.list(params: any())
        ) ~> .value(response)
        
        // Nil
        expect(self.viewModel.focusItem)
            .emits(nil)
        
        // Refresh
        _ = viewModel.refresh(force: true)
        expect(self.viewModel.focusItem)
            .emits(items[0])
        
        // Change focus index
        viewModel.setFocusIndex(1)
        expect(self.viewModel.focusItem)
            .emits(items[1])
        
        // Change focus index to out of bounds
        viewModel.setFocusIndex(3)
        expect(self.viewModel.focusItem)
            .emits(nil)
    }
}
