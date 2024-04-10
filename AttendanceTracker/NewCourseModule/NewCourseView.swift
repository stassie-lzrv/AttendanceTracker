import Foundation
import UIKit

public protocol NewCourseViewControllerDelegate: AnyObject, UIPickerViewDelegate, UIPickerViewDataSource, UICalendarSelectionMultiDateDelegate, UITextViewDelegate {
    func doneSelectingTime(_ time: Date)
    func saveCourse(title: String, description: String)

}
public protocol NewCourseViewDelegate {
    func configure(for userType: UserType)
    
    func showStartTimeSelector()
    func showEndTimeSelector()
    func showTimeTable(_ timeTable: [String])
}
public final class NewCourseView: UIView {

    weak var delegate: NewCourseViewControllerDelegate?

    func configure() {
        let multiSelect = UICalendarSelectionMultiDate(delegate: delegate)
        calendar.selectionBehavior = multiSelect
        regularityPicker.delegate = delegate
        regularityPicker.dataSource = delegate
        nameInput.delegate = delegate
        descriptionInput.delegate = delegate
        setupSubviews()
        applyLayout()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
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
        title.font = .systemFont(ofSize: 22, weight: .semibold)
        title.textColor = ColorPallete.labelPrimary
        title.text = "Новый курс"

        let name = UILabel()
        name.font = .systemFont(ofSize: 18, weight: .semibold)
        name.textColor = ColorPallete.labelPrimary
        name.text = "Название"

        let description = UILabel()
        description.font = .systemFont(ofSize: 18 , weight: .semibold)
        description.textColor = ColorPallete.labelPrimary
        description.text = "Описание"

        let regularity = UILabel()
        regularity.text = "Регулярность"
        regularity.font = .systemFont(ofSize: 18, weight: .semibold)
        regularity.textColor = ColorPallete.labelPrimary

        return [title, name, description, regularity]
    }()

    private let nameInput: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.text = "Название"
        textView.textColor = ColorPallete.labelSecondary
        textView.isEditable = true
        textView.layer.cornerRadius = 12
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        textView.backgroundColor = ColorPallete.backgroundSecondary
        textView.tag = 0
        return textView
    }()

    private let descriptionInput: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.text = "Описание"
        textView.textColor = ColorPallete.labelSecondary
        textView.isEditable = true
        textView.layer.cornerRadius = 12
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        textView.backgroundColor = ColorPallete.backgroundSecondary
        textView.tag = 1
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
    
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.numberOfLines = 0
        label.textColor = ColorPallete.labelPrimary
        label.isHidden = true
        return label
    }()

    private var timePicker: UIDatePicker = {
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        timePicker.isHidden = true
        return timePicker
    }()
    
    private let saveButton: MainButton = {
        let button = MainButton()
        button.isHidden = true

        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        button.layer.shadowRadius = 4.0
        button.layer.shadowOpacity = 0.4
        return button
    }()
    
    private let doneButton: MainButton = {
        let button = MainButton()
        button.isHidden = true

        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        button.layer.shadowRadius = 4.0
        button.layer.shadowOpacity = 0.4

        return button
    }()

    private func setupSubviews() {
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addToEdges(subview: mainStackView, left: 10, right: -10, bottom: -10)
        mainStackView.addArrangedSubview(labels[0])
        mainStackView.addArrangedSubview(labels[1])
        mainStackView.addArrangedSubview(nameInput)
        mainStackView.addArrangedSubview(labels[2])
        mainStackView.addArrangedSubview(descriptionInput)
        mainStackView.addArrangedSubview(labels[3])
        mainStackView.addArrangedSubview(regularityPicker)
        mainStackView.addArrangedSubview(calendar)
        mainStackView.addArrangedSubview(warningLabel)
        mainStackView.addArrangedSubview(timePicker)
        mainStackView.addArrangedSubview(saveButton)
        mainStackView.addArrangedSubview(doneButton)
        
        doneButton.set(MainButton.ViewModel(title: "Готово", titleColor: ColorPallete.accentColor, action: { [self] in
            self.doneSelectingTime()
        }))
        
        saveButton.set(MainButton.ViewModel(title: "Сохранить", titleColor: ColorPallete.accentColor, action: { [self] in
            self.saveCourse()
        }))

    }

    private func applyLayout() {
        backgroundColor = UIColor(patternImage: UIImage(named: "background_light") ?? UIImage())
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30),

            mainStackView.widthAnchor.constraint(equalToConstant: 370),

            nameInput.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            descriptionInput.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func doneSelectingTime() {
        delegate?.doneSelectingTime(timePicker.date)
    }
    
    private func saveCourse() {
        delegate?.saveCourse(title: nameInput.text, description: descriptionInput.text)
    }
    
    @objc func dismissKeyboard() {
        nameInput.endEditing(true)
        descriptionInput.endEditing(true)
    }

}

extension NewCourseView: NewCourseViewDelegate {
    
    public func showStartTimeSelector() {
        warningLabel.text = "Выберите время начала занятия"
        doneButton.isHidden = false
        warningLabel.isHidden = false
        timePicker.isHidden = false
    }
    
    public func showEndTimeSelector() {
        warningLabel.text = "Выберите время окончания занятия"
        doneButton.isHidden = false
        warningLabel.isHidden = false
        timePicker.isHidden = false
    }
    
    public func showTimeTable(_ timeTable: [String]) {
        warningLabel.text = "Выбранное расписание\n\(timeTable.joined(separator: "\n"))\n"
        warningLabel.font = .preferredFont(forTextStyle: .callout)
        doneButton.isHidden = true
        warningLabel.isHidden = false
        timePicker.isHidden = true
        saveButton.isHidden = false
    }
    
    public func configure(for userType: UserType) {
        switch userType {
        case .student:
            labels[1].text = "Koд курса"
            nameInput.text = "Код, предоставленный преподавателем\n"
            [labels[2], descriptionInput, labels[3], regularityPicker, calendar, warningLabel,timePicker, doneButton].forEach {
                $0.isHidden = true
            }
            saveButton.isHidden = false
        case .teacher:
            labels[1].text = "Название"
            nameInput.text = "Название"
            
            [labels[2], descriptionInput, labels[3], regularityPicker, calendar, warningLabel, doneButton].forEach {
                $0.isHidden = false
            }
        }
    }
    
}
