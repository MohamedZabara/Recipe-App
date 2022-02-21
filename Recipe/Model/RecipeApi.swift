
import Alamofire
import Foundation

class RecipeApi{
        
    func fetchData(search q:String = "All",filter health:String?,completion:@escaping(Hits?,Bool)->Void){
        let request = AF.request("https://api.edamam.com/search?q=chicken&app_id=9a736ed0&app_key=676d133db1fa8609950d571bf7eaed01&from=0")
        
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
