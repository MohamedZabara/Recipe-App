import KRProgressHUD
import Alamofire
import Foundation

class RecipeApi{
        
    func fetchData(search q:String?,filter health:String?,from:Int?,operation:RecipeModel.OperationChosen,completion:@escaping(Hits?,Bool)->Void){
        var endPoint = Constamt.startUrlPoint+"&q=\(q ?? "random")&from=\(from!)"

       
        
        switch operation {
        case .searching:
            KRProgressHUD.show(withMessage: "Loading...")
            break
        case .filtering:
            KRProgressHUD.show(withMessage: "Loading...")
            guard let health = health else{
                return
            }
            endPoint = endPoint + "&health=\(health)"
        case .pagination:
            if let health = health{
                endPoint = endPoint + "&health=\(health)"
            }

        }
        
        
        
        let request = AF.request(endPoint)
        
        request.responseJSON { (response) in
            switch response.result {
            case .success:
                guard let data = response.data else {return}
             
          
                
                let hitsResult = self.parseJson(data: data)
                KRProgressHUD.dismiss()
                if let hitsResult = hitsResult {
                    completion(hitsResult,false)

                }else{
                     completion(nil,true)
                }
             
                
            case .failure(let error):
                KRProgressHUD.dismiss()
                completion(nil,true)
                print(error)
                break
                // error handling
            }
        }
        
        
    }
    
    
    func parseJson(data:Data)->Hits?{
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try decoder.decode(Hits.self, from: data)
//                    print(result.hits![0]["recipe"]?.label)
            return result
            //completion(result,false)
            
        } catch {
            print(error.localizedDescription)
            return nil
           // completion(nil,true)

        }
    }
}
