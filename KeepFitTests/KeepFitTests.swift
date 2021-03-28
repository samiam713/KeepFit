//
//  KeepFitTests.swift
//  KeepFitTests
//
//  Created by Samuel Donovan on 3/19/21.
//

import XCTest
@testable import KeepFit

class KeepFitTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let result = HTTPRequester.attemptLogin(username: "cliffy", password: "4272000")
        switch result {
        case .success(let user):
            User.currentUser = user
        default:
            throw NSError()
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    // User tests
    
    // initialie User() set different heights and assert height description is correct
    func testHeightDescription() throws {
        let testUser = User()
        testUser.inches = 71
        XCTAssert(testUser.heightDescription() == "whatever it should be", "Incorrect height description")
        
        // repeat for other heights (like 72,73)
    }
    
    // initialize User(), set different weights and assert weight description is correct
    func testWeightDescription() throws {
        let testUser = User()
        testUser.pounds = 170
    }
    
    // log in user from server using HTTPRequester.attemptLogin(username: String, password: String)
    // make sure this runs "quickly" (whatever that means) using self.measure {}
    func userLoginTimeTest() throws {
        self.measure {
            HTTPRequester.attemptLogin(username: <#T##String#>, password: <#T##String#>)
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
    
    // Workout (4)
    func likeAndUnlikeVideo() {
        
        let workoutID = "CREATE ME THEN GET FROM DATABASE"
        
        // like workout using
        HTTPRequester.likeWorkout(id: <#T##String#>)
        // assert this
        User.currentUser.likedWorkoutIDs.contains(workoutID)
        
        HTTPRequester.unlikeWorkout(id: <#T##String#>)
        
        // assert this
        !User.currentUser.likedWorkoutIDs.contains(workoutID)
        
    }
    
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
