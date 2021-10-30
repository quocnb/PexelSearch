//
//  PexelSearchTests.swift
//  PexelSearchTests
//
//  Created by quocnb on 2021/10/31.
//

import XCTest
import RxSwift
@testable import PexelSearch

class PexelSearchTests: XCTestCase {
    let bag = DisposeBag()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearchPhotos() throws {
        Connector.searchPhotos(keyword: "hello", page: 1).subscribe(onNext: { searchResult in
            XCTAssertTrue(searchResult.photos.count > 0)
        }).disposed(by: bag)
    }

}
