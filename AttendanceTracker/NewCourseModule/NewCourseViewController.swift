import Foundation
import UIKit

public protocol NewCourseViewInput: AnyObject {
}

final class NewCourseViewController: UIViewController {
    var output: NewCourseViewOutput?
    let data = [
        "Еженедельно",
        "Ежемесячно",
        "Ежегодно"
    ]
    var customView: NewCourseView?
    var dates: [DateComponents]? {
        didSet {
            guard let dates = dates else { return }
            self.customView?.setSelection(dates: dates)
        }
    }
//    let data = [
//        "1 раз в неделю",
//        "2 раза в неделю",
//        "3 раза в неделю",
//        "4 раза в неделю",
//        "5 раз в неделю",
//        "6 раз в неделю",
//        "7 раз в неделю",
//    ]

//    let regularity = [
//        "Понедельник",
//        "Вторник",
//        "Среда",
//        "Четверг",
//        "Пятница"
//    ]
//
//    let ешьу = [
//        "Понедельник",
//        "Вторник",
//        "Среда",
//        "Четверг",
//        "Пятница"
//    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        let customView = NewCourseView()
        self.customView = customView
        customView.delegate = self
        customView.configure()
        view = customView
    }

}

extension NewCourseViewController: NewCourseViewInput {

}

extension NewCourseViewController: NewCourseViewControllerDelegate {
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didSelectDate dateComponents: DateComponents) {
        var dates: [Date] = []
        guard let selectedDate = Calendar.current.date(from: dateComponents) else {
            return
        }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: selectedDate)
        guard let weekday = components.weekday else { return }

        // Ваша логика для определения диапазона дат
        let startDate = calendar.date(byAdding: .year, value: 0, to: selectedDate)!
        let endDate = calendar.date(byAdding: .month, value: 3, to: selectedDate)!

        var currentDate = startDate
        while currentDate <= endDate {
            let currentComponents = calendar.dateComponents([.weekday], from: currentDate)
            if currentComponents.weekday == weekday {
                dates.append(currentDate)
            }
            currentDate = calendar.date(byAdding: .day, value: 7, to: currentDate)!
        }

        var dateComponentsArray = dates.map { date -> DateComponents in
            return Calendar.current.dateComponents([.year, .month, .day], from: date)
        }
        dateComponentsArray.append(dateComponents)
        dateComponentsArray.append(contentsOf: selection.selectedDates)
        selection.setSelectedDates(dateComponentsArray, animated: true)
//        selection.setSelectedDates(dateComponentsArray, animated: true)
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

extension NewCourseViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        print(dateComponents)
    }
}
