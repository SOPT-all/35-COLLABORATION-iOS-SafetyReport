//
//  BaseCell.swift
//  saftyReport
//
//  Created by 이지훈 on 11/17/24.
//

import UIKit

import SnapKit
import Then

class BaseCell: UICollectionViewCell, ConfigurableCell {
    static var reuseIdentifier: String { return String(describing: self) }
    
    let titleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let requiredMark = UILabel().then {
        $0.text = "*"
        $0.textColor = .primaryOrange
    }
    
    let infoImageView = UIImageView().then {
        let image = UIImage(named: "icon_info_line_black_16px")
        $0.image = image
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBaseUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBaseUI() {
        contentView.addSubviews(titleLabel, requiredMark, infoImageView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        requiredMark.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(4)
            $0.centerY.equalTo(titleLabel)
        }
        
        infoImageView.snp.makeConstraints {
            $0.leading.equalTo(requiredMark.snp.trailing).offset(8)
            $0.centerY.equalTo(titleLabel)
            $0.size.equalTo(14)
        }
    }
    
    func configure(with item: ReportDetailItem) {
        let attributedText = NSAttributedString.styled(
            text: item.title,
            style: .body3
        )
        titleLabel.attributedText = attributedText

        requiredMark.isHidden = !item.isRequired
        infoImageView.isHidden = !item.showInfoIcon
    }
}
