import Foundation
import UIKit

public protocol NewCourseViewControllerDelegate: AnyObject, UIPickerViewDelegate, UIPickerViewDataSource, UICalendarSelectionMultiDateDelegate {

}

public final class NewCourseView: UIView {

    weak var delegate: NewCourseViewControllerDelegate?

    func configure() {
        let multiSelect = UICalendarSelectionMultiDate(delegate: delegate)
        calendar.selectionBehavior = multiSelect
        regularityPicker.delegate = delegate
        regularityPicker.dataSource = delegate
        setupSubviews()
        applyLayout()
    }

    func setSelection(dates: [DateComponents]) {
        let selection = calendar.selectionBehavior as? UICalendarSelectionMultiDate
        selection?.setSelectedDates(dates, animated: true)
        print(selection?.selectedDates)
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

    private let labels: [UILabel] = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 18, weight: .semibold)
        title.textColor = ColorPallet.labelPrimary
        title.text = "Новый курс"

        let name = UILabel()
        name.font = .systemFont(ofSize: 14, weight: .semibold)
        name.textColor = ColorPallet.labelPrimary
        name.text = "Название"

        let description = UILabel()
        description.font = .systemFont(ofSize: 14, weight: .semibold)
        description.textColor = ColorPallet.labelPrimary
        description.text = "Описание"

        let regularity = UILabel()
        regularity.text = "Регулярность"

        return [title, name, description, regularity]
    }()

    private let nameInput: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 14, weight: .regular)
        textView.text = "Название"
        textView.isEditable = true
        textView.layer.cornerRadius = 12
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        textView.backgroundColor = ColorPallet.backgroundSecondary
        return textView
    }()

    private let descriptionInput: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 14, weight: .regular)
        textView.text = "Описание"
        textView.isEditable = true
        textView.layer.cornerRadius = 12
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        textView.backgroundColor = ColorPallet.backgroundSecondary
        return textView
    }()

    private var regularityPicker = UIPickerView()

    private let calendar: UICalendarView = {
        let calendar = UICalendarView()
        let gregorianCalendar = Calendar(identifier: .gregorian)
        calendar.calendar = gregorianCalendar
        calendar.tintColor = .blue
        calendar.availableDateRange = DateInterval(start: .now, end: .distantFuture)
        return calendar
    }()

    private var timePicker: UIDatePicker = {
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        return timePicker
    }()

    private func setupSubviews() {
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addToEdges(subview: mainStackView, left: 10, right: -10)
        mainStackView.addArrangedSubview(labels[0])
        mainStackView.addArrangedSubview(labels[1])
        mainStackView.addArrangedSubview(nameInput)
        mainStackView.addArrangedSubview(labels[2])
        mainStackView.addArrangedSubview(descriptionInput)
        mainStackView.addArrangedSubview(labels[3])
        mainStackView.addArrangedSubview(regularityPicker)
        mainStackView.addArrangedSubview(calendar)
        mainStackView.addArrangedSubview(timePicker)

    }

    private func applyLayout() {
        backgroundColor = ColorPallet.backgroundPrimary
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            mainStackView.widthAnchor.constraint(equalToConstant: 380),

            nameInput.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            descriptionInput.heightAnchor.constraint(greaterThanOrEqualToConstant: 80)
        ])
    }
}
