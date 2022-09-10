//
//  TransactionListViewModelTests.swift
//  CBATests
//
//  Created by Aravind R on 18/09/21.
//

@testable import CBA
import XCTest

final class TransactionListViewModelTests: XCTestCase {
    
    private var mockDate: Date!
    private var mockTransactionService: MockTransactionService!
    private var mockCoordinatorDelegate: MockTransactionListViewModelCoordinatorDelegate!
    private var viewModel: TransactionListViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        let calendar = Calendar.australia
        let dateComponents = DateComponents(calendar: calendar, year: 2021, month: 9, day: 19)
        mockDate = calendar.date(from: dateComponents)

        mockTransactionService = MockTransactionService()
        mockCoordinatorDelegate = MockTransactionListViewModelCoordinatorDelegate()
        
        viewModel = TransactionListViewModel(service: mockTransactionService)
        viewModel.coordinatorDelegate = mockCoordinatorDelegate
    }

    override func tearDownWithError() throws {
        mockDate = nil
        mockTransactionService = nil
        mockCoordinatorDelegate = nil
        viewModel = nil
        
        try super.tearDownWithError()
    }

    func testScreenTitleText() {
        XCTAssertEqual(viewModel.screenTitleText, "Account Details")
    }

    func testBackButtonText() {
        XCTAssertEqual(viewModel.backButtonText, "Back")
    }

    func testSectionViewModelsNumberOfSectionsAfterInit() {
        XCTAssertEqual(viewModel.sections.count, 1)
    }

    func testSectionViewModelsGetNumberOfRowsForSectionAfterInit() {
        XCTAssertEqual(viewModel.getNumberOfRowsForSection(0), 1)
    }

    func testSectionViewModelsAfterInit() {
        // Verify section 0 - Loading Section
        XCTAssertEqual(viewModel.sections.count, 1)
        switch viewModel.sections[0] {
        case .loading:
            // Success
            break
        default:
            XCTFail("EXpected a Loading cell")
        }
    }

    func testNumberOfSectionsAfterFetchTransactionSuccess() {
        // Given
        mockTransactionService.resultToReturn = .success(transactionResponse)
        
        // When
        viewModel.fetchTransaction()
        
        // Then
        XCTAssertEqual(viewModel.sections.count, 4)
    }

    func testNumberOfCellsAfterFetchTransactionSuccess() {
        // Given
        mockTransactionService.resultToReturn = .success(transactionResponse)
        
        // When
        viewModel.fetchTransaction()
        
        // Then
        XCTAssertEqual(viewModel.getNumberOfRowsForSection(0), 1)
        XCTAssertEqual(viewModel.getNumberOfRowsForSection(1), 2)
        XCTAssertEqual(viewModel.getNumberOfRowsForSection(2), 1)
        XCTAssertEqual(viewModel.getNumberOfRowsForSection(3), 1)
    }
    
    func testSectionViewModelsAfterFetchTransactionSuccess() {
        // Given
        mockTransactionService.resultToReturn = .success(transactionResponse)
        
        // When
        viewModel.fetchTransaction()
        
        // Then
        // Verify section 0 - Account Detail
        switch viewModel.sections[0] {
        case .accountDetail(let accountDetailCellViewModel):
            XCTAssertNotNil(accountDetailCellViewModel)
        default:
            XCTFail("Expected a Account Detail Cell ViewModel")
        }

        // Verify section 1 - Transactions
        switch viewModel.sections[1] {
        case .transaction(let firstTransactionSection):
            XCTAssertNotNil(firstTransactionSection)
        default:
            XCTFail("Expected a Transaction Section ViewModel")
        }
        
        // Verify section 2 - Transactions
        switch viewModel.sections[2] {
        case .transaction(let secondTransactionSection):
            XCTAssertNotNil(secondTransactionSection)
        default:
            XCTFail("Expected a Transaction Section ViewModel")
        }

        // Verify section 3 - Transactions
        switch viewModel.sections[3] {
        case .transaction(let thirdTransactionSection):
            XCTAssertNotNil(thirdTransactionSection)
        default:
            XCTFail("Expected a Transaction Section ViewModel")
        }
    }

    func testCellViewModelsAfterFetchTransactionSuccess() {
        // Given
        mockTransactionService.resultToReturn = .success(transactionResponse)
        
        // When
        viewModel.fetchTransaction()
        
        // Then
        
        // Verify section 0, row 0 - Account Detail
        switch viewModel.sections[0] {
        case .accountDetail(let accountDetailCellViewModel):
            XCTAssertNotNil(accountDetailCellViewModel)
        default:
            XCTFail("Expected a Account Detail Cell ViewModel")
        }

        // Verify section 1, row 0 & 1 - Transactions
        switch viewModel.sections[1] {
        case .transaction(let firstTransactionSection):
            let cellViewModelAtSection1Row0 = firstTransactionSection.cellViewModels[0]
            XCTAssertNotNil(cellViewModelAtSection1Row0)
            XCTAssertEqual(cellViewModelAtSection1Row0.transactionDetailText.string, "Coles shopping")
            XCTAssertNil(cellViewModelAtSection1Row0.transaction.atmId)
            
            let cellViewModelAtSection1Row1 = firstTransactionSection.cellViewModels[1]
            XCTAssertNotNil(cellViewModelAtSection1Row1)
            XCTAssertEqual(cellViewModelAtSection1Row1.transactionDetailText.string, "PENDING: ATM withdrawal")
            XCTAssertNotNil(cellViewModelAtSection1Row1.transaction.atmId)
        default:
            XCTFail("Expected a Transaction Section ViewModel")
        }
        
        // Verify section 2, row 0 - Transactions
        switch viewModel.sections[2] {
        case .transaction(let secondTransactionSection):
            let cellViewModelAtSection2Row0 = secondTransactionSection.cellViewModels[0]
            XCTAssertNotNil(cellViewModelAtSection2Row0)
            XCTAssertEqual(cellViewModelAtSection2Row0.transactionDetailText.string, "Food - Uber Eats")
            XCTAssertNil(cellViewModelAtSection2Row0.transaction.atmId)
        default:
            XCTFail("Expected a Transaction Section ViewModel")
        }
        
        // Verify section 3, row 0 - Transactions
        switch viewModel.sections[3] {
        case .transaction(let thirdTransactionSection):
            let cellViewModelAtSection3Row0 = thirdTransactionSection.cellViewModels[0]
            XCTAssertNotNil(cellViewModelAtSection3Row0)
            XCTAssertEqual(cellViewModelAtSection3Row0.transactionDetailText.string, "PENDING: Fuel - BP\nTarneit")
            XCTAssertNil(cellViewModelAtSection3Row0.transaction.atmId)
        default:
            XCTFail("Expected a Transaction Section ViewModel")
        }
    }
    
    func testHandleSelectionOfTransactionCellWithATMDetail() {
        // Given
        mockTransactionService.resultToReturn = .success(transactionResponse)
        viewModel.fetchTransaction()
                
        // When
        let indexPath = IndexPath(row: 1, section: 1)
        viewModel.handleSelection(at: indexPath)

        // Then
        XCTAssertEqual(mockCoordinatorDelegate.events.count, 1)
        
        switch mockCoordinatorDelegate.events[0] {
        case .didSelectTransactionWithATMDetail(let atmDetail):
            XCTAssertEqual(atmDetail.id, "ATM123")
            XCTAssertEqual(atmDetail.name, "Darling Harbour ATM")
            XCTAssertEqual(atmDetail.address, "77 kent street, NSW, 2000")
            XCTAssertEqual(atmDetail.location.latitude, 33.8568)
            XCTAssertEqual(atmDetail.location.longitude, 151.2153)
        }
    }

    func testHandleSelectionOfTransactionCellWithoutATMDetail() {
        // Given
        mockTransactionService.resultToReturn = .success(transactionResponse)
        viewModel.fetchTransaction()
                
        // When
        let indexPath = IndexPath(row: 0, section: 1)
        viewModel.handleSelection(at: indexPath)

        // Then
        XCTAssertTrue(mockCoordinatorDelegate.events.isEmpty)
    }
}

