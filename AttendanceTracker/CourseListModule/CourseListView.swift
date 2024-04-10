import Foundation
import UIKit

public protocol CourseListViewControllerDelegate: AnyObject, UITableViewDataSource, UITableViewDelegate {
    func showAddCourseScreen()

}

public protocol CourseListViewDelegate {
    func reloadTableView()
}

public final class CourseListView: UIView {
    
    weak var delegate: CourseListViewControllerDelegate?
    
    func configure() {
        setupSubviews()
        applyLayout()
        tableView.dataSource = delegate
        tableView.delegate = delegate
        
        addCourseButton.addTarget(self, action: #selector(showAddCourseScreen), for: .touchUpInside)
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
    
    private let horizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        return stack
    }()
    
    private let addCourseButton: UIButton = {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .default)
        let image = UIImage(systemName: "plus.circle")?.applyingSymbolConfiguration(largeConfig)
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.tintColor = ColorPallete.accentColor
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.text = "Мои курсы"
        label.textColor = ColorPallete.labelPrimary
        return label
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

        scrollView.addToEdges(subview: mainStackView, left: 10, right: 20)
        [titleLabel, addCourseButton].forEach {
            horizontalStackView.addArrangedSubview($0)
        }
        mainStackView.addArrangedSubview(horizontalStackView)
        mainStackView.addArrangedSubview(tableView)
    }

    private func applyLayout() {
        backgroundColor = UIColor(patternImage: UIImage(named: "background_dark") ?? UIImage())
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            tableView.heightAnchor.constraint(equalToConstant: 800),
            tableView.widthAnchor.constraint(equalToConstant: 380)
        ])
    }
    
    @objc
    private func showAddCourseScreen() {
        delegate?.showAddCourseScreen()
    }

}

extension CourseListView: CourseListViewDelegate {
    public func reloadTableView() {
        tableView.reloadData()
    }
}
