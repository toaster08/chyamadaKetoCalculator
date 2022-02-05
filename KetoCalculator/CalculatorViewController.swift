//
//  ViewController.swift
//  KetoCalculator
//
//  Created by toaster on 2021/10/30.
//

import UIKit
import SafariServices

final class CalculatorViewController: UIViewController {
    private let settingUserDefaults = SettingUserDefaults()
    private var hasSaved = false
    private var defaultTarget: Double?
    private var calculatedResult: Double?
    private var pfc: PFC?
    private var pfs: PFS?

    private var inputTextFields: [UITextField] {
        [inputProteinTextField,
         inputFatTextField,
         inputCarbohydrateTextField,
         inputSugarTextField]
    }

    private var collectionCellSize: CGSize {
        let height = articleFeedCollectionView.frame.height
        let width = articleFeedCollectionView.frame.width
        return CGSize(width: width, height: height)
    }

    // API通信用
    private var apiClient: APIClient?
    private var contents: [WordPressContent] = []
    private var articles: [WordPressArticles] = []

    private var imageDownloader: ImageDownLoader?
    private var imageData: [Data] = []

    private var selectedIndexType: KetogenicIndexType {
        switch ketogenicIndexTypeSegmentedControl.selectedSegmentIndex {
        case 0: return .ketogenicRatio
        case 1: return .ketogenicIndex
        case 2: return .ketogenicValue
        default: fatalError()
        }
    }

    // ViewのIBパーツ
    @IBOutlet private weak var defaultTargetLabel: UILabel!
    @IBOutlet private weak var ketogenicIndexTypeSegmentedControl: UISegmentedControl!

    @IBOutlet private weak var calculatedResultView: UIView!
    @IBOutlet private weak var calculatedResultLabel: UILabel!
    @IBOutlet private weak var resultLabelView: UIView!

    @IBOutlet private weak var articleFeedCollectionView: UICollectionView!
    @IBOutlet private weak var articleFeedReloadButton: UIButton!

    @IBOutlet private weak var inputProteinTextField: UITextField!
    @IBOutlet private weak var inputFatTextField: UITextField!
    @IBOutlet private weak var inputCarbohydrateTextField: UITextField!
    @IBOutlet private weak var inputSugarTextField: UITextField!

    @IBOutlet private weak var textFieldsStackView: UIStackView!
    @IBOutlet private weak var proteinStackView: UIStackView!
    @IBOutlet private weak var fatStackView: UIStackView!
    @IBOutlet private weak var carbohydrateStackView: UIStackView!
    @IBOutlet private weak var inputTextFieldsView: UIView!

    @IBOutlet private weak var calculateButton: UIButton!
    @IBOutlet private weak var informationButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        articleFeedReloadButton.isHidden = true
        // レイアウトのためのLabel表示
        calculatedResultLabel.text = nil

        //　CollectionViewの設定
        articleFeedCollectionView
            .register(UINib(nibName: "PostFeedCollectionViewCell", bundle: nil),
                      forCellWithReuseIdentifier: "PostFeedCollectionViewCell")
        articleFeedCollectionView.dataSource = self
        articleFeedCollectionView.delegate = self
        articleFeedCollectionView.isPagingEnabled = true

        // CollectionViewのFlowLayout設定
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        articleFeedCollectionView.collectionViewLayout = layout

        // UserDefalutより設定値の取得
        loadSavedFlug()
        loadDefaultTargetValue()
        loadDefaultEquation()

        // Viewのsetup
        setup()
        enableTextField()
        enableInfomationButton()

        // WordPressを利用したAPI通信
        getArticle()

        // 各種メソッドの指定
        ketogenicIndexTypeSegmentedControl
            .addTarget(self,
                       action: #selector(segmentedControlValueChanged),
                       for: .valueChanged)

        inputTextFields.forEach {
            $0.addTarget(self,
                         action: #selector(textFieldEditingChanged),
                         for: .editingChanged)
        }

        calculateButton
            .addTarget(self,
                       action: #selector(calculate),
                       for: .touchUpInside)

        articleFeedReloadButton
            .addTarget(self,
                       action: #selector(reloadButtonTouchUpInside),
                       for: .touchUpInside)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard let postCollectionFlowLayout
                = articleFeedCollectionView.collectionViewLayout
                as? UICollectionViewFlowLayout else {
            return
        }
        postCollectionFlowLayout.itemSize
            = articleFeedCollectionView.frame.size

