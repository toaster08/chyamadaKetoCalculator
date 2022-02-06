//
//  PostFeedCollectionViewCell.swift
//  KetoCalculator
//
//  Created by toaster on 2022/01/04.
//

import UIKit

final class PostFeedCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var postImageView: UIImageView!
    @IBOutlet private weak var postTitleLabel: UILabel!
    @IBOutlet private weak var postTextView: UILabel!
    @IBOutlet private weak var APIIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        APIIndicator.startAnimating()
        APIIndicator.hidesWhenStopped = true
    }

    // View
    private func setup() {
        postImageView.map {
            $0.frame = bounds
            $0.layoutIfNeeded()

            $0.layer.cornerRadius = $0.frame.height / 2
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.borderWidth = 0.5
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.3
        }
    }

    func configure(article: WordPressArticles) {
        setup()

        postTitleLabel.text
            = article
            .wordPressContent
            .content?
            .title

        postTextView.text
            = article
            .wordPressContent
            .content?
            .excerpt
            .replacingOccurrences(of: "<.+?>|&.+?;",
                                  with: "",
                                  options: .regularExpression,
                                  range: nil)

        postImageView.image = UIImage(data: article.wordPressImage)

        APIIndicator.stopAnimating()
    }
}
