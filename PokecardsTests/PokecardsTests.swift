//
//  PokecardsTests.swift
//  PokecardsTests
//
//  Created by abdulk on 03/08/2022.
//

import XCTest
@testable import Pokecards

class PokecardsTests: XCTestCase {
    private var viewModel: PokemonViewModel!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = PokemonViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }

    func testFlip() throws {
        viewModel.flipCard()
        
        Timer.scheduledTimer(withTimeInterval: PokeConstants.animationTime, repeats: false) { [weak self] _ in
            guard let self = self else {return}
            let expectedFrontIndex = 2
            let expectedBackIndex = 1
            
            XCTAssertFalse(self.viewModel.isFront)
            XCTAssertEqual(self.viewModel.frontIndex, expectedFrontIndex)
            XCTAssertEqual(self.viewModel.backIndex, expectedBackIndex)
        }
    }

    func testRestart() throws {
        viewModel.frontIndex = 10; viewModel.backIndex = 11
        viewModel.restart()
        
        let expectedFrontIndex = 0
        let expectedBackIndex = 1
        
        XCTAssertEqual(viewModel.frontIndex, expectedFrontIndex)
        XCTAssertEqual(viewModel.backIndex, expectedBackIndex)
        XCTAssertTrue(viewModel.isFront)
    }
}
