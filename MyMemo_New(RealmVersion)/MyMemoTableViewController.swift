//
//  MyMemoTableViewController.swift
//  MyMemo_New(RealmVersion)
//
//  Created by 塩澤響 on 2019/09/07.
//  Copyright © 2019 塩澤響. All rights reserved.
//

import UIKit
import RealmSwift

class MyMemoTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
        //Editボタンを配置
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        //データの保存先のURLの表示
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    
    
    
    
    
    
    
    
    //+ボタンを押した時の処理
    @IBAction func didTappedAddButton(_ sender: Any) {
        let alert = UIAlertController(title: "URLを追加しますか", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "追加", style: .default) { (void) in
            let textField = alert.textFields![0] as UITextField
            if let text = textField.text{
                
                //MyMemo()をインスタンス化
                let myMemo = MyMemo()
                let realm = try! Realm()
                let myMemos = realm.objects(MyMemo.self)

                myMemo.text = text
                myMemo.order = myMemos.count
                
                //Realmをインスタンス化
                //realmにデータ(class：MyMemo)を保存
                
                try! realm.write {
                    realm.add(myMemo)
                    
                    //tableViewをリロード
                    self.tableView.reloadData()
                }
            }
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alert.addTextField { (textField) in
            textField.placeholder = "URLを追加してください"
        }
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert,animated: true,completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
       let realm = try! Realm()
       let myMemos = realm.objects(MyMemo.self)
        
        return myMemos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        let realm = try! Realm()
        let myMemos = realm.objects(MyMemo.self)
        
        for i in 0..<myMemos.count{
            if myMemos[i].order == indexPath.row{
               cell.textLabel?.text = myMemos[i].text
            }
        }
        
        return cell
    }
    
    
    
    
    

    // Override to support conditional editing of the table view.
    //セルの編集を許可
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    //消去されたときの処理
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let realm = try! Realm()
            let myMemos = realm.objects(MyMemo.self)
            //let myMemo = myMemos[indexPath.row]
            
            try! realm.write {
                
                //この条件分岐はいらないかもしれないけど直すのめんどい
                if indexPath.row == myMemos[indexPath.row].order{
                    print("text:\(myMemos[indexPath.row].text),order:\(myMemos[indexPath.row].order)を消去")
                    realm.delete(myMemos[indexPath.row])
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }else{
                    //realmの要素の個数分ループ
                    for i in 0..<myMemos.count{
                        print("indexPath.row:\(indexPath.row),[i].order:\(myMemos[i].order)")
                        if myMemos[i].order == indexPath.row{
                            print("text:\(myMemos[i].text),order:\(myMemos[i].order)を消去")
                            let deleteMyMemo = myMemos[i]
                            realm.delete(deleteMyMemo)
                            tableView.deleteRows(at: [indexPath], with: .fade)
                            //消去したらbreakする
                            break
                        }
                    }
                }
                
                //orderの更新をする
                for i in 0..<myMemos.count{
                    if myMemos[i].order < indexPath.row{
                        print("text:\(myMemos[i].text),order:\(myMemos[i].order),変更なし")
                        //orderに変更なし
                    } else if myMemos[i].order > indexPath.row{
                        myMemos[i].order -= 1
                        print("text:\(myMemos[i].text),order:\(myMemos[i].order+1),変更（-1)→\(myMemos[i].order)")
                    }
                }
                print("\n")
            }
            
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
        } /*else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }*/
    }

    
    
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        //並び替えの処理を書く
        
        let realm = try! Realm()
        let myMemos = realm.objects(MyMemo.self)
       for i in 0..<myMemos.count{
            if myMemos[i].order == fromIndexPath.row{
                
                //fromからtoにorderを変更
                print("order変更：\(myMemos[i].order)(\(fromIndexPath.row))→\(to.row)")
                myMemos[i].order = to.row
                //移動先が上か下かで条件分岐
                //上に移動した場合
                /*if fromIndexPath.row > to.row{
                    for j in to.row..<fromIndexPath.row{
                        
                    }
                }
                //下に移動した場合
                else if fromIndexPath.row < to.row{
                    for j in fromIndexPath.row+1..<to.row{
                        
                    }
                }*/
            }
        }
        
        //これが配列を使った場合の処理
        /*let moveData = tableView.cellForRow(at: fromIndexPath)?.textLabel?.text
        list.remove(at: fromIndexPath.row)
        list.insert(moveData!, at: to.row)*/
    }
    
    //Override to support conditional rearranging of the table view.
    //セルの並び替えを許可
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
