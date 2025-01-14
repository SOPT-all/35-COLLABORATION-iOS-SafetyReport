//
//  ContentCell.swift
//  saftyReport
//
//  Created by 이지훈 on 11/17/24.
//

import UIKit

import SnapKit
import Then

protocol ContentCellDelegate: AnyObject {
    func contentDidChange(_ text: String)
}

class ContentCell: BaseCell {
    
    weak var delegate: ContentCellDelegate?

    private let recommendationLabel = UILabel().then {
        $0.textColor = .primaryOrange
        let attributedText = NSAttributedString.styled(
            text: "추가/수정가능, 5~900자",
            style: .caption3
        )
        $0.attributedText = attributedText
    }
    
    private let locationIcon = UIImageView().then {
        let image = UIImage(named: "btn_i_mic")
        $0.image = image
        $0.tintColor = .gray6
        $0.contentMode = .scaleAspectFit
        
        }
    
    private let textView = UITextView().then {
        $0.backgroundColor = .gray3
        $0.layer.cornerRadius = 5
        $0.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
    
    private let bottomStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }
    
    private let leftStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
    }
    
    private let textCheckButton = UIButton().then {
        $0.setImage(UIImage(named: "checkbox_i_report_page_square_filled_orange_16px"), for: .normal)
        $0.tintColor = .systemOrange
    }
    
    private let textCheckLabel = UILabel().then {
        $0.textColor = .gray13
        let attributedText = NSAttributedString.styled(
            text: "추천단어",
            style: .caption3
        )
        $0.attributedText = attributedText
    }
    
    private let copyButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "icon_copy_line_black_16px")
        config.imagePadding = 4
        config.baseForegroundColor = .gray13
        let attributedText = NSAttributedString.styled(
            text: "내용복사",
            style: .caption3
        )
        config.attributedTitle = AttributedString(attributedText)
        $0.configuration = config
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupPlaceholder()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubviews(titleLabel, requiredMark, recommendationLabel, locationIcon, textView, bottomStackView)
        
        leftStackView.addArrangedSubviews(textCheckButton, textCheckLabel)
        bottomStackView.addArrangedSubviews(leftStackView, copyButton)
        
        recommendationLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview()
        }
        
        locationIcon.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview()
            $0.size.width.equalTo(40)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(recommendationLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.height.greaterThanOrEqualTo(110)
        }
        
        bottomStackView.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(8)
        }
    }
    
    override func preferredLayoutAttributesFitting(
        _ layoutAttributes: UICollectionViewLayoutAttributes
    ) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: UIView.layoutFittingCompressedSize.height)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        return layoutAttributes
    }
    
    private func setupPlaceholder() {
        textView.text = "내용을 입력해주세요"
        textView.textColor = .lightGray
        textView.delegate = self
    }
    
    private func setupActions() {
        textCheckButton.addTarget(self, action: #selector(textCheckButtonTapped), for: .touchUpInside)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.textColor != .lightGray {
            delegate?.contentDidChange(textView.text)
        }
    }
    
    @objc private func textCheckButtonTapped() {
        textCheckButton.isSelected.toggle()
        if textCheckButton.isSelected {
            if textView.text == "내용을 입력해주세요" && textView.textColor == .lightGray {
                textView.text = "안녕하세요"
                textView.textColor = .black
            } else {
                textView.text = "안녕하세요"
            }
        } else {
            if textView.text == "안녕하세요" {
                textView.text = "내용을 입력해주세요"
                textView.textColor = .gray13Opacity40
            }
        }
    }
    
    
}

extension ContentCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "내용을 입력해주세요"
            textView.textColor = .lightGray
        }
    }
}

#Preview {
    ReportDetailViewController()
}
