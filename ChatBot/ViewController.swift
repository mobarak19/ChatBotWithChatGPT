//
//  ViewController.swift
//  ChatBot
//
//  Created by Genusys Inc on 12/13/22.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {

    

    private let field:UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.placeholder = "Enter text..."
        field.backgroundColor = .red
        field.returnKeyType  = .done
        
        return field
    }()
    
    private var table:UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false

        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    @IBOutlet weak var imgIcon: UIImageView!
    
    private var models :[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(field)
        view.addSubview(table)
        field.delegate = self
        table.delegate = self
        table.dataSource = self
        NSLayoutConstraint.activate([
            field.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            field.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            field.heightAnchor.constraint(equalToConstant: 50),
            field.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            table.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.bottomAnchor.constraint(equalTo:field.topAnchor)
        ])
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        view.addGestureRecognizer(tap)
        
        
        let fight = Flight()
        let queue1 : DispatchQueue = DispatchQueue(label: "queue1")
        let queue2 : DispatchQueue = DispatchQueue(label: "queue2")
            queue1.async {
                Task{
                    let bookedSeat:String = await fight.bookSeat()
                    print(bookedSeat)
                }
            }
            
            queue2.async {
                Task{
                    let availableSeats:[String] =  await fight.getAvaiableSeats()
                    print(availableSeats)
                }
            }
        
        table.isHidden = true

        imgIcon.loadPng(name: "08")
        
    }
    @objc func onTap(){
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else{return true}
        APICaller.shared.getResponse(input: text) { [weak self] result in
            switch result{
            case .success(let model):
                print(model)
                self?.models.append(model)
                DispatchQueue.main.async {
                    self?.table.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        return true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = models[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}

