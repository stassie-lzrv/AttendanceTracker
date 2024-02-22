//
//  MainButton.swift
//  AttendanceTracker
//
//  Created by Настя Лазарева on 21.02.2024.
//

import Foundation
import UIKit

public final class MainButton: UIButton {
    public struct ViewModel {
        let title: String
        let subtitle: String?
        let systemImageName: String?
        let action: (() -> Void)?
        
        init(
            title: String,
            subtitle: String? = nil,
            systemImageName: String? = nil,
            action: (() -> Void)? = nil
        ) {
            self.title = title
            self.subtitle = subtitle
            self.systemImageName = systemImageName
            self.action = action
        }
    }
    private var viewModel: ViewModel?
    
    private var rigthImageView = UIImageView()

    private let title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let subtitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .regular)
        return label
    }()
    
    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        return stack
    }()
    
    private let verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    public func set(_ viewModel: ViewModel) {
        title.text = viewModel.title
        subtitle.text = viewModel.subtitle
        self.viewModel = viewModel
        setNeedsLayout()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        setupSubviews()
        applyLayout()
    }
    
    private func setupSubviews() {
        let image = UIImage(systemName: viewModel?.systemImageName ?? "")
        rigthImageView.image = image
        mainStack.addArrangedSubview(rigthImageView)
        verticalStack.addArrangedSubview(title)
        verticalStack.addArrangedSubview(subtitle)
    }
    
    private func applyLayout() {
        backgroundColor = ColorPallet.backgroundSecondary
        self.layer.cornerRadius = 12
        addToEdges(subview: mainStack)
    }
    
}
