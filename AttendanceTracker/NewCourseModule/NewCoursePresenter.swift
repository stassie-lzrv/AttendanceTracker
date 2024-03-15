import Foundation

public protocol NewCourseModuleInput {

}

public protocol NewCourseViewOutput {

}

class NewCoursePresenter {
    weak var view: NewCourseViewInput?

    var output: NewCourseModuleOutput?
}

extension NewCoursePresenter: NewCourseModuleInput {

}

extension NewCoursePresenter: NewCourseViewOutput {

}

