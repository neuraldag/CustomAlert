//
//  AlertView.swift
//  Test
//
//  Created by Gamid Gapizov on 21.02.2024.
//

import UIKit
import SnapKit


enum ButtonType {
    case cancel
    case other
}


// MARK: - Alert Colors
struct AlertColor {
    static let header = UIColor.black
    static let message = UIColor.systemGray
    static let primary = UIColor.black
    static let secondary = UIColor.systemGray
}


class AlertView: UIView, AlertViewModel {
    
    // MARK: - Properties
    var rightButtonTitle: String = ""
    var leftButtonTitle: String = ""
    weak var delegate: AlertViewDelegate?
    var completionHandler: ((String, ButtonType) -> Void)?
    var animationOption: AnimationOption = .zoomInOut

        
    // MARK: - Lazy loading view
    // MARK: Background and alert itself
    internal lazy var backgroundView: UIView = {
        let view = UIView()
        view.frame = frame
        view.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.4)
        return view
    }()
    internal lazy var containerView: UIView = {
        let view = UIView()
        view.frame = frame
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 13.0
        view.dropShadows(color: .gray, opacity: 1, offSet: CGSize(width: 1.5, height: 0.8), radius: 1, scale: true)
        view.clipsToBounds = true
        return view
    }()
    
    
    //MARK: Alert titles
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray6
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        label.textColor = AlertColor.header
        return label
    }()
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray6
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.textColor = AlertColor.message
        return label
    }()
    
    
    //MARK: Separators for buttons
    private lazy var separatorLabelHorizontal: UIView = {
        let label = UIView()
        label.backgroundColor = UIColor(red: 203/255, green: 203/255, blue: 203/255, alpha: 1.0)
        return label
    }()
    private lazy var separatorLabelVertical: UIView = {
        let label = UIView()
        label.backgroundColor = UIColor(red: 203/255, green: 203/255, blue: 203/255, alpha: 1.0)
        return label
    }()
    
    
    //MARK: Buttons
    private lazy var leftButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(AlertColor.primary, for: .normal)
        button.addTarget(self, action: #selector(rightButtonClicked), for: .touchUpInside)
        return button
    }()
    private lazy var rightButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(leftButtonClicked), for: .touchUpInside)
        return button
    }()
    private lazy var activityView: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView()
        av.style = .medium
        return av
    }()
    
    
    //MARK: -Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    convenience init(title: String, message: String, okButtonText: String, cancelButtonText: String) {
        self.init(frame: UIScreen.main.bounds)
        setupUIView(title: title, message: message, okButtonText: okButtonText, cancelButtonText: cancelButtonText)
    }
    convenience init(title: String, message: String, okButtonText: String, cancelButtonText: String, target: AlertViewDelegate) {
        self.init(frame: UIScreen.main.bounds)
        self.delegate = target
        setupUIView(title: title, message: message, okButtonText: okButtonText, cancelButtonText: cancelButtonText)
    }
    convenience init(title: String, message: String, okButtonText: String, cancelButtonText: String, actionCompletionHandler: @escaping (String, ButtonType) -> Void) {
        self.init(frame: UIScreen.main.bounds)
        self.completionHandler = actionCompletionHandler
        setupUIView(title: title, message: message, okButtonText: okButtonText, cancelButtonText: cancelButtonText)
    }
    
    
    //MARK: -UI Setup
    private func setupUIView(title: String, message: String, okButtonText: String, cancelButtonText: String) {
        rightButtonTitle = okButtonText
        leftButtonTitle = cancelButtonText
        setupBackgroundView()
        setupContainerView()
        setupTitleLabel()
        setupSeparatorHorizontalLabel()
        setupSeparatorVerticalLabel()
        setupMessageLabel()
        setupButtons()
        messageLabel.text = message
        titleLabel.text = title
        leftButton.setTitle(cancelButtonText, for: .normal)
        rightButton.setTitle(okButtonText, for: .normal)
    }
    
    private func setupBackgroundView() {
        addSubview(backgroundView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        tapGesture.numberOfTapsRequired = 1
//        backgroundView.addGestureRecognizer(tapGesture)  //enabling alert dismiss on tap
    }
    
    private func setupContainerView() {
        backgroundView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(200)
        }
    }
    
    private func setupTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(containerView.snp.leading).inset(10)
            make.top.equalTo(containerView.snp.top).inset(15)
            make.trailing.equalTo(containerView.snp.trailing).inset(10)
        }
    }
    
    private func setupMessageLabel() {
        containerView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(1)
            make.bottom.equalTo(separatorLabelHorizontal).inset(1)
            make.leading.equalTo(containerView.snp.leading)
            make.trailing.equalTo(containerView.snp.trailing)
        }
    }
    
    private func setupSeparatorHorizontalLabel() {
        containerView.addSubview(separatorLabelHorizontal)
        separatorLabelHorizontal.snp.makeConstraints { make in
            make.leading.equalTo(containerView.snp.leading)
            make.top.equalTo(containerView.snp.bottom).inset(60)
            make.trailing.equalTo(containerView.snp.trailing)
            make.height.equalTo(1)
        }
        
    }
    private func setupSeparatorVerticalLabel() {
        containerView.addSubview(separatorLabelVertical)
        separatorLabelVertical.snp.makeConstraints { make in
            make.leading.equalTo(containerView.snp.leading).offset(149.5)
            make.top.equalTo(separatorLabelHorizontal)
            make.trailing.equalTo(containerView.snp.trailing).inset(149.5)
            make.height.equalTo(100)
        }
        
    }
    
    private func setupLeftButton() {
        containerView.addSubview(leftButton)
        leftButton.snp.makeConstraints { make in
            make.leading.equalTo(containerView.snp.leading)
            make.top.equalTo(separatorLabelHorizontal)
            make.trailing.equalTo(separatorLabelVertical)
            make.bottom.equalTo(containerView.snp.bottom)
        }
    }
    
    
    private func setupRightButton() {
        containerView.addSubview(rightButton)
        rightButton.snp.makeConstraints { make in
            make.leading.equalTo(separatorLabelVertical)
            make.top.equalTo(separatorLabelHorizontal)
            make.trailing.equalTo(containerView.snp.trailing)
            make.bottom.equalTo(containerView.snp.bottom)
        }
    }
    
    
    private func setupOkButtonWithRespectToSuperview() {
        containerView.addSubview(rightButton)
        rightButton.snp.makeConstraints { make in
            make.top.equalTo(separatorLabelHorizontal)
            make.centerX.equalTo(containerView)
            make.leading.equalTo(containerView.snp.leading)
            make.trailing.equalTo(containerView.snp.trailing)
            make.bottom.equalTo(containerView.snp.bottom)
        }
    }
    
    
    
    //MARK: -Setting up buttons depending on how many of them added
    func setupButtons() {
        if leftButtonTitle.count != 0 && rightButtonTitle.count != 0 {
            setupLeftButton()
            setupRightButton()
            separatorLabelVertical.isHidden = false
        } else {
            setupOkButtonWithRespectToSuperview()
            separatorLabelVertical.isHidden = true
        }
    }
    
    //MARK: Adding activity view to left button
    func showProccess() {
        UIView.animate(withDuration: 0.5) { [self] in
            rightButton.addSubview(activityView)
            
            activityView.snp.makeConstraints { make in
                make.leading.equalTo(rightButton.snp.leading).offset(25)
                make.centerY.equalTo(rightButton)
            }
            
            let newtext = "   \(rightButtonTitle)"
            rightButton.setTitle(newtext, for: .normal)
            
            activityView.startAnimating()
        }
    }
    
    
    
    //MARK: -Button actions
    @objc func dismissView() { dismiss(animated: true) }
    
    
    @objc func rightButtonClicked() {
        dismiss(animated: true)
        if self.delegate != nil {
            self.delegate?.alertView!(alertView: self, clickedButtonAtIndex: 0)
        } else if completionHandler != nil {
            self.completionHandler!("cancel", .cancel)
         }
    }
    
    
    @objc func leftButtonClicked() {
//        dismiss(animated: true)
        if self.delegate != nil {
            if leftButtonTitle.count != 0 && rightButtonTitle.count != 0 {
                self.delegate?.alertView!(alertView: self, clickedButtonAtIndex: 1)
            } else {
                self.delegate?.alertView!(alertView: self, clickedButtonAtIndex: 0)
            }
        } else if completionHandler != nil {
            self.completionHandler!("Ok", .other)
            
            rightButton.isEnabled = false
            rightButton.setTitleColor(.systemGray, for: .normal)
            
            leftButton.isEnabled = false
            leftButton.setTitleColor(.systemGray, for: .normal)
            
            showProccess()
        }
    }
}




private extension UIView {
     func dropShadows(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offSet  //Here you control x and y
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius //Here your control your blur
        layer.masksToBounds =  false
    }
}
