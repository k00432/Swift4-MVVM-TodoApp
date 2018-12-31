import UIKit
import os.log

class ItemView: UIViewController {
    /*------------------------------------------------view------------------------------------------------------*/
    @IBOutlet var textArea: UITextField!
    @IBOutlet var placeHolder: UILabel!
    /*------------------------------------------------viewModel-------------------------------------------------*/
    var viewModel:ItemViewModel = ItemViewModel();
    /*------------------------------------------------funcs-----------------------------------------------------*/
    override func viewDidLoad() {
        os_log(.info,"ItemView -> viewDidLoad func : exec")
        self.textArea.text = viewModel.todo.text;
        self.placeHolderHide();
    }
    
    func placeHolderHide(){
        os_log(.info,"ItemView -> placeHolderHide func : exec")
        let isTextEmpty = textArea.text!.isEmpty;
        os_log(.info,"ItemView -> placeHolderHide func : isplaceHolderHide == %d",!isTextEmpty)
        self.placeHolder.isHidden = !isTextEmpty;
    }
    
    @IBAction func tapTextArea(_ sender: Any) {
        os_log(.info,"ItemView -> tapTextArea func : exec (change TextArea)")
        self.placeHolderHide();
    }

    @IBAction func tapSaveButton(_ sender: Any) {
        os_log(.info,"ItemView -> tapSaveButton func : exec (save/edit TextArea)")
        viewModel.saveText(textArea: textArea.text!,completion:{(isSucc) in
            os_log(.info,"ItemView -> tapSaveButton func : isSucc == %d",isSucc)
            self.navigationController?.popViewController(animated: true)
        })
    }

    
}
