//
//  ViewController.swift
//  Milestone 7-9
//
//  Created by nikita on 26.01.2023.
//

import UIKit

class ViewController: UIViewController {
        var allWords = [String]()
        var currentAnswer: UILabel!
        var scoreLabel: UILabel!
        var letterButtons = [UIButton]()
        var promptWord = ""
        var answer = String()



        var activatedButtons = [UIButton]()
        var solutions = [String]()

        var score = 3 {
            didSet {
                scoreLabel.text = "\(score) attemps left"
            }
        }

        override func loadView() {
            view = UIView()
            view.backgroundColor = .systemGray3

            scoreLabel = UILabel()
            scoreLabel.translatesAutoresizingMaskIntoConstraints = false
            scoreLabel.textAlignment = .center
            scoreLabel.font = UIFont.systemFont(ofSize: 39)
            scoreLabel.text = "\(score) attemps left"
            view.addSubview(scoreLabel)

            currentAnswer = UILabel()
            currentAnswer.translatesAutoresizingMaskIntoConstraints = false
            currentAnswer.text = "??????"
            currentAnswer.textAlignment = .center
            currentAnswer.font = UIFont.systemFont(ofSize: 44)
            currentAnswer.isUserInteractionEnabled = false
            view.addSubview(currentAnswer)

            let buttonsView = UIView()
            buttonsView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(buttonsView)

            NSLayoutConstraint.activate([
                currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
                currentAnswer.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
                currentAnswer.heightAnchor.constraint(equalToConstant: 500),

                scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                scoreLabel.heightAnchor.constraint(equalToConstant: 700),

                buttonsView.widthAnchor.constraint(equalToConstant: 600),
                buttonsView.heightAnchor.constraint(equalToConstant: 320),
                buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                buttonsView.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 20),
                buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)

            ])

            let width = 100
            let height = 50

            for row in 0..<6 {
                for col in 0..<6 {
                    let letterButton = UIButton(type: .system)
                    letterButton.layer.borderWidth = 0.5
                    letterButton.layer.borderColor = UIColor.gray.cgColor
                    letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 28)

                    letterButton.setTitle("W", for: .normal)
                    letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)

                    // calculate the frame of this button using its column and row
                    let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                    letterButton.frame = frame

                    // add it to the buttons view
                    buttonsView.addSubview(letterButton)

                    // and also to our letterButtons array
                    letterButtons.append(letterButton)
                }
            }
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            reload()
        }

        @objc func letterTapped(_ sender: UIButton) {
            var a = [Character]()
            var b = [Character]()
            guard let buttonTitle = sender.titleLabel?.text else { return }
            guard let current = currentAnswer.text else { return }
            print(current)
            for character in current {
                a.append(character)
            }
            for character in answer {
                b.append(character)
            }
            if answer.contains(buttonTitle) {
                for i in 0..<answer.count {
                    if b[i] == Character(buttonTitle) {
                        a[i] = Character(buttonTitle)
                    }
                    currentAnswer.text? = ""
                    for character in a {
                        currentAnswer.text? += String(character)
                    }
                    activatedButtons.append(sender)
                    sender.isHidden = true

                    guard let current1 = currentAnswer.text else { return }
                    if current1 == answer {
                        let ac = UIAlertController(title: "You won!", message: "Correct word: \(answer)", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: reload))
                        present(ac, animated: true)
                    }
                }
            } else {
                score -= 1
                if score == 0 {
                    let ac = UIAlertController(title: "Game over!", message: "Correct word: \(answer)", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: reload))
                    present(ac, animated: true)
                }

            }
        }

            func reload(_ action: UIAlertAction? = nil) {
                var sixRandom = [String]()
                var letterBits = [Character]()
                for btn in activatedButtons {
                    btn.isHidden = false
                }
                score = 3
                currentAnswer.text = "??????"


                if let levelFileURL = Bundle.main.url(forResource: "start copy", withExtension: "txt") {

                    if let levelContents = try? String(contentsOf: levelFileURL) {
                        var lines = levelContents.components(separatedBy: "\n")
                        lines.shuffle()

                        for i in 0..<6 {
                            sixRandom.append(lines[i])
                            for character in lines[i] {
                                letterBits.append(character)
                            }
                            letterBits.shuffle()
                        }
                        for i in 0..<letterBits.count {
                            letterButtons[i].setTitle(String(letterBits[i]), for: .normal)

                        }
                    }
                    answer = sixRandom.randomElement() ?? "no"
                    print(answer)
                }
            }
        }