        if inputTextFieldsView.frame.height < 220 {
            textFieldsStackView.setCustomSpacing(5, after: proteinStackView)
            textFieldsStackView.setCustomSpacing(5, after: fatStackView)
            textFieldsStackView.setCustomSpacing(5, after: carbohydrateStackView)
            calculateButton.layer.cornerRadius = calculateButton.frame.width / 2
        }
        setupGradient(frame: inputTextFieldsView.bounds)
    }

    override func viewWillAppear(_ animated: Bool) {
        loadDefaultTargetValue()

        calculateButton.layer.cornerRadius = calculateButton.frame.width / 2
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let informationVC
                = segue.destination
                as? InformationViewController else {
            return
        }
        switch selectedIndexType {
        case .ketogenicRatio, .ketogenicIndex:
            guard let pfc = pfc else { return }
            informationVC.pfc = pfc
        case .ketogenicValue:
            guard let pfs = pfs else { return }
            informationVC.pfs = pfs
        }
        informationVC.currentKetogenicIndexType
            = selectedIndexType
    }

    private func setup() {
        inputTextFields.forEach {
            $0.layer.cornerRadius = 10
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.3
        }

        inputTextFieldsView.map {
            $0.layer.cornerRadius = 10
        }

        [inputTextFieldsView,
         informationButton,
         resultLabelView,
         articleFeedCollectionView].forEach {
            $0?.layer.cornerRadius = 10
            $0?.layer.shadowOffset = CGSize(width: 0, height: 2)
            $0?.layer.shadowColor = UIColor.black.cgColor
            $0?.layer.shadowOpacity = 0.3
            $0?.layer.borderColor = UIColor.white.cgColor
            $0?.layer.shadowRadius = 3
         }

        calculateButton.map {
            $0.isEnabled = false
            $0.layer.opacity = 0.5
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.3
            $0.titleLabel?.minimumScaleFactor = 0.1
        }
    }

    private func setupGradient(frame: CGRect) {
        inputTextFieldsView.map {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = $0.bounds
            guard let color1 = UIColor(named: "Gradient1")?.cgColor,
                  let color2 = UIColor(named: "Gradient2")?.cgColor,
                  let color3 = UIColor(named: "Gradient3")?.cgColor else {
                return
            }
            gradientLayer.colors = [color1, color2, color3]
            gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint.init(x: 1, y: 1)
            gradientLayer.cornerRadius = 10
            $0.layer.insertSublayer(gradientLayer, at: 0)
        }
    }

    private func loadSavedFlug() {
        hasSaved = settingUserDefaults.loadSavedFlug()
    }

    private func loadDefaultEquation() {
        guard hasSaved else {
            ketogenicIndexTypeSegmentedControl.selectedSegmentIndex = 0
            return
        }

        ketogenicIndexTypeSegmentedControl.selectedSegmentIndex
            = settingUserDefaults.loadDefaultIndexType()
    }

    private func loadDefaultTargetValue() {
        guard hasSaved else {
            defaultTargetLabel.text = "目標値：未設定"
            return
        }

        switch selectedIndexType {
        case .ketogenicRatio:
            defaultTarget = settingUserDefaults.loadRaioDefaultTarget()
        case .ketogenicIndex:
            defaultTarget = settingUserDefaults.loadIndexDefaultTarget()
        case .ketogenicValue:
            defaultTarget = settingUserDefaults.loadValueDefaultTarget()
        }
        guard let defaultTarget = defaultTarget else { return }
        let targetValue = String(format: "%.1f", defaultTarget)
        defaultTargetLabel.text = "目標値：\(targetValue)"
    }

    @IBAction private func exit(segue: UIStoryboardSegue) {  }

    @objc private func segmentedControlValueChanged() {
        calculatedResult = nil
        calculatedResultLabel.text = nil

        enableCalculateButton()
        enableInfomationButton()
        enableTextField()
        loadDefaultTargetValue()
    }

    @objc private func textFieldEditingChanged() {
        enableCalculateButton()
    }

    @objc private func reloadButtonTouchUpInside() {
        getArticle()
    }

    @objc private func calculate() {
        animateButtonView(calculateButton)

        guard let protein = Double(inputProteinTextField.text ?? ""),
              let fat = Double(inputFatTextField.text ?? "") else {
            return
        }

        switch selectedIndexType {
        case .ketogenicRatio:
            guard let carbohydrate = Double(inputCarbohydrateTextField.text ?? "") else { return }
            self.pfc = PFC(protein: protein, fat: fat, carbohydrate: carbohydrate)
            calculatedResult = pfc?.ketogenicRatio
        case .ketogenicIndex:
            guard let carbohydrate = Double(inputCarbohydrateTextField.text ?? "") else { return }
            self.pfc = PFC(protein: protein, fat: fat, carbohydrate: carbohydrate)
            calculatedResult = pfc?.ketogenicIndex
        case .ketogenicValue:
            guard let sugar = Double(inputSugarTextField.text ?? "") else { return }
            self.pfs =  PFS(protein: protein, fat: fat, sugar: sugar)
            calculatedResult = pfs?.ketogenicValue
        }

        guard let calculatedResult = calculatedResult else {
            let message = "入力されている値を確認してください"
            presentAlert(title: "計算", message: message, actionTitle: "OK")
            enableInfomationButton()
            return
        }

        calculatedResultLabel.text = String(round(calculatedResult * 10) / 10)
        enableInfomationButton()
    }
}

