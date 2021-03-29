//
//  KeepFitTests.swift
//  KeepFitTests
//
//  Created by Samuel Donovan on 3/19/21.
//

//NOT USING THIS FILE – USE KeepFitRealUITests.swift

import XCTest
@testable import KeepFit

class KeepFitTests: XCTestCase {

    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//        let result = HTTPRequester.attemptLogin(username: "cliffy", password: "4272000")
//        switch result {
//        case .success(let user):
//            User.currentUser = user
//        default:
//            throw NSError()
//        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testThis() throws
    {
        let app = XCUIApplication()
        app.launch()
    }
    // User tests
    
    // initialie User() set different heights and assert height description is correct
    func testHeightDescription() throws {
        let testUser = User()
        testUser.inches = 71
        XCTAssertEqual(testUser.heightDescription(), "Height: 5' 11\"")
        
        // repeat for other heights (like 72,73)
    }
    
    // initialize User(), set different weights and assert weight description is correct
    func testWeightDescription() throws {
        let testUser = User()
        testUser.pounds = 170
        XCTAssertEqual(testUser.weightDescription(), "Weight: 170 lbs")
    }
    
    // initialize User(), set different birthdays and assert birthday description is correct
    func testBirthdate() throws {
        let testUser = User()
        testUser.birthdate = Date()
        XCTAssertEqual(testUser.birthdate, Date())
    }
    
    // initialize User(), set different birthdays and assert birthday description is correct
    func testBioDescription() throws {
        let testUser = User()
        testUser.shortBiography = "Bio!@#$%^&*()-=_+"
        XCTAssertEqual(testUser.shortBiography, "Bio!@#$%^&*()-=_+")
    }
    
    // initialize Workout(), set different categories and assert category is correct
    func testCatgegories() throws {
        let testWorkout = Workout()
        testWorkout.category = WorkoutCategory.Aerobics
        XCTAssertEqual(testWorkout.category, WorkoutCategory.Aerobics)
    }
    
    // initialize Workout(), set different categories and assert category is correct
//    func testSearch() throws {
//        let testWorkout = SearchView()
//        testWorkout =
//        XCTAssertEqual(testWorkout.category, WorkoutCategory.Aerobics)
//    }
//
    // log in user from server using HTTPRequester.attemptLogin(username: String, password: String)
    // make sure this runs "quickly" (whatever that means) using self.measure {}
    func userLoginTimeTest() throws {
        self.measure {
            HTTPRequester.attemptLogin(username: "cliffy", password: "4272000")
        }
    }
    
    // register a user with random name
    func createUserThenLogin() throws {
        // register a user with random username
        let user = User()
        user.username = "XCTestUser\(Int.random(in: 0...9999))"
        user.password = "password"
        
        // register this user using HTTPRequester.registerUser
        
        // now, try and login as this user using HTTPRequester.attemptLogin
    }
    
//     Workout (4)
//    func likeAndUnlikeVideo() {
//
//
//        let workoutID = "2B607F61-F409-4C87-A962-63879BDF712D"
//
//        // like workout using
//        HTTPRequester.likeWorkout(id: "2B607F61-F409-4C87-A962-63879BDF712D")
//        // assert this
//        User.currentUser.likedWorkoutIDs.contains("2B607F61-F409-4C87-A962-63879BDF712D")
//
//        HTTPRequester.unlikeWorkout(id: "2B607F61-F409-4C87-A962-63879BDF712D")
//
//        // assert this
//        !User.currentUser.likedWorkoutIDs.contains("2B607F61-F409-4C87-A962-63879BDF712D")
//
//    }
//
    // two WorkoutSession tests (4)
    
    // two UserPreview tests (3)
    
    // THESE WERE ALREADY IN THIS FILE
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