private extension TransactionListViewModelTests {
    var transactionResponse: TransactionResponse {
        let atmDetail = ATMDetail(id: "ATM123", name: "Darling Harbour ATM", address: "77 kent street, NSW, 2000", location: Location.makeMock())
        let accountDetail = AccountDetail(accountName: "Complete Access", accountNumber: "123456 7895 45623", available: 100, balance: 120)
        
        let clearedTransaction1 = Transaction(id: "1", effectiveDate: mockDate, description: "Coles shopping", amount: 40, atmId: nil)
        let clearedTransaction2 = Transaction(id: "2", effectiveDate: mockDate.changeDaysBy(days: -1), description: "Food - Uber Eats", amount: 18, atmId: nil)
        
        let pendingTransaction1 = Transaction(id: "3", effectiveDate: mockDate, description: "ATM withdrawal", amount: 4.5, atmId: "ATM123")
        let pendingTransaction2 = Transaction(id: "4", effectiveDate: mockDate.changeDaysBy(days: -4), description: "Fuel - BP<br/>Tarneit", amount: 53.32, atmId: nil)
        
        let transactions = [clearedTransaction1, clearedTransaction2]
        let pendingTransactions = [pendingTransaction1, pendingTransaction2]
        let atmDetails = [atmDetail]
        
        return TransactionResponse(account: accountDetail, transactions: transactions, pending: pendingTransactions, atms: atmDetails)
    }
}