// 各種バリデーションチェック
extension CalculatorViewController {
    private func enableCalculateButton() {
        calculateButton.isEnabled = isValid()

        if calculateButton.isEnabled {
            calculateButton.layer.opacity = 1
        } else {
            calculateButton.layer.opacity = 0.5
        }
    }

    private func enableInfomationButton() {
        guard calculatedResult == nil else {
            informationButton.map {
                $0.isEnabled = true
                $0.layer.opacity = 1
            }
            return
        }

        informationButton.map {
            $0.isEnabled = false
            $0.layer.opacity = 0.5
        }
    }
    // KetogenicIndexType別のTextFieldのEnableの切り替え
    private func enableTextField() {
        switch selectedIndexType {
        case .ketogenicRatio, .ketogenicIndex:
            inputCarbohydrateTextField.map {
                $0.isEnabled = true
                $0.layer.opacity = 1
            }

            inputSugarTextField.map {
                $0.isEnabled = false
                $0.layer.opacity = 0.5
            }

        case .ketogenicValue:
            inputCarbohydrateTextField.map {
                $0.isEnabled = false
                $0.layer.opacity = 0.5
            }

            inputSugarTextField.map {
                $0.isEnabled = true
                $0.layer.opacity = 1
            }
        }
    }
    // TextFieldの文字列がDoubleであるかのバリデーションチェック
    private func isValid() -> Bool {
        let targetTextFields: [UITextField]
        switch selectedIndexType {
        case .ketogenicRatio, .ketogenicIndex:
            targetTextFields = [
                inputProteinTextField,
                inputFatTextField,
                inputCarbohydrateTextField
            ]
        case .ketogenicValue:
            targetTextFields = [
                inputProteinTextField,
                inputFatTextField,
                inputSugarTextField
            ]
        }

        return targetTextFields
            .map { $0.text ?? "" }
            .allSatisfy { Double($0) != nil }
    }
}

// API通信
extension CalculatorViewController {
    private func getArticle() {
        apiClient = APIClient.shared
        apiClient?.getAPI(url: APIClient.myWordPress,
                          completion: { result in
                            DispatchQueue.main.async { [self] in
                                switch result {
                                case .failure(let error):
                                    articleFeedReloadButton.isHidden = false
                                    print("error:\(error)")
                                case .success(let contents):
                                    articleFeedReloadButton.isHidden = true
                                    self.contents = contents
                                    getImage()
                                }
                            }
                          })
    }

    private func getImage() {
        imageDownloader = ImageDownLoader.shared
        imageDownloader?
            .downloadImage(contents: contents ,
                           completion: { result in
                            DispatchQueue.main.async { [self] in
                                switch result {
                                case .failure(let error):
                                    print(error)
                                case .success(let imageData):
                                    self.imageData = imageData
                                    makeArticles()
                                    articleFeedCollectionView.reloadData()
                                }
                            }
                           })
    }

    private func makeArticles() {
        for (contents, imageData) in zip(self.contents, self.imageData) {
            articles
                .append(WordPressArticles(wordPressContent: contents,
                                          wordPressImage: imageData))
        }
    }
}

extension CalculatorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostFeedCollectionViewCell", for: indexPath)
        let article = articles[indexPath.row]
        if let cell = cell as? PostFeedCollectionViewCell {
            cell.configure(article: article)
        }
        return cell
    }
}

extension CalculatorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if articles.count > 0 {
            guard let articleURLString = articles[indexPath.row].wordPressContent.content?.postURL else { return }
            if let articleURL = URL(string: articleURLString) {
                let safariVC = SFSafariViewController(url: articleURL)
                present(safariVC, animated: true, completion: nil)
            }
        }
    }
}
