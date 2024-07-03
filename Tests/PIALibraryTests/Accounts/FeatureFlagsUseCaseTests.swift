
import XCTest
@testable import PIALibrary

class FeatureFlagsUseCaseTests: XCTestCase {
    class Fixture {
        let networkClientMock = NetworkRequestClientMock()
        let refreshAutTokensCheckerMock = RefreshAuthTokensCheckerMock()
        
        
        // TODO: Add stub methods
    }
    
    var fixture: Fixture!
    var sut: FeatureFlagsUseCase!
    
    override func setUp() {
        fixture = Fixture()
    }
    
    override func tearDown() {
        fixture = nil
        sut = nil
    }
    
    private func instantiateSut() {
        sut = FeatureFlagsUseCase(networkClient: fixture.networkClientMock, refreshAuthTokensChecker: fixture.refreshAutTokensCheckerMock)
    }
    
    func test_get_feature_flags_successfully() {
        
    }
    
    
    func test_get_feature_flags_when_network_error() {
        
    }
    
    func test_get_feature_flags_when_refresh_tokens_error() {
        
    }
}
