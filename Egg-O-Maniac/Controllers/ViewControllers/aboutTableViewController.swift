//
//  aboutTableViewController.swift
//  EggTimer
//
//  Created by Maxence Gama on 31/10/2020.
//

import UIKit
import SafariServices

class aboutTableViewController: UITableViewController {
    
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBAction func closeButton(_ sender: UIBarButtonItem) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
                                       
        dismiss(animated: true, completion: nil)
    }
    /*
    let buttonsColorsList = [UIColor(hexString: "#456576", alpha: 1),//default
                             UIColor(hexString: "#007562", alpha: 1),//cyan
                             UIColor(hexString: "#440000", alpha: 1),//rouge
                             UIColor(hexString: "#0c4023", alpha: 1),//vert
                             UIColor(hexString: "#785710", alpha: 1),//jaune
                             UIColor(hexString: "#41184a", alpha: 1),//violet
                             UIColor(hexString: "#992f19", alpha: 1),//saumon
                             UIColor(hexString: "#303030", alpha: 1),//gris
                             UIColor(hexString: "#a29c9f", alpha: 1)]//blanc
    */
    var sectionTitres = ["Votre avis nous interesse".localized(), "Suivez-nous".localized(), " "]
    var sectionContenu = [[(image: "store", text: "Évaluer-nous sur l'App Store".localized(), link: "itms-apps://apple.com/app/"),
                           (image: "chat", text: "Donnez-nous votre avis".localized(), link: "itms-apps://apple.com/app/"),
                           (image: "report", text: "Signaler un bug".localized(), link: ""),],
                          [(image: "instagram", text: "Instagram", link: "https://www.instagram.com/maxencegama/")],
                          [(image: "deleteadd", text: "Supprimer les pubs".localized(), link: "")]]

    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPresentation = true
        let newRow = UserDefaults.standard.object(forKey: "row") as? Int
        
        if ((UserDefaults.standard.object(forKey: "row") as? Int) != nil) {
            closeButton.tintColor = ColorList.buttonsColorsList[newRow!]
        }
        
        tableView.cellLayoutMarginsFollowReadableWidth = true
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Personnalisation de la barre de navigation
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        if let customFont = UIFont(name: "Rubik-Medium", size: 40.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 153.0/255.0, alpha: 1.0), NSAttributedString.Key.font: customFont]
        }
        
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitres.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionContenu[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitres[section]
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutCell", for: indexPath)

        // Configure the cell...
        
        let cellData = sectionContenu[indexPath.section][indexPath.row]
        cell.textLabel?.text = cellData.text
        cell.imageView?.image = UIImage(named: cellData.image)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lien = sectionContenu[indexPath.section][indexPath.row].link
        
        switch indexPath.section {
            // Feedback section
        case 0:
            if let url = URL(string: lien) {
                UIApplication.shared.openURL(url)
            }
            if indexPath.row == 2 {
                performSegue(withIdentifier: "reportSegue", sender: self)
            }
            /*
            if indexPath.row == 0 {
                if let url = URL(string: lien) {
                    UIApplication.shared.openURL(url)
                }
            } else if indexPath.row == 1 {
                performSegue(withIdentifier: "showWebView", sender: self)
            }*/
            
        case 1:
            if let url = URL(string: lien) {
                let safariController = SFSafariViewController(url: url)
                present(safariController, animated: true, completion: nil)
            }
        case 2:
            performSegue(withIdentifier: "deleteadd", sender: self)
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation

}
