import Foundation
import UIKit

public protocol MainViewControllerDelegate: AnyObject, UICalendarSelectionSingleDateDelegate, UITableViewDataSource, UITableViewDelegate {
    func showCourseList()
    func navigateToProfile()
    func navigateToQR()
}

public protocol MainViewDelegate {
    func reloadTableView()
    func setName(name: String, userType: UserType)
}

public final class MainView: UIView {

    weak var delegate: MainViewControllerDelegate?

    func configure() {
        setupSubviews()
        applyLayout()
        let selection = UICalendarSelectionSingleDate(delegate: delegate)
        calendar.selectionBehavior = selection
        tableView.dataSource = delegate
        tableView.delegate = delegate
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
    
    private let myCourseButton: UIButton = {
        let button = UIButton()
        button.setTitle("Мои курсы", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .subheadline)
        button.setTitleColor(ColorPallete.accentColor, for: .normal)
        button.contentHorizontalAlignment = .leading
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return button
    }()

    private let calendar: UICalendarView = {
        let calendar = UICalendarView()
        let gregorianCalendar = Calendar(identifier: .gregorian)
        calendar.calendar = gregorianCalendar
        calendar.tintColor = ColorPallete.accentColor
        calendar.availableDateRange = DateInterval(start: .now, end: .distantFuture)
        return calendar
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        return tableView
    }()

    private func setupSubviews() {
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addToEdges(subview: mainStackView)
        mainStackView.addArrangedSubview(navBarView)
        mainStackView.addArrangedSubview(myCourseButton)
        mainStackView.addArrangedSubview(calendar)
        mainStackView.addArrangedSubview(tableView)
        
        navBarView.profileIcon.addTarget(self, action: #selector(navigateToProfile), for: .touchUpInside)
        navBarView.qrIcon.addTarget(self, action: #selector(navigateToQR), for: .touchUpInside)
        myCourseButton.addTarget(self, action: #selector(showCourseList), for: .touchUpInside)
    }

    private func applyLayout() {
        backgroundColor = UIColor(patternImage: UIImage(named: "background_light") ?? UIImage())
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            tableView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    @objc
    private func showCourseList() {
        delegate?.showCourseList()
    }
    
    @objc
    private func navigateToProfile() {
        delegate?.navigateToProfile()
    }
    
    @objc
    private func navigateToQR() {
        delegate?.navigateToQR()
    }
}

extension MainView: MainViewDelegate {
    public func setName(name: String, userType: UserType) {
        navBarView.nameLabel.text = name
        switch userType {
        case .student:
            navBarView.qrIcon.isHidden = false
        case .teacher:
            navBarView.qrIcon.isHidden = true
        }
    }
    
    public func reloadTableView() {
        tableView.reloadData()
    }
}
