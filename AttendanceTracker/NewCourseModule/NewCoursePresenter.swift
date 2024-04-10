import Foundation
import UIKit

public protocol NewCourseModuleInput {

}

public protocol NewCourseViewOutput {
    func didSelectDate(_ dateComponents: DateComponents) -> [DateComponents]
    func doneSelectingTime(_ time: Date)
    func saveCourse(title: String, description: String)
}

class NewCoursePresenter {
    weak var view: NewCourseViewInput?

    var output: NewCourseModuleOutput?
    var selectedDates: [DateComponents] = []
    
    var selectedTime: [Date] = []
}

extension NewCoursePresenter: NewCourseModuleInput {
    
}

extension NewCoursePresenter: NewCourseViewOutput {
    func saveCourse(title: String, description: String) {
        view?.showNewCourseCodeWidget(code: "5FG8k3")
    }
    
    func doneSelectingTime(_ time: Date) {
        selectedTime.append(time)
        if selectedTime.count != selectedDates.count * 2 {
            view?.showEndTimeSelector()
        } else {
            let timeTable = formTimeTable()
            view?.showTimeTable(timeTable)
        }
    }
    
    
    func didSelectDate(_ dateComponents: DateComponents) -> [DateComponents] {
        selectedDates.append(dateComponents)
        view?.showStartTimeSelector()
        return getSelectedDates(dateComponents: dateComponents)
    }
    
    private func getSelectedDates(dateComponents: DateComponents) -> [DateComponents] {
        var dates: [Date] = []
        guard let selectedDate = Calendar.current.date(from: dateComponents) else {
            return []
        }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: selectedDate)
        guard let weekday = components.weekday else { return [] }

        let startDate = calendar.date(byAdding: .month, value: 0, to: selectedDate)!
        let endDate = calendar.date(byAdding: .month, value: 2, to: selectedDate)!

        var currentDate = startDate
        while currentDate <= endDate {
            let currentComponents = calendar.dateComponents([.weekday], from: currentDate)
            if currentComponents.weekday == weekday {
                dates.append(currentDate)
            }
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }

        let dateComponentsArray = dates.map { date -> DateComponents in
            return Calendar.current.dateComponents([.year, .month, .day], from: date)
        }
        return dateComponentsArray
    }
    
    private func formTimeTable() -> [String] {
        guard selectedTime.count >= selectedDates.count + 1 else {
                return []
            }

            var strings = [String]()
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            
            let calendar = Calendar.current
            for (index, dateElement) in selectedDates.enumerated() {
                guard let currentDate = Calendar.current.date(from: dateElement) else { continue }
                guard let weekday = calendar.dateComponents([.weekday], from: currentDate).weekday,
                      let dayOfWeek = DayOfWeek(rawValue: weekday)
                else {
                    continue
                }

                let startTime = formatter.string(from: selectedTime[index])
                let endTime = formatter.string(from: selectedTime[index+1])

                let dateString = "\(dayOfWeek.toStringValue().rawValue) \(startTime)-\(endTime)"
                strings.append(dateString)
            }
            return strings

    }

}


enum DayOfWeekString: String {
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятница"
    case saturday = "Суббота"
    case sunday = "Воскресенье"
}
enum DayOfWeek: Int {
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    case sunday = 1
    
    func toStringValue() -> DayOfWeekString {
        switch self {
        case .monday:
            return .monday
        case .tuesday:
            return .tuesday
        case .wednesday:
            return .wednesday
        case .thursday:
            return .thursday
        case .friday:
            return .friday
        case .saturday:
            return .saturday
        case .sunday:
            return .sunday
        }
    }

}
