package controllers;

import models.Library;
import play.data.validation.Required;
import play.mvc.Controller;

public class LibraryCreationController extends Controller {

	public static void createLibraryForm() {
		render("@Application.Library.createLibrary");
	}
	
	public static void createLibrary(
						@Required(message = "A név kötelező!")
						String libraryName, 
						@Required(message = "Az irányítószám kötelező!") 
						String libraryPostcode) {
		
		Integer postcode = null;
		if (!isInteger(libraryPostcode)) {
			/**
			 * 1. paraméter - melyik inputon keletkezett a hiba
			 * 2. paraméter - a szöveg, amit a usernek ki akarunk írni
			 */
			validation.addError("libraryPostcode", "Az irányítószám nem lehet szöveges adat!");
		} else {
			postcode = Integer.valueOf(libraryPostcode);
			
			/**
			 * A helyes, elvárt input negáltját vizsgáltuk
			 */
			if (postcode >= 10000 || postcode < 1000) {
				validation.addError("libraryPostcode", 
						"Az irányítószám 1000 és 10000 közötti kell legyen");
			}
		}
		/**
		 * Futtatunk egy selectet név alapján
		 */
		Library library = Library.find(" libraryName = ? ", libraryName).first();
		if (library != null) { //akkor lesz != null, ha már létezik!
			validation.addError("libraryName", "Ilyen nevű könyvtár már létezik");
		}
		
		/**
		 * Nézzük meg, vannak-e errorok
		 * Ha igen, visszadobjuk a usert a formra
		 */
		if (validation.hasErrors()) {
			params.flash(); //átmásoljuk a paramétereket. Flash - az előző request paraméterei
			render("@Application.Library.createLibrary");
		} else {
			/**
			 * Mentés az adatbázisba
			 */
			library = new Library();
			library.libraryName = libraryName;
			library.libraryPostcode = Integer.valueOf(libraryPostcode);
			library.save(); //ekkor fut le az INSERT gyakorlatilag
			
			/**
			 * Átirányítás a könyvtárakat listázó oldalra
			 */
			LibraryController.libraryBooks(null);
		}
	}
	
	private static boolean isInteger(String string) {
		try {
			Integer integer = Integer.valueOf(string);
			return true;
		} catch (NumberFormatException nfe) {
			return false;
		}
	}
}
