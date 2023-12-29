//
//  LoanStore.swift
//  SwiftUIKivaLoan
//
//  Created by Aman Gupta on 29/12/23.
//

import Foundation

class LoanStore: Decodable, ObservableObject{
    @Published var loans: [Loan] = []
    private static var kivaLoanUrl = "https://api.kivaws.org/v1/loans/newest.json"
    
    enum CodingKeys: CodingKey{
        case loans
    }
    required init(from decoder: Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        loans = try values.decode([Loan].self, forKey: .loans)
        
    }
    init(){
        
    }
    
    func fetchLatestLoans(){
        guard let loanUrl = URL(string: Self.kivaLoanUrl) else{
            return
        }
        
        let request = URLRequest(url: loanUrl)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error)-> Void in
            
            if let error = error {
                print(error)
                return
            }
            
            if let data = data{
                DispatchQueue.main.async{
                    self.loans = self.parseJsonData(data: data)
                    
                }
            }
                
        })
        task.resume()
    }
    
    func parseJsonData(data: Data)->[Loan]{
        let decoder = JSONDecoder()
        do{
            let loanStore = try decoder.decode(LoanStore.self, from: data)
            self.loans = loanStore.loans
        }catch{
            print(error)
        }
        return loans
    }
    
}
