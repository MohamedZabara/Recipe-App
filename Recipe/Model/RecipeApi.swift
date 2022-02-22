import KRProgressHUD
import Alamofire
import Foundation

class RecipeApi{
        
    func fetchData(search q:String?,filter health:String?,from:Int?,completion:@escaping(Hits?,Bool)->Void){
        let endPoint = Constamt.startUrlPoint+"&q=\(q ?? "random")&from=\(from!)"

        let request = AF.request(endPoint)
        
        request.responseJSON { (response) in
            switch response.result {
            case .success:
                guard let data = response.data else {return}
             
          
                
                let hitsResult = self.parseJson(data: data)
                if let hitsResult = hitsResult {
                    completion(hitsResult,false)

                }else{
                     completion(nil,true)
                }
             
                
            case .failure(let error):
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
