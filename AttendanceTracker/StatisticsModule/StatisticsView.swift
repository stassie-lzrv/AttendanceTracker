import Foundation
import UIKit

public protocol StatisticsViewControllerDelegate: AnyObject, UITableViewDataSource, UITableViewDelegate {
    

}

public protocol StatisticsViewDelegate {
    func reloadTableView()
    func configure(title: String, percentage: String)
}
public final class StatisticsView: UIView {
    
    weak var delegate: StatisticsViewControllerDelegate?
    
    func configure() {
        setupSubviews()
        applyLayout()
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
    
    private let horizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
       
        stack.spacing = 10
        return stack
    }()
    
    private let percentLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = ColorPallete.labelPrimary
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
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
        [titleLabel, percentLabel].forEach {
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
    
}

extension StatisticsView: StatisticsViewDelegate {
    public func reloadTableView() {
        tableView.reloadData()
    }
    
    public func configure(title: String, percentage: String) {
        titleLabel.text = title
        percentLabel.text = "📊\(percentage)"
    }
    
}
