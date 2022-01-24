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
        setup()
    }

    // View
    private func setup() {
        postImageView.layer.cornerRadius = postImageView.frame.height * 0.2
        postImageView.layer.borderColor = UIColor.white.cgColor
        postImageView.layer.borderWidth = 0.5
        postImageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        postImageView.layer.shadowColor = UIColor.black.cgColor
        postImageView.layer.shadowOpacity = 0.3
    }

    func configure(article: WordPressArticles) {
            postTitleLabel.text
                = article
                .wordPressContents
                .content?
                .title

            postTextView.text
                = article
                .wordPressContents
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
