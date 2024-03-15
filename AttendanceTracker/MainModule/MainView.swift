import Foundation
import UIKit

public protocol MainViewControllerDelegate: AnyObject, UICalendarSelectionSingleDateDelegate, UITableViewDataSource {

}
public final class MainView: UIView {

    weak var delegate: MainViewControllerDelegate?

    func configure() {
        setupSubviews()
        applyLayout()
        let selection = UICalendarSelectionSingleDate(delegate: delegate)
        calendar.selectionBehavior = selection
        tableView.dataSource = delegate
    }

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()

    private let navBarView = MainNavBarView()

    private let calendar: UICalendarView = {
        let calendar = UICalendarView()
        let gregorianCalendar = Calendar(identifier: .gregorian)
        calendar.calendar = gregorianCalendar
        calendar.tintColor = .blue
        calendar.availableDateRange = DateInterval(start: .now, end: .distantFuture)
        return calendar
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private func setupSubviews() {
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.backgroundColor = .cyan
        scrollView.addToEdges(subview: mainStackView)
//        mainStackView.backgroundColor = .brown
        mainStackView.addArrangedSubview(navBarView)
        mainStackView.addArrangedSubview(calendar)
        mainStackView.addArrangedSubview(tableView)
        tableView.backgroundColor = .red
    }

    private func applyLayout() {
        backgroundColor = ColorPallet.backgroundPrimary
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            tableView.heightAnchor.constraint(equalToConstant: 300)

//            navBarView.widthAnchor.constraint(equalToConstant: 400)
        ])


    }

}
