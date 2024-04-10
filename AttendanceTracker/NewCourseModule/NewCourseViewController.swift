import Foundation
import UIKit

public protocol NewCourseViewInput: AnyObject {
    func showStartTimeSelector()
    func showEndTimeSelector()
    func showTimeTable(_ timeTable: [String])
    func showNewCourseCodeWidget(code: String)
}

final class NewCourseViewController: UIViewController {
    var output: NewCourseViewOutput?
    let data = [
        "Еженедельно",
        "Ежемесячно",
        "Ежегодно"
    ]
    var customView: NewCourseViewDelegate?
    let newCourseWidget = NewCourseWidget()

    override func viewDidLoad() {
        super.viewDidLoad()
        let customView = NewCourseView()
        self.customView = customView
        customView.delegate = self
        customView.configure()
        view = customView
        setupWidget()
        self.customView?.configure(for: .teacher)
        
        navigationItem.hidesBackButton = true
        if let image = UIImage(systemName: "chevron.backward")?.withTintColor(.black) {
            let sizeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .default)
            let button = UIBarButtonItem(image: image.applyingSymbolConfiguration(sizeConfig), style: .plain, target: self, action: #selector(backButtonTapped))
            self.navigationItem.leftBarButtonItem = button
        }
    }
    
    @objc
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupWidget() {
        newCourseWidget.isHidden = true
        newCourseWidget.closeButton.addTarget(self, action: #selector(hideWidget), for: .touchUpInside)
        
        view.addSubview(newCourseWidget)
        newCourseWidget.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newCourseWidget.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newCourseWidget.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            newCourseWidget.widthAnchor.constraint(equalToConstant: 300),
            newCourseWidget.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    @objc
    func hideWidget() {
        newCourseWidget.isHidden = true
        backButtonTapped()
    }
}

extension NewCourseViewController: NewCourseViewInput {
    func showStartTimeSelector() {
        customView?.showStartTimeSelector()
    }
    
    func showEndTimeSelector() {
        customView?.showEndTimeSelector()
    }
    
    func showTimeTable(_ timeTable: [String]) {
        customView?.showTimeTable(timeTable)
    }
    
    func showNewCourseCodeWidget(code: String) {
        newCourseWidget.setText(code)
        newCourseWidget.isHidden = false
    }

}

extension NewCourseViewController: NewCourseViewControllerDelegate {
    func doneSelectingTime(_ time: Date) {
        output?.doneSelectingTime(time)
    }
    
    func saveCourse(title: String, description: String) {
        newCourseWidget.title.text = "Статистика"
        output?.saveCourse(title: title, description: description)
    }
    
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didSelectDate dateComponents: DateComponents) {
        guard var dateComponentsArray = output?.didSelectDate(dateComponents) else { return }
        dateComponentsArray.append(contentsOf: selection.selectedDates)
        selection.setSelectedDates(dateComponentsArray, animated: true)
        view.setNeedsLayout()
    }

    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didDeselectDate dateComponents: DateComponents) {
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        data.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
}

extension NewCourseViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == ColorPallete.labelSecondary {
            textView.text = nil
            textView.textColor = ColorPallete.labelPrimary
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            if textView.tag == 0 {
                textView.text = "Название"
            } else {
                textView.text = "Описание"
            }
            textView.textColor = ColorPallete.labelSecondary
        }
    }
}
