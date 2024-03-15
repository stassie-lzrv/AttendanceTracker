import Foundation

public protocol MainModuleInput {

}

public protocol MainViewOutput {

}

class MainPresenter {
    weak var view: MainViewInput?

    var output: MainModuleOutput?
}

extension MainPresenter: MainModuleInput {

}

extension MainPresenter: MainViewOutput {

}

